# MarketPlace

## Contract Name
**MarketPlace**

---

## Overview

The `MarketPlace` contract implements a simple Amazon-style marketplace with built-in escrow, dispute resolution, and a ratings & reviews system. Sellers list products with price and stock. Buyers purchase items and the payment is held in escrow until the buyer confirms delivery. If a dispute arises, the contract owner (arbitrator) can resolve the dispute and distribute funds accordingly.

This contract is ideal for prototyping e-commerce marketplaces, learning escrow flows, or building a minimal decentralized marketplace. It is designed to be deployed and tested in the QRemix IDE using the JavaScript VM or a testnet.

---

## Prerequisites

- MetaMask or QSafe (for testnet deployment)
- Testnet ETH or QRN
- Access to QRemix IDE (or any Solidity dev environment)
- Basic knowledge of Solidity and smart contract workflow

---

## Contract Functions

### Constructor

```solidity
constructor()
```
- **Purpose:** Default Ownable constructor (owner = deployer).
- **Access:** Called on deployment.

---

### listProduct

```solidity
listProduct(string name, string description, uint price, uint stock) → uint
```
- **Purpose:** Seller lists a new product with price and stock.
- **Access:** Any address (becomes seller).
- **Returns:** productId (uint)

---

### updateProduct

```solidity
updateProduct(uint productId, uint newPrice, uint newStock)
```
- **Purpose:** Seller updates price and stock for their product.
- **Access:** Only product seller.

---

### removeProduct

```solidity
removeProduct(uint productId)
```
- **Purpose:** Remove a product listing. Seller or contract owner can remove.
- **Access:** Seller or owner.

---

### buyProduct

```solidity
buyProduct(uint productId, uint quantity) payable → uint
```
- **Purpose:** Buyer purchases quantity of a product. Funds are held in contract (escrow).
- **Conditions:** `msg.value == price * quantity` and `stock >= quantity`.
- **Returns:** purchaseId (uint)

---

### confirmDelivery

```solidity
confirmDelivery(uint purchaseId)
```
- **Purpose:** Buyer confirms delivery — contract releases funds to the seller.
- **Access:** Only the buyer of that purchase.

---

### openDispute

```solidity
openDispute(uint purchaseId, string reason)
```
- **Purpose:** Buyer or seller flags the purchase as disputed. Funds remain in contract.
- **Access:** Buyer or seller.

---

### resolveDispute

```solidity
resolveDispute(uint purchaseId, address payable toSeller, address payable toBuyer, uint sellerAmount, uint buyerAmount)
```
- **Purpose:** Owner (arbitrator) resolves a dispute by distributing the escrowed total between seller and buyer.
- **Access:** Only contract owner.
- **Condition:** `sellerAmount + buyerAmount == totalPrice`.

---

### leaveReview

```solidity
leaveReview(uint purchaseId, uint8 rating, string comment)
```
- **Purpose:** Buyer leaves a 1–5 rating and comment for the product after purchase is completed/refunded/resolved. One review per purchase.
- **Access:** Only the buyer of that purchase; purchase must be in an allowed status.

---

### getProduct

```solidity
getProduct(uint productId) → (id, name, description, price, stock, seller)
```
- **Purpose:** Fetch product metadata and seller address.

---

### getPurchase

```solidity
getPurchase(uint purchaseId) → (id, productId, buyer, quantity, totalPrice, status, createdAt)
```
- **Purpose:** Fetch purchase details and escrow status.

---

### getReviews

```solidity
getReviews(uint productId) → Review[]
```
- **Purpose:** Returns the list of reviews for a product. Each review contains: reviewer, rating (1–5), comment, and timestamp.

---

## Access Control

- **Owner (Deployer):** Arbitration power (resolve disputes), emergency withdrawal, and can remove product listings.
- **Sellers:** Can list, update, and remove their products.
- **Buyers:** Can buy products, confirm delivery, open disputes for their purchases, and leave reviews once eligible.

---

## Deployment & Testing on QRemix

### Step 1: Setup
- Open [qremix.org](https://qremix.org)
- Create folder: `MarketPlace/`
- Add `MarketPlace.sol` and paste the contract code.

### Step 2: Compile
- Go to Solidity Compiler
- Select version `0.8.20` (or compatible `^0.8.20`)
- Compile the contract

### Step 3: Deploy

#### Quranium Testnet
- Go to Deploy & Run Transactions
- Select Injected Provider - MetaMask
- Connect to Quranium testnet
- Deploy (no constructor args)

#### JavaScript VM
- Choose JavaScript VM
- Deploy directly with the default admin (deployer will be owner)

### Step 4: Testing Flow

1. **Seller:** Call `listProduct("Phone", "Nice phone", <priceInWei>, 10)`. Note the returned productId.
2. **Buyer:** Call `buyProduct(productId, quantity)` sending `price * quantity` wei. Note purchaseId.
3. **Buyer:** After receiving item (simulate), call `confirmDelivery(purchaseId)` to release funds to seller.
4. **If problem:** Either party calls `openDispute(purchaseId, "reason")`.
5. **Owner:** Call `resolveDispute(purchaseId, sellerAddress, buyerAddress, sellerAmount, buyerAmount)` distributing the escrowed funds.
6. **Buyer:** After Released or Resolved, call `leaveReview(purchaseId, rating, "comment")`.

---

## Security Notes & Recommendations

- The contract uses `nonReentrant` for functions handling ETH transfers.
- Currently uses ETH-only flow. For token support (ERC20), integrate SafeERC20 and hold token balances in escrow.
- Arbitration authority is the contract owner — for production, replace owner-based arbitration with a DAO, multisig, or a decentralized arbitration protocol.
- Add time-based auto-release (seller can request release after X days) and dispute timeouts as enhancements.
- Always test edge cases: partial refunds, failed transfers, reentrancy attempts, and inconsistent states.

---

## License

This project is licensed under the MIT License.  
See `SPDX-License-Identifier: MIT` in the Solidity file

---

## Support
For issues or feature requests, refer to:  
[QRemix IDE Documentation](https://docs.qremix.org)

---