// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title SimpleFaucet - A faucet contract for distributing small amounts of Ether.
contract SimpleFaucet {
    uint256 public constant WITHDRAW_AMOUNT = 0.01 ether; // Amount per withdrawal
    uint256 public constant COOLDOWN = 1 days; // Cooldown period between withdrawals

    mapping(address => uint256) public lastWithdrawTime; // Last withdrawal timestamp per address

    /// @notice Withdraw Ether from the faucet
    function withdraw() public {
        require(address(this).balance >= WITHDRAW_AMOUNT, "Faucet empty");
        require(block.timestamp >= lastWithdrawTime[msg.sender] + COOLDOWN, "Cooldown not finished");
        lastWithdrawTime[msg.sender] = block.timestamp;
        payable(msg.sender).transfer(WITHDRAW_AMOUNT);
    }

    /// @notice Allow anyone to fund the faucet
    receive() external payable {}
} 