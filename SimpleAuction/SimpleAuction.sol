// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title SimpleAuction - A basic auction contract where users place bids and the highest bidder wins
contract SimpleAuction {
    address public owner;
    uint public highestBid;
    address public highestBidder;
    bool public ended;

    mapping(address => uint) public refunds;

    /// @notice Sets the auction owner as the contract deployer
    constructor() {
        owner = msg.sender;
    }

    /// @notice Allows users to place a bid higher than the current highest
    function bid() public payable {
        require(!ended, "Auction ended");
        require(msg.value > highestBid, "Bid too low");

        if (highestBid != 0) {
            refunds[highestBidder] += highestBid;
        }

        highestBid = msg.value;
        highestBidder = msg.sender;
    }

    /// @notice Allows outbid users to withdraw their refunds
    function withdrawRefund() public {
        uint amount = refunds[msg.sender];
        require(amount > 0, "No refund");

        refunds[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    /// @notice Ends the auction and transfers the highest bid to the owner
    function endAuction() public {
        require(msg.sender == owner, "Only owner");
        require(!ended, "Already ended");

        ended = true;
        payable(owner).transfer(highestBid);
    }
}
