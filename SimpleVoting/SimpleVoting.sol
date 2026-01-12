// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleVoting {
    address public owner;
    string[] public candidates;
    mapping(string => uint256) public votes;
    mapping(address => bool) public hasVoted;
    bool public votingActive;

    constructor(string[] memory _candidates) {
        owner = msg.sender;
        candidates = _candidates;
        votingActive = true;
    }

    function vote(string memory _candidate) external {
        require(votingActive, "Voting is not active");
        require(!hasVoted[msg.sender], "You have already voted");

        bool valid = false;
        for (uint i = 0; i < candidates.length; i++) {
            if (
                keccak256(bytes(candidates[i])) == keccak256(bytes(_candidate))
            ) {
                valid = true;
                break;
            }
        }

        require(valid, "Invalid candidate");
        votes[_candidate]++;
        hasVoted[msg.sender] = true;
    }

    function endVoting() external {
        require(msg.sender == owner, "Only owner can end voting");
        votingActive = false;
    }

    function getVotes(string memory _candidate) external view returns (uint256) {
        return votes[_candidate];
    }

    function getAllCandidates() external view returns (string[] memory) {
        return candidates;
    }
}
