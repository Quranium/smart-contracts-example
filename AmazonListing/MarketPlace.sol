// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MarketPlace is ReentrancyGuard, Ownable {
    uint public productCount;
    uint public purchaseCount;

    enum PurchaseStatus { Locked, Delivered, Released, Refunded, Disputed, Resolved }

    struct Product {
        uint id;
        string name;
        string description;
        uint price;       // price per unit (wei)
        uint stock;
        address payable seller;
        bool exists;
    }

    struct Purchase {
        uint id;
        uint productId;
        address payable buyer;
        uint quantity;
        uint totalPrice;
        PurchaseStatus status;
        uint createdAt;
    }

    struct Review {
        address reviewer;
        uint8 rating;     // 1-5
        string comment;
        uint timestamp;
    }

    // productId => Product
    mapping(uint => Product) public products;

    // purchaseId => Purchase
    mapping(uint => Purchase) public purchases;

    // productId => list of reviews
    mapping(uint => Review[]) internal productReviews;

    // purchaseId => whether review left
    mapping(uint => bool) public purchaseReviewed;

    // seller => pendingWithdrawals (in case you want to store rather than auto-transfer)
    mapping(address => uint) public pendingWithdrawals; // (not currently required, kept optional)

    /* -------------------- Events -------------------- */
    event ProductListed(uint indexed productId, address indexed seller, string name, uint price, uint stock);
    event ProductUpdated(uint indexed productId, uint price, uint stock);
    event ProductPurchased(uint indexed purchaseId, uint indexed productId, address indexed buyer, uint quantity, uint totalPrice);
    event DeliveryConfirmed(uint indexed purchaseId);
    event FundsReleased(uint indexed purchaseId, address indexed seller, uint amount);
    event RefundIssued(uint indexed purchaseId, address indexed buyer, uint amount);
    event DisputeOpened(uint indexed purchaseId, address indexed opener, string reason);
    event DisputeResolved(uint indexed purchaseId, address indexed resolver, bool releasedToSeller, uint sellerAmount, uint buyerAmount);
    event ReviewLeft(uint indexed productId, address indexed reviewer, uint8 rating, string comment);
    event ProductRemoved(uint indexed productId);

    /* -------------------- Modifiers -------------------- */

    modifier productExists(uint productId) {
        require(products[productId].exists, "product not found");
        _;
    }

    modifier onlyBuyer(uint purchaseId) {
        require(purchases[purchaseId].buyer == msg.sender, "not buyer of purchase");
        _;
    
    }
    //Seller specific functions
    function listProduct(
        string calldata name,
        string calldata description,
        uint price,
        uint stock
    ) external returns (uint) {
        require(price > 0, "price>0");
        require(stock > 0, "stock>0");

        productCount++;
        products[productCount] = Product({
            id: productCount,
            name: name,
            description: description,
            price: price,
            stock: stock,
            seller: payable(msg.sender),
            exists: true
        });

        emit ProductListed(productCount, msg.sender, name, price, stock);
        return productCount;
    }

    function updateProduct(uint productId, uint newPrice, uint newStock) external productExists(productId) {
        Product storage p = products[productId];
        require(p.seller == msg.sender, "not seller");
        require(newPrice > 0, "price>0");
        p.price = newPrice;
        p.stock = newStock;
        emit ProductUpdated(productId, newPrice, newStock);
    }

    function removeProduct(uint productId) external productExists(productId) {
        Product storage p = products[productId];
        require(p.seller == msg.sender || owner() == msg.sender, "not authorized");
        delete products[productId];
        emit ProductRemoved(productId);
    }

   //buyer specific functions
    function buyProduct(uint productId, uint quantity) external payable nonReentrant productExists(productId) returns (uint) {
        require(quantity > 0, "quantity>0");
        Product storage p = products[productId];
        require(p.stock >= quantity, "not enough stock");

        uint total = p.price * quantity;
        require(msg.value == total, "incorrect payment");

        // reduce stock immediately
        p.stock -= quantity;

        purchaseCount++;
        purchases[purchaseCount] = Purchase({
            id: purchaseCount,
            productId: productId,
            buyer: payable(msg.sender),
            quantity: quantity,
            totalPrice: total,
            status: PurchaseStatus.Locked,
            createdAt: block.timestamp
        });

        emit ProductPurchased(purchaseCount, productId, msg.sender, quantity, total);
        return purchaseCount;
    }

    /// @notice Buyer confirms delivery; releases funds to seller
    function confirmDelivery(uint purchaseId) external nonReentrant onlyBuyer(purchaseId) {
        Purchase storage pur = purchases[purchaseId];
        require(pur.status == PurchaseStatus.Locked || pur.status == PurchaseStatus.Delivered, "cannot confirm");
        pur.status = PurchaseStatus.Released;

        Product storage prod = products[pur.productId];
        uint amount = pur.totalPrice;

        // transfer ETH to seller
        (bool ok, ) = prod.seller.call{value: amount}("");
        require(ok, "transfer failed");

        emit DeliveryConfirmed(purchaseId);
        emit FundsReleased(purchaseId, prod.seller, amount);
    }


    /// @notice Buyer or seller open a dispute
    function openDispute(uint purchaseId, string calldata reason) external {
        Purchase storage pur = purchases[purchaseId];
        require(pur.status == PurchaseStatus.Locked || pur.status == PurchaseStatus.Delivered, "cannot dispute");
        Product storage prod = products[pur.productId];
        require(msg.sender == pur.buyer || msg.sender == prod.seller, "not party");

        pur.status = PurchaseStatus.Disputed;
        emit DisputeOpened(purchaseId, msg.sender, reason);
    }

    /// @notice Owner (or arbitrator owner) resolves dispute. Provide amounts to buyer and seller (sum must equal totalPrice)
    function resolveDispute(uint purchaseId, address payable toSeller, address payable toBuyer, uint sellerAmount, uint buyerAmount) external onlyOwner nonReentrant {
        Purchase storage pur = purchases[purchaseId];
        require(pur.status == PurchaseStatus.Disputed, "not disputed");
        require(sellerAmount + buyerAmount == pur.totalPrice, "amount mismatch");

        pur.status = PurchaseStatus.Resolved;

        // transfer to seller if any
        if (sellerAmount > 0) {
            (bool ok1, ) = toSeller.call{value: sellerAmount}("");
            require(ok1, "seller transfer failed");
        }

        // transfer to buyer if any (refund)
        if (buyerAmount > 0) {
            (bool ok2, ) = toBuyer.call{value: buyerAmount}("");
            require(ok2, "buyer refund failed");
        }

        emit DisputeResolved(purchaseId, msg.sender, sellerAmount > 0, sellerAmount, buyerAmount);
    }

    /// @notice Leave a review for the purchased product. Can only be called by the buyer after purchase is released or resolved in buyer's favor.
    function leaveReview(uint purchaseId, uint8 rating, string calldata comment) external {
        require(rating >= 1 && rating <= 5, "rating 1-5");
        Purchase storage pur = purchases[purchaseId];

        require(pur.buyer == msg.sender, "not buyer");
        require(!purchaseReviewed[purchaseId], "already reviewed");
        require(
            pur.status == PurchaseStatus.Released ||
            pur.status == PurchaseStatus.Resolved ||
            pur.status == PurchaseStatus.Refunded,
            "cannot review yet"
        );

        productReviews[pur.productId].push(Review({
            reviewer: msg.sender,
            rating: rating,
            comment: comment,
            timestamp: block.timestamp
        }));

        purchaseReviewed[purchaseId] = true;
        emit ReviewLeft(pur.productId, msg.sender, rating, comment);
    }

    function getProduct(uint productId) external view productExists(productId) returns (
        uint id,
        string memory name,
        string memory description,
        uint price,
        uint stock,
        address seller
    ) {
        Product storage p = products[productId];
        return (p.id, p.name, p.description, p.price, p.stock, p.seller);
    }

    function getPurchase(uint purchaseId) external view returns (
        uint id,
        uint productId,
        address buyer,
        uint quantity,
        uint totalPrice,
        PurchaseStatus status,
        uint createdAt
    ) {
        Purchase storage pur = purchases[purchaseId];
        return (pur.id, pur.productId, pur.buyer, pur.quantity, pur.totalPrice, pur.status, pur.createdAt);
    }

    function getReviews(uint productId) external view returns (Review[] memory) {
        return productReviews[productId];
    }
    // Allow owner to withdraw accidentally stuck funds (emergency)
    function emergencyWithdraw(address payable to, uint amount) external onlyOwner nonReentrant {
        require(address(this).balance >= amount, "insufficient balance");
        (bool ok, ) = to.call{value: amount}("");
        require(ok, "withdraw failed");
    }

    // Fallback to accept ETH (e.g., accidental sends)
    receive() external payable {}
}
