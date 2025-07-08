// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title SimpleVoting - A basic voting contract where anyone can create proposals and vote.
contract SimpleVoting {
    // Structure to represent a proposal
    struct Proposal {
        string description;   // Description of the proposal
        uint256 voteCount;    // Number of votes received
    }

    Proposal[] public proposals; // Dynamic array to store all proposals

    // Mapping to track if an address has voted on a specific proposal
    mapping(address => mapping(uint256 => bool)) public hasVoted;

    /// @notice Create a new proposal with a description
    /// @param description The text describing the proposal
    function createProposal(string memory description) public {
        proposals.push(Proposal({description: description, voteCount: 0}));
    }

    /// @notice Vote for a proposal by its ID
    /// @param proposalId The index of the proposal in the proposals array
    function vote(uint256 proposalId) public {
        require(proposalId < proposals.length, "Invalid proposal");
        require(!hasVoted[msg.sender][proposalId], "Already voted");
        proposals[proposalId].voteCount += 1;
        hasVoted[msg.sender][proposalId] = true;
    }

    /// @notice Get the details of a proposal
    /// @param proposalId The index of the proposal in the proposals array
    /// @return description The proposal's description
    /// @return voteCount The number of votes the proposal has received
    function getProposal(uint256 proposalId) public view returns (string memory description, uint256 voteCount) {
        require(proposalId < proposals.length, "Invalid proposal");
        Proposal storage p = proposals[proposalId];
        return (p.description, p.voteCount);
    }
}
