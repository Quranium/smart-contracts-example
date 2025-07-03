// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TokenFaucet {
mapping(address => uint256) public lastAccessTime;
mapping(address => uint256) public balances;
uint256 public faucetAmount = 100;
uint256 public cooldown = 1 hours;

event TokensDispensed(address indexed user, uint256 amount);
event TokensDeposited(address indexed depositor, uint256 amount);

// Modifier to enforce cooldown between requests
modifier canRequest() {
    require(
        block.timestamp - lastAccessTime[msg.sender] >= cooldown,
        "Please wait before requesting again."
    );
    _;
}

// Function to request tokens
function requestTokens() external canRequest {
    require(balances[address(this)] >= faucetAmount, "Faucet empty.");

    balances[address(this)] -= faucetAmount;
    balances[msg.sender] += faucetAmount;
    lastAccessTime[msg.sender] = block.timestamp;

    emit TokensDispensed(msg.sender, faucetAmount);
}

// Function to deposit tokens into the faucet
function depositTokens(uint256 amount) external {
    require(amount > 0, "Amount must be > 0");
    balances[msg.sender] -= amount;
    balances[address(this)] += amount;

    emit TokensDeposited(msg.sender, amount);
}

// Admin-like function to manually set a user's balance (for dev purposes)
function devSetBalance(address user, uint256 amount) external {
    balances[user] = amount;
}

// View function to check available faucet balance
function getFaucetBalance() external view returns (uint256) {
    return balances[address(this)];
}
} 
