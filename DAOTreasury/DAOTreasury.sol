// Welcome to Q Remix IDE! 
// Visit all Quranium websites at: https://quranium.org
// Write your Solidity contract here...
// pragma solidity ^0.8.7;
// contract MyContract {
// Your contract code goes here
// }
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DAOTreasury {
    address public admin;
    mapping(address => bool) public members;
    uint256 public memberCount;

    struct Proposal {
        address payable recipient;
        uint256 amount;
        uint256 yesVotes;
        bool executed;
        mapping(address => bool) voted;
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

    bool public initialized;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    modifier onlyMember() {
        require(members[msg.sender], "Not a member");
        _;
    }

    function initialize(address _admin, address[] memory _members) public {
        require(!initialized, "Already initialized");
        admin = _admin;
        initialized = true;

        for (uint256 i = 0; i < _members.length; i++) {
            members[_members[i]] = true;
            memberCount++;
        }
    }

    function createProposal(address payable _to, uint256 _amount) external onlyMember returns (uint256) {
        Proposal storage p = proposals[proposalCount];
        p.recipient = _to;
        p.amount = _amount;
        proposalCount++;

        return proposalCount - 1;
    }

    function vote(uint256 _proposalId) external onlyMember {
        Proposal storage p = proposals[_proposalId];
        require(!p.executed, "Already executed");
        require(!p.voted[msg.sender], "Already voted");

        p.voted[msg.sender] = true;
        p.yesVotes++;
    }

    function execute(uint256 _proposalId) external {
        Proposal storage p = proposals[_proposalId];
        require(!p.executed, "Already executed");
        require(p.yesVotes > memberCount / 2, "Not enough votes");
        require(address(this).balance >= p.amount, "Insufficient balance");

        p.executed = true;
        p.recipient.transfer(p.amount);
    }

    // Accept Ether
    receive() external payable {}
}
