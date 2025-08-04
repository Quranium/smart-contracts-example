// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ContentSubscription {
    address public owner;
    uint public subscriptionFee = 0.01 ether;
    mapping(address => uint) public subscribedUntil;

    function setOwner() external {
        require(owner == address(0), "Owner already set");
        owner = msg.sender;
    }

    function subscribe() external payable {
        require(msg.value == subscriptionFee, "Incorrect fee");
        if (block.timestamp > subscribedUntil[msg.sender]) {
            subscribedUntil[msg.sender] = block.timestamp + 30 days;
        } else {
            subscribedUntil[msg.sender] += 30 days;
        }
    }

    function isSubscribed(address user) external view returns (bool) {
        return block.timestamp < subscribedUntil[user];
    }

    function withdraw() external {
        require(msg.sender == owner, "Only owner");
        payable(owner).transfer(address(this).balance);
    }
}
