// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title RefundableSale - Crowdfunding contract with refund and seller claim mechanism
contract RefundableSale {
    address public seller;
    uint public goal;
    uint public deadline;
    uint public totalRaised;
    bool public claimed;

    mapping(address => uint) public contributions;

    /// @notice Initializes the sale with seller, funding goal, and duration
    /// @param _seller Address of the seller
    /// @param _goal Funding goal in wei
    /// @param _duration Duration of the sale in seconds
    function init(address _seller, uint _goal, uint _duration) external {
        require(seller == address(0), "Already initialized");
        seller = _seller;
        goal = _goal;
        deadline = block.timestamp + _duration;
    }

    /// @notice Contribute ETH to the sale
    function contribute() external payable {
        require(block.timestamp < deadline, "Ended");
        contributions[msg.sender] += msg.value;
        totalRaised += msg.value;
    }

    /// @notice Refund contribution if goal not met after deadline
    function refund() external {
        require(block.timestamp >= deadline, "Too early");
        require(totalRaised < goal, "Goal met");
        uint amount = contributions[msg.sender];
        require(amount > 0, "No contribution");
        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    /// @notice Seller claims raised funds if goal is met after deadline
    function claimFunds() external {
        require(msg.sender == seller, "Not seller");
        require(block.timestamp >= deadline, "Not ended");
        require(totalRaised >= goal, "Goal not met");
        require(!claimed, "Already claimed");
        claimed = true;
        payable(seller).transfer(totalRaised);
    }
}
