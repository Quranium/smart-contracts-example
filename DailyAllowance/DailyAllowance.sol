// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DailyAllowance {
    address public owner;
    uint256 public allowanceAmount;
    uint256 public lastClaimed;

    event Deposited(address indexed from, uint256 amount);
    event Claimed(address indexed owner, uint256 amount);
    event AllowanceUpdated(uint256 newAmount);

    constructor(uint256 _allowanceAmount) {
        owner = msg.sender;
        allowanceAmount = _allowanceAmount;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    modifier canClaim() {
        require(
            block.timestamp >= lastClaimed + 1 days,
            "Claim available once a day"
        );
        _;
    }

    // Set a new daily allowance amount
    function setAllowance(uint256 _amount) external onlyOwner {
        allowanceAmount = _amount;
        emit AllowanceUpdated(_amount);
    }

    // Deposit ETH into the contract
    function deposit() external payable {
        require(msg.value > 0, "Send ETH to deposit");
        emit Deposited(msg.sender, msg.value);
    }

    // Claim the daily allowance (once every 24 hours)
    function claim() external onlyOwner canClaim {
        require(
            address(this).balance >= allowanceAmount,
            "Not enough funds in contract"
        );

        lastClaimed = block.timestamp;
        payable(owner).transfer(allowanceAmount);

        emit Claimed(owner, allowanceAmount);
    }

    // View the contract's ETH balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // View time remaining for next claim (in seconds)
    function timeUntilNextClaim() external view returns (uint256) {
        if (block.timestamp >= lastClaimed + 1 days) return 0;
        return (lastClaimed + 1 days) - block.timestamp;
    }

    receive() external payable {
        emit Deposited(msg.sender, msg.value);
    }
}
