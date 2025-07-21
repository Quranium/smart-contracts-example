// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleVault {
    address public owner;

    // Maps user addresses to their ETH balances in the vault
    mapping(address => uint256) public balances;

    constructor() {
        owner = msg.sender;
    }

    // Event emitted when a deposit is made
    event Deposited(address indexed user, uint256 amount);

    // Event emitted when a withdrawal is made
    event Withdrawn(address indexed user, uint256 amount);

    // Function to deposit ETH into the vault
    function deposit() external payable {
        require(msg.value > 0, "Deposit must be greater than 0");
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    // Function to withdraw ETH from the vault
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);

        emit Withdrawn(msg.sender, amount);
    }

    // Function to check the contract balance
    function vaultBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // Fallback function to receive ETH
    receive() external payable {
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }
}
