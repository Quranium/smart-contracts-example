// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title DecentralizedTalentShow - Multi-contest voting DApp with pay-to-vote & prize pooling
/// @notice Create contests, submit entries (IPFS hash), let the community vote by paying a small fee. After deadline, finalize to pay winner with a platform fee.
/// @dev Uses pull/push payouts. Prevents double-voting per submission per contest. Platform owner collects fee on finalize.
contract DecentralizedTalentShow {
    address public owner;
    uint256 public platformFeeBps; // basis points (e.g., 500 = 5%)

    struct Contest {
        string title;
        uint256 startBlock;
        uint256 endBlock;
        uint256 submissionCount;
        uint256 prizePool; // accumulated from votes
        bool finalized;
        uint256 winningSubmissionId;
    }

    struct Submission {
        address creator;
        string ipfsHash; // content pointer
        uint256 votes;   // total vote weight (sum of vote fees)
        bool active;
    }

    uint256 public nextContestId = 1;

    // contestId => Contest
    mapping(uint256 => Contest) public contests;

    // contestId => submissionId => Submission
    mapping(uint256 => mapping(uint256 => Submission)) public submissions;

    // contestId => submissionId => mapping(voter => bool) to prevent double voting per submission
    mapping(uint256 => mapping(uint256 => mapping(address => bool))) public voted;

    // events
    event ContestCreated(uint256 indexed contestId, string title, uint256 startBlock, uint256 endBlock);
    event SubmissionAdded(uint256 indexed contestId, uint256 indexed submissionId, address indexed creator, string ipfsHash);
    event Voted(uint256 indexed contestId, uint256 indexed submissionId, address indexed voter, uint256 amount);
    event ContestFinalized(uint256 indexed contestId, uint256 indexed winningSubmissionId, uint256 payoutAmount, uint256 ownerFee);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    constructor(uint256 _platformFeeBps) {
        owner = msg.sender;
        platformFeeBps = _platformFeeBps;
    }

    /// @notice Create a new contest
    /// @param title Contest title
    /// @param startBlock Block when voting/submissions start
    /// @param endBlock Block when contest ends (finalize allowed after this)
    function createContest(string calldata title, uint256 startBlock, uint256 endBlock) external onlyOwner returns (uint256) {
        require(endBlock > startBlock, "Invalid block range");
        uint256 id = nextContestId++;
        contests[id] = Contest({
            title: title,
            startBlock: startBlock,
            endBlock: endBlock,
            submissionCount: 0,
            prizePool: 0,
            finalized: false,
            winningSubmissionId: 0
        });

        emit ContestCreated(id, title, startBlock, endBlock);
        return id;
    }

    /// @notice Submit an entry for a contest
    /// @param contestId Contest id
    /// @param ipfsHash IPFS hash or content pointer
    function submitEntry(uint256 contestId, string calldata ipfsHash) external {
        Contest storage c = contests[contestId];
        require(block.number >= c.startBlock && block.number <= c.endBlock, "Contest not active");

        uint256 sid = ++c.submissionCount;
        submissions[contestId][sid] = Submission({
            creator: msg.sender,
            ipfsHash: ipfsHash,
            votes: 0,
            active: true
        });

        emit SubmissionAdded(contestId, sid, msg.sender, ipfsHash);
    }

    /// @notice Vote for a submission by paying a fee (vote weight equals msg.value)
    /// @dev Prevents same address voting multiple times for the same submission. However, an address may vote for multiple different submissions.
    /// @param contestId Contest id
    /// @param submissionId Submission id
    function vote(uint256 contestId, uint256 submissionId) external payable {
        Contest storage c = contests[contestId];
        require(block.number >= c.startBlock && block.number <= c.endBlock, "Contest not active");
        require(msg.value > 0, "Vote requires ETH");
        require(submissions[contestId][submissionId].active, "Invalid submission");
        require(!voted[contestId][submissionId][msg.sender], "Already voted this submission");

        // mark voter to prevent double-vote on same submission
        voted[contestId][submissionId][msg.sender] = true;

        // increment votes (weight by ETH)
        submissions[contestId][submissionId].votes += msg.value;

        // increase contest prize pool
        c.prizePool += msg.value;

        emit Voted(contestId, submissionId, msg.sender, msg.value);
    }

    /// @notice Finalize the contest after endBlock. Picks winner (highest votes) and distributes prize pool.
    /// @dev Owner receives platform fee. Anyone may call finalize after endBlock.
    /// @param contestId Contest id
    function finalizeContest(uint256 contestId) external {
        Contest storage c = contests[contestId];
        require(block.number > c.endBlock, "Contest not ended");
        require(!c.finalized, "Already finalized");

        // find winning submission (highest votes)
        uint256 bestId = 0;
        uint256 bestVotes = 0;
        for (uint256 i = 1; i <= c.submissionCount; i++) {
            if (submissions[contestId][i].votes > bestVotes) {
                bestVotes = submissions[contestId][i].votes;
                bestId = i;
            }
        }

        // compute fee and payout
        uint256 pool = c.prizePool;
        uint256 ownerFee = (pool * platformFeeBps) / 10000;
        uint256 payout = pool - ownerFee;

        if (bestId == 0) {
            // No submissions or no votes — owner keeps fee (which equals pool here)
            ownerFee = pool;
            payout = 0;
        } else {
            // pay winner creator
            _safeSend(payable(submissions[contestId][bestId].creator), payout);
        }

        // pay owner fee
        if (ownerFee > 0) {
            _safeSend(payable(owner), ownerFee);
        }

        c.finalized = true;
        c.winningSubmissionId = bestId;

        emit ContestFinalized(contestId, bestId, payout, ownerFee);
    }

    /// @dev Safe send using call
    function _safeSend(address payable to, uint256 amount) internal {
        if (amount == 0) return;
        (bool ok, ) = to.call{value: amount}("");
        require(ok, "Transfer failed");
    }

    /// @notice Get contest info
    function getContest(uint256 contestId) external view returns (
        string memory title,
        uint256 startBlock,
        uint256 endBlock,
        uint256 submissionCount,
        uint256 prizePool,
        bool finalized,
        uint256 winningSubmissionId
    ) {
        Contest storage c = contests[contestId];
        return (
            c.title,
            c.startBlock,
            c.endBlock,
            c.submissionCount,
            c.prizePool,
            c.finalized,
            c.winningSubmissionId
        );
    }

    /// @notice Get submission info for a contest
    function getSubmission(uint256 contestId, uint256 submissionId) external view returns (
        address creator,
        string memory ipfsHash,
        uint256 votes,
        bool active
    ) {
        Submission storage s = submissions[contestId][submissionId];
        return (s.creator, s.ipfsHash, s.votes, s.active);
    }

    /// @notice Owner can change platform fee (basis points)
    function setPlatformFee(uint256 bps) external onlyOwner {
        require(bps <= 2000, "Fee too high"); // max 20%
        platformFeeBps = bps;
    }

    /// @notice Owner withdraws any stuck ETH
    function ownerWithdraw(uint256 amount) external onlyOwner {
        require(amount <= address(this).balance, "Not enough balance");
        _safeSend(payable(owner), amount);
    }
}
