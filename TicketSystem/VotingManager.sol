// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "TicketSystem/VotingTicket.sol";

/// @title VotingManager - Controls ticket issuing process
contract VotingManager {
    VotingTicket public ticketContract;
    address public admin;

    mapping(address => bool) public hasClaimed;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    function setAdmin(address _admin) external {
        require(admin == address(0), "Admin already set");
        admin = _admin;
    }

    function setTicketContract(address _contract) external onlyAdmin {
        require(address(ticketContract) == address(0), "Already set");
        ticketContract = VotingTicket(_contract);
    }

    function claimTicket() external {
        require(!hasClaimed[msg.sender], "Already claimed");
        hasClaimed[msg.sender] = true;
        ticketContract.issueTicket(msg.sender);
    }

    function invalidateUser(address user) external onlyAdmin {
        ticketContract.invalidateTicket(user);
    }
}
