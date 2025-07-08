// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title SimpleWallet - A contract for users to deposit and withdraw Ether.
contract SimpleWallet {
    mapping(address => uint256) public balances; // Ether balances per user

    /// @notice Deposit Ether into your wallet
    function deposit() public payable {
        require(msg.value > 0, "No Ether sent");
        balances[msg.sender] += msg.value;
    }

    /// @notice Withdraw Ether from your wallet
    /// @param amount The amount to withdraw
    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    /// @notice Check your wallet balance
    /// @return The Ether balance of the caller
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
} 