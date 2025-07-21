// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SubscriptionService {
    address public owner;
    uint256 public subscriptionFee;
    uint256 public subscriptionDuration; // in seconds

    mapping(address => uint256) public subscriptions;

    event Subscribed(address indexed user, uint256 validTill);
    event SubscriptionFeeUpdated(uint256 newFee);
    event SubscriptionDurationUpdated(uint256 newDuration);
    event Withdrawn(uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    constructor(uint256 _fee, uint256 _durationInSeconds) {
        owner = msg.sender;
        subscriptionFee = _fee;
        subscriptionDuration = _durationInSeconds;
    }

    function subscribe() external payable {
        require(msg.value == subscriptionFee, "Incorrect fee");

        uint256 currentExpiry = subscriptions[msg.sender];
        uint256 currentTime = block.timestamp;

        if (currentExpiry > currentTime) {
            subscriptions[msg.sender] += subscriptionDuration;
        } else {
            subscriptions[msg.sender] = currentTime + subscriptionDuration;
        }

        emit Subscribed(msg.sender, subscriptions[msg.sender]);
    }

    function isSubscribed(address _user) public view returns (bool) {
        return subscriptions[_user] >= block.timestamp;
    }

    function getSubscriptionExpiry(address _user) external view returns (uint256) {
        return subscriptions[_user];
    }

    function updateSubscriptionFee(uint256 _newFee) external onlyOwner {
        subscriptionFee = _newFee;
        emit SubscriptionFeeUpdated(_newFee);
    }

    function updateSubscriptionDuration(uint256 _newDuration) external onlyOwner {
        subscriptionDuration = _newDuration;
        emit SubscriptionDurationUpdated(_newDuration);
    }

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Nothing to withdraw");
        payable(owner).transfer(balance);
        emit Withdrawn(balance);
    }
}
