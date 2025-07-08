// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title SimpleTimeLock - A contract to lock Ether until a specified time.
contract SimpleTimeLock {
    // Mapping to store the balance locked for each address
    mapping(address => uint256) public balances;
    // Mapping to store the release time for each address
    mapping(address => uint256) public releaseTime;

    /// @notice Lock Ether for a specified duration
    /// @param timeInSeconds The number of seconds to lock the Ether
    function lock(uint256 timeInSeconds) public payable {
        require(msg.value > 0, "No Ether sent");
        balances[msg.sender] += msg.value;
        releaseTime[msg.sender] = block.timestamp + timeInSeconds;
    }

    /// @notice Withdraw Ether after the lock period has passed
    function withdraw() public {
        require(block.timestamp >= releaseTime[msg.sender], "Too early");
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Nothing to withdraw");
        balances[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
} 