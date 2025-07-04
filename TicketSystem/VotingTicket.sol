// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title VotingTicket - ERC-like voting ticket system
contract VotingTicket {
    string public name = "VotingTicket";
    string public symbol = "VOTE";
    mapping(address => bool) public hasTicket;
    mapping(address => bool) public isValid;

    event TicketClaimed(address indexed user);
    event TicketInvalidated(address indexed user);

    function issueTicket(address user) external {
        require(!hasTicket[user], "Ticket already claimed");
        hasTicket[user] = true;
        isValid[user] = true;
        emit TicketClaimed(user);
    }

    function invalidateTicket(address user) external {
        require(hasTicket[user], "User has no ticket");
        isValid[user] = false;
        emit TicketInvalidated(user);
    }

    function hasValidTicket(address user) external view returns (bool) {
        return hasTicket[user] && isValid[user];
    }
}
