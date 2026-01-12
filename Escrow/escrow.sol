// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Escrow {
    enum Status { Pending, Completed, Disputed, Refunded }

    struct Deal {
        address buyer;
        address seller;
        uint256 amount;
        Status status;
    }

    mapping(uint256 => Deal) public deals;
    uint256 public dealCount;
    address public arbitrator;

    event DealCreated(uint256 dealId, address buyer, address seller, uint256 amount);
    event DealCompleted(uint256 dealId);
    event DealRefunded(uint256 dealId);

    constructor(address _arbitrator) {
        arbitrator = _arbitrator;
    }

    function createDeal(address _seller) external payable {
        deals[++dealCount] = Deal(msg.sender, _seller, msg.value, Status.Pending);
        emit DealCreated(dealCount, msg.sender, _seller, msg.value);
    }

    function completeDeal(uint256 _id) external {
        Deal storage d = deals[_id];
        require(msg.sender == d.buyer, "Not buyer");
        require(d.status == Status.Pending, "Invalid status");

        d.status = Status.Completed;
        payable(d.seller).transfer(d.amount);
        emit DealCompleted(_id);
    }

    function raiseDispute(uint256 _id) external {
        Deal storage d = deals[_id];
        require(msg.sender == d.buyer || msg.sender == d.seller, "Not involved");
        require(d.status == Status.Pending, "Invalid status");
        d.status = Status.Disputed;
    }

    function resolveDispute(uint256 _id, bool refundBuyer) external {
        require(msg.sender == arbitrator, "Not arbitrator");
        Deal storage d = deals[_id];
        require(d.status == Status.Disputed, "Invalid status");

        d.status = refundBuyer ? Status.Refunded : Status.Completed;
        address recipient = refundBuyer ? d.buyer : d.seller;
        payable(recipient).transfer(d.amount);
        emit DealRefunded(_id);
    }
}
