// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SelfFundingGoals {
    address public owner;

    struct GoalLog {
        uint256 amount;
        string note;
        uint256 timestamp;
    }

    GoalLog[] public deposits;

    event GoalFunded(uint256 amount, string note);
    event AllFundsWithdrawn(uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner allowed");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Deposit ETH with a personal note
    function fundGoal(string calldata note) external payable onlyOwner {
        require(msg.value > 0, "Must send some ETH");
        deposits.push(GoalLog(msg.value, note, block.timestamp));
        emit GoalFunded(msg.value, note);
    }

    // View all deposited goals
    function getDepositCount() external view returns (uint256) {
        return deposits.length;
    }

    function getDeposit(
        uint256 index
    ) external view returns (uint256, string memory, uint256) {
        require(index < deposits.length, "Invalid index");
        GoalLog memory entry = deposits[index];
        return (entry.amount, entry.note, entry.timestamp);
    }

    // Withdraw all ETH
    function withdrawAll() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        payable(owner).transfer(balance);
        emit AllFundsWithdrawn(balance);
    }

    // View current contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // Fallback function to accept ETH directly
    receive() external payable {
        deposits.push(
            GoalLog(msg.value, "Direct ETH deposit", block.timestamp)
        );
        emit GoalFunded(msg.value, "Direct ETH deposit");
    }
}
