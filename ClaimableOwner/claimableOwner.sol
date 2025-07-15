// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ClaimableOwner {
    address public owner;
    bool public isClaimed;

    event OwnershipClaimed(address indexed claimer);
    event FundsReceived(address indexed from, uint256 amount);
    event Withdrawn(address indexed to, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier notYetClaimed() {
        require(!isClaimed, "Ownership already claimed");
        _;
    }

    // Claim ownership (can only be done once)
    function claimOwnership() external notYetClaimed {
        owner = msg.sender;
        isClaimed = true;
        emit OwnershipClaimed(msg.sender);
    }

    // Accept ETH payments
    receive() external payable {
        emit FundsReceived(msg.sender, msg.value);
    }

    // Owner can withdraw funds
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Nothing to withdraw");
        payable(owner).transfer(balance);
        emit Withdrawn(owner, balance);
    }

    // Utility function to get contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
