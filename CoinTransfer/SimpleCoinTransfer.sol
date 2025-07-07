// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SimpleCoinTransfer - A minimal contract to send Ether to others
contract SimpleCoinTransfer {
    mapping(address => uint256) public internalBalance;

    event CoinSent(address indexed from, address indexed to, uint256 amount);
    event CoinReceived(address indexed from, uint256 amount);

    // Accept Ether and update internal balance
    receive() external payable {
        internalBalance[msg.sender] += msg.value;
        emit CoinReceived(msg.sender, msg.value);
    }

    /// @notice Send coins from sender to recipient if balance is sufficient
    /// @param to The address to send coins to
    /// @param amount Amount to send in wei
    function sendCoin(address payable to, uint256 amount) external {
        require(to != address(0), "Invalid address");
        require(internalBalance[msg.sender] >= amount, "Insufficient balance");

        internalBalance[msg.sender] -= amount;
        internalBalance[to] += amount;

        // Transfer Ether to recipient
        (bool success, ) = to.call{value: amount}("");
        require(success, "Transfer failed");

        emit CoinSent(msg.sender, to, amount);
    }

    /// @notice Get contract balance (total Ether held)
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /// @notice Get sender's internal balance
    function myBalance() external view returns (uint256) {
        return internalBalance[msg.sender];
    }
}
