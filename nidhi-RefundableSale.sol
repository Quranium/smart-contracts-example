// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RefundableSale {
    address public seller;
    uint public goal;
    uint public deadline;
    uint public totalRaised;
    bool public claimed;

    mapping(address => uint) public contributions;

    function init(address _seller, uint _goal, uint _duration) external {
        require(seller == address(0), "Already initialized");
        seller = _seller;
        goal = _goal;
        deadline = block.timestamp + _duration;
    }

    function contribute() external payable {
        require(block.timestamp < deadline, "Ended");
        contributions[msg.sender] += msg.value;
        totalRaised += msg.value;
    }

    function refund() external {
        require(block.timestamp >= deadline, "Too early");
        require(totalRaised < goal, "Goal met");
        uint amount = contributions[msg.sender];
        require(amount > 0, "No contribution");
        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function claimFunds() external {
        require(msg.sender == seller, "Not seller");
        require(block.timestamp >= deadline, "Not ended");
        require(totalRaised >= goal, "Goal not met");
        require(!claimed, "Already claimed");
        claimed = true;
        payable(seller).transfer(totalRaised);
    }
}