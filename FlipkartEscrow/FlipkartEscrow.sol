// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title FlipkartEscrow - Simple escrow contract for secure e-commerce transactions
contract FlipkartEscrow {
    enum Status { Placed, Shipped, Delivered, Cancelled }

    struct Order {
        address payable buyer;
        address payable seller;
        uint256 amount;
        Status status;
    }

    uint256 public orderId;
    mapping(uint256 => Order) public orders;

    event OrderPlaced(uint256 indexed id, address buyer, address seller, uint256 amount);
    event OrderShipped(uint256 indexed id);
    event OrderDelivered(uint256 indexed id);
    event OrderCancelled(uint256 indexed id);

    // Buyer places the order and funds go into escrow
    function placeOrder(address payable seller) external payable returns (uint256) {
        require(msg.value > 0, "Payment must be greater than zero");
        require(seller != address(0), "Seller address is required");

        orderId++;
        orders[orderId] = Order(payable(msg.sender), seller, msg.value, Status.Placed);

        emit OrderPlaced(orderId, msg.sender, seller, msg.value);
        return orderId;
    }

    // Seller updates order as shipped
    function markAsShipped(uint256 _id) external {
        Order storage order = orders[_id];
        require(msg.sender == order.seller, "Only seller can mark shipped");
        require(order.status == Status.Placed, "Order not placed or already processed");

        order.status = Status.Shipped;
        emit OrderShipped(_id);
    }

    // Buyer confirms delivery, releasing funds to seller
    function confirmDelivery(uint256 _id) external {
        Order storage order = orders[_id];
        require(msg.sender == order.buyer, "Only buyer can confirm delivery");
        require(order.status == Status.Shipped, "Order must be shipped first");

        order.status = Status.Delivered;
        order.seller.transfer(order.amount);
        emit OrderDelivered(_id);
    }

    // Buyer can cancel before it is shipped
    function cancelOrder(uint256 _id) external {
        Order storage order = orders[_id];
        require(msg.sender == order.buyer, "Only buyer can cancel");
        require(order.status == Status.Placed, "Cannot cancel after shipping");

        order.status = Status.Cancelled;
        order.buyer.transfer(order.amount);
        emit OrderCancelled(_id);
    }

    // Public getter for order status
    function getOrderStatus(uint256 _id) external view returns (Status) {
        return orders[_id].status;
    }
}
