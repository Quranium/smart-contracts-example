// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleAuction {
    address public owner;
    uint public highestBid;
    address public highestBidder;
    bool public ended;

    mapping(address => uint) public refunds;

    constructor() {
        owner = msg.sender;
    }

    function bid() public payable {
        require(!ended, "Auction ended");
        require(msg.value > highestBid, "Bid too low");

        if (highestBid != 0) {
            refunds[highestBidder] += highestBid;
        }

        highestBid = msg.value;
        highestBidder = msg.sender;
    }

    function withdrawRefund() public {
        uint amount = refunds[msg.sender];
        require(amount > 0, "No refund");

        refunds[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function endAuction() public {
        require(msg.sender == owner, "Only owner");
        require(!ended, "Already ended");

        ended = true;
        payable(owner).transfer(highestBid);
    }
}