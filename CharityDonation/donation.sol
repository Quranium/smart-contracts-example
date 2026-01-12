// SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;

/// @title CharityDonationPool - Donation pool for charity projects
/// @notice Donors can contribute, and owner allocates funds to beneficiaries
/// @dev Tracks total donations and allows transparent withdrawals
contract CharityDonationPool {
    address public owner;
    uint256 public totalDonations;

    mapping(address => uint256) public donations;

    event Donated(address indexed donor, uint256 amount);
    event Allocated(address indexed beneficiary, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Donate Ether to the charity pool
    function donate() external payable {
        require(msg.value > 0, "No donation sent");

        donations[msg.sender] += msg.value;
        totalDonations += msg.value;

        emit Donated(msg.sender, msg.value);
    }

    /// @notice Allocate funds to a beneficiary
    /// @param beneficiary Address to receive funds
    /// @param amount Amount to send in wei
    function allocate(address payable beneficiary, uint256 amount) external onlyOwner {
        require(amount <= address(this).balance, "Insufficient balance");

        beneficiary.transfer(amount);
        emit Allocated(beneficiary, amount);
    }

    /// @notice Get contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
