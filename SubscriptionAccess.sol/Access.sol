// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SubscriptionAccess {
    struct Plan {
        uint256 price;
        uint256 duration;
    }

    struct Subscriber {
        uint256 planId;
        uint256 expiry;
    }

    mapping(uint256 => Plan) public plans;
    mapping(address => Subscriber) public subscribers;
    uint256 public planCount;
    address public owner;

    event Subscribed(address user, uint256 planId, uint256 expiry);

    constructor() {
        owner = msg.sender;
    }

    function createPlan(uint256 _price, uint256 _duration) external {
        require(msg.sender == owner, "Only owner");
        plans[++planCount] = Plan(_price, _duration);
    }

    function subscribe(uint256 _planId) external payable {
        Plan memory plan = plans[_planId];
        require(plan.price > 0, "Invalid plan");
        require(msg.value == plan.price, "Incorrect price");

        subscribers[msg.sender] = Subscriber(_planId, block.timestamp + plan.duration);
        emit Subscribed(msg.sender, _planId, block.timestamp + plan.duration);
    }

    function hasAccess(address _user) external view returns (bool) {
        return subscribers[_user].expiry > block.timestamp;
    }

    function withdraw() external {
        require(msg.sender == owner, "Not owner");
        payable(owner).transfer(address(this).balance);
    }
}
