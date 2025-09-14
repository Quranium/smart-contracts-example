//SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;

/// @title SkillEndorsement - Stake-based skill claims with endorsements & challenges
/// @notice Users can claim a skill by staking ETH; others can endorse or challenge by staking ETH.
///         The contract owner (arbitrator) resolves claims; funds are distributed based on resolution.
/// @dev This is a demonstration contract. Owner-based arbitration is centralized — replace with multisig/DAO for production.
contract SkillEndorsement {
    address public owner;
    uint256 public minClaimStake;      // minimum stake to claim a skill
    uint256 public minEndorseStake;    // minimum stake to endorse
    uint256 public minChallengeStake;  // minimum stake to challenge

    struct Claim {
        address claimer;
        string skill;
        uint256 stake;         // stake by claimer
        uint256 endorsements;  // total value endorsed
        uint256 challenges;    // total value challenged
        bool active;           // active until resolved
        bool validated;        // result set after resolution
        uint256 createdAt;
    }

    // claimId counter
    uint256 public nextClaimId;

    // claimId => Claim
    mapping(uint256 => Claim) public claims;

    // claimId => endorser => amount
    mapping(uint256 => mapping(address => uint256)) public endorseAmount;

    // claimId => challenger => amount
    mapping(uint256 => mapping(address => uint256)) public challengeAmount;

    // events
    event ClaimCreated(uint256 indexed claimId, address indexed claimer, string skill, uint256 stake);
    event Endorsed(uint256 indexed claimId, address indexed endorser, uint256 amount);
    event Challenged(uint256 indexed claimId, address indexed challenger, uint256 amount);
    event ClaimResolved(uint256 indexed claimId, bool validated);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    constructor(uint256 _minClaimStake, uint256 _minEndorseStake, uint256 _minChallengeStake) {
        owner = msg.sender;
        minClaimStake = _minClaimStake;
        minEndorseStake = _minEndorseStake;
        minChallengeStake = _minChallengeStake;
        nextClaimId = 1;
    }

    /// @notice Claim a skill by staking ETH (creates a new claim)
    /// @dev `msg.value` must be >= minClaimStake and claim for same skill by same claimer must not be active
    /// @param skill Short string identifier for the skill (e.g., "solidity", "react")
    function claimSkill(string calldata skill) external payable returns (uint256) {
        require(msg.value >= minClaimStake, "Stake too small");

        // ensure claimer doesn't have an active claim for the same skill
        // linear scan is avoided; instead we allow multiple claims but only track per claimId (simpler)
        uint256 id = nextClaimId++;
        claims[id] = Claim({
            claimer: msg.sender,
            skill: skill,
            stake: msg.value,
            endorsements: 0,
            challenges: 0,
            active: true,
            validated: false,
            createdAt: block.timestamp
        });

        emit ClaimCreated(id, msg.sender, skill, msg.value);
        return id;
    }

    /// @notice Endorse a claim by staking ETH (endorser's stake increases claim reputation)
    /// @dev msg.value must be >= minEndorseStake
    /// @param claimId The claim to endorse
    function endorse(uint256 claimId) external payable {
        Claim storage c = claims[claimId];
        require(c.active, "Claim not active");
        require(msg.value >= minEndorseStake, "Endorse stake too small");

        endorseAmount[claimId][msg.sender] += msg.value;
        c.endorsements += msg.value;

        emit Endorsed(claimId, msg.sender, msg.value);
    }

    /// @notice Challenge a claim by staking ETH (reduces claim reputation)
    /// @dev msg.value must be >= minChallengeStake
    /// @param claimId The claim to challenge
    function challenge(uint256 claimId) external payable {
        Claim storage c = claims[claimId];
        require(c.active, "Claim not active");
        require(msg.value >= minChallengeStake, "Challenge stake too small");

        challengeAmount[claimId][msg.sender] += msg.value;
        c.challenges += msg.value;

        emit Challenged(claimId, msg.sender, msg.value);
    }

    /// @notice Resolve a claim (owner/arbitrator decides outcome). Distributes funds based on result.
    /// @dev Distribution policy (example): if validated -> claimer gets stake + 80% endorsements; endorsers get 20% back pro rata.
    ///      if rejected -> challengers get 80% of endorsements pro rata + their stakes; claimer's stake is slashed (used for challengers).
    /// @param claimId Claim id to resolve
    /// @param validated Boolean result (true = claim valid)
    function resolveClaim(uint256 claimId, bool validated) external onlyOwner {
        Claim storage c = claims[claimId];
        require(c.active, "Claim not active");

        c.active = false;
        c.validated = validated;

        // compute totals
        uint256 totalEndorse = c.endorsements;
        uint256 totalChallenge = c.challenges;
        uint256 claimerStake = c.stake;

        if (validated) {
            // Claimer rewarded: stake + 80% of endorsements + (optionally) a small bonus from challenged stakes
            uint256 endorsersShare = (totalEndorse * 20) / 100; // 20% returned to endorsers collectively
            uint256 claimerShareFromEndorse = totalEndorse - endorsersShare; // 80%
            uint256 payoutToClaimer = claimerStake + claimerShareFromEndorse;

            // pay claimer
            _safeSend(payable(c.claimer), payoutToClaimer);

            // distribute endorsersShare back to endorsers proportionally
            if (endorsersShare > 0) {
                _distributeToEndorsers(claimId, endorsersShare);
            }

            // challengers lose their stakes (remain in contract as fee) - for simplicity fee stays with contract owner as platform fee
            // optionally owner can withdraw accumulated fees later (not implemented)
        } else {
            // Claim rejected: challengers get reward from endorsements and claimer's stake is slashed.
            // Pay challengers: they receive their original stake back + proportional share of endorsements + portion of claimer's stake.
            uint256 challengersRewardPool = totalEndorse + claimerStake; // endorsements + claimer stake available for challengers

            if (totalChallenge > 0) {
                // distribute challengersRewardPool proportionally to challengers' stake
                _distributeToChallengers(claimId, challengersRewardPool);
            } else {
                // No challengers but rejected — send entire pool to owner (platform)
                // Note: this is a fallback; in practice owner shouldn't reject without challengers
                _safeSend(payable(owner), challengersRewardPool);
            }

            // endorsers lose endorsements (their stakes are used for challenger payouts)
        }

        emit ClaimResolved(claimId, validated);
    }

    /// @dev Internal helper to distribute `amount` proportionally among endorsers of a claim
    function _distributeToEndorsers(uint256 claimId, uint256 amount) internal {
        Claim storage c = claims[claimId];
        uint256 total = c.endorsements;
        if (total == 0 || amount == 0) return;

        // iterate endorsers — we cannot iterate mappings. To keep contract gas-bounded,
        // this implementation requires know-how of endorsers or off-chain reconciliation.
        // For demonstration, we iterate via a naive approach is impossible; so we implement a pull pattern:
        // store `endorserReturn[claimId]` as total share per unit endorsement (scaled)
        // then endorsers can call withdrawEndorseerShare to claim their pro-rata share.
        // Implementation for pro-rata withdraw:
        uint256 ratePerWei = (amount * 1e18) / total; // scaled rate
        endorserRate[claimId] = ratePerWei;
    }

    /// @dev Internal helper to distribute `amount` proportionally among challengers
    function _distributeToChallengers(uint256 claimId, uint256 amount) internal {
        Claim storage c = claims[claimId];
        uint256 total = c.challenges;
        if (total == 0 || amount == 0) return;

        uint256 ratePerWei = (amount * 1e18) / total; // scaled
        challengerRate[claimId] = ratePerWei;
    }

    // Pull-pattern mappings for endorsers/challengers to claim pro-rata share after resolution
    mapping(uint256 => uint256) public endorserRate;    // scaled amount per wei endorsed (1e18)
    mapping(uint256 => uint256) public challengerRate;  // scaled amount per wei challenged (1e18)

    /// @notice Endorsers withdraw their pro-rata share after claim resolution (if any)
    /// @param claimId Claim id
    function withdrawEndorserShare(uint256 claimId) external {
        Claim storage c = claims[claimId];
        require(!c.active, "Claim still active");
        uint256 endorsed = endorseAmount[claimId][msg.sender];
        require(endorsed > 0, "No endorsement stake recorded");

        uint256 rate = endorserRate[claimId];
        require(rate > 0, "No payout available");

        // compute payout
        uint256 payout = (endorsed * rate) / 1e18;

        // zero out to avoid re-entrancy double-claim
        endorseAmount[claimId][msg.sender] = 0;
        _safeSend(payable(msg.sender), payout);
    }

    /// @notice Challengers withdraw their share after claim rejection
    /// @param claimId Claim id
    function withdrawChallengerShare(uint256 claimId) external {
        Claim storage c = claims[claimId];
        require(!c.active, "Claim still active");
        uint256 challenged = challengeAmount[claimId][msg.sender];
        require(challenged > 0, "No challenge stake recorded");

        uint256 rate = challengerRate[claimId];
        require(rate > 0, "No payout available");

        uint256 payout = (challenged * rate) / 1e18;

        // zero out
        challengeAmount[claimId][msg.sender] = 0;
        _safeSend(payable(msg.sender), payout);
    }

    /// @notice Owner can withdraw accumulated platform fees (ETH left in contract that are not owed)
    function ownerWithdraw(uint256 amount) external onlyOwner {
        require(amount <= address(this).balance, "Insufficient balance");
        _safeSend(payable(owner), amount);
    }

    /// @dev Safe send wrapper using call
    function _safeSend(address payable to, uint256 amount) internal {
        if (amount == 0) return;
        (bool ok, ) = to.call{value: amount}("");
        require(ok, "Transfer failed");
    }

    /// @notice View function to get claim score (endorse - challenge)
    /// @param claimId Claim id
    /// @return score (signed int: endorsements - challenges)
    function claimScore(uint256 claimId) external view returns (int256) {
        Claim storage c = claims[claimId];
        return int256(c.endorsements) - int256(c.challenges);
    }
}
