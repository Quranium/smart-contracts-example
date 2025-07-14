# FlipkartEscrow

---

### Contract Name  
**FlipkartEscrow**

---

### Overview

The **FlipkartEscrow** smart contract is a secure escrow system designed for e-commerce transactions. This contract acts as a trusted intermediary that holds funds in escrow until the buyer confirms delivery, ensuring both buyer and seller protection in online transactions.

The system supports order placement with fund escrow, shipping confirmation, delivery verification, and order cancellation with automatic refunds. Built with comprehensive status tracking and event logging for complete transaction transparency.

Perfect for e-commerce platforms, marketplace applications, peer-to-peer trading systems, or educational blockchain projects demonstrating secure payment workflows.

---

### Prerequisites

- MetaMask or compatible Web3 wallet
- ETH or testnet tokens (for transactions and gas fees)
- Remix IDE or similar development environment
- Basic understanding of smart contract interactions

---

### Contract Functions

#### placeOrder

```solidity
placeOrder(address payable seller) external payable returns (uint256)
```
- **Purpose:** Places a new order with funds held in escrow
- **Access:** Any address (buyer)
- **Parameters:** `seller` - address of the seller
- **Payment:** Must send ETH with the transaction
- **Returns:** Order ID for tracking
- **Requirements:** Payment must be greater than zero, valid seller address

#### markAsShipped

```solidity
markAsShipped(uint256 _id) external
```
- **Purpose:** Seller confirms order has been shipped
- **Access:** Seller only
- **Parameters:** `_id` - order ID to update
- **Requirements:** Only seller can call, order must be in "Placed" status

#### confirmDelivery

```solidity
confirmDelivery(uint256 _id) external
```
- **Purpose:** Buyer confirms delivery, releases funds to seller
- **Access:** Buyer only
- **Parameters:** `_id` - order ID to confirm
- **Requirements:** Only buyer can call, order must be in "Shipped" status

#### cancelOrder

```solidity
cancelOrder(uint256 _id) external
```
- **Purpose:** Buyer cancels order and receives refund
- **Access:** Buyer only
- **Parameters:** `_id` - order ID to cancel
- **Requirements:** Only buyer can call, order must be in "Placed" status (before shipping)

#### getOrderStatus

```solidity
getOrderStatus(uint256 _id) external view returns (Status)
```
- **Purpose:** Returns current status of an order
- **Access:** Public read-only
- **Parameters:** `_id` - order ID to check
- **Returns:** Current order status (Placed, Shipped, Delivered, Cancelled)

---

### Access Control

This contract implements transaction-based access control:

- **Buyer Functions**: `placeOrder`, `confirmDelivery`, `cancelOrder`
- **Seller Functions**: `markAsShipped`
- **Public Functions**: `getOrderStatus`

> Access is determined by the buyer and seller addresses stored in each order.

---

### Contract State

#### Constants
- `orderId`: Global counter for order IDs

#### Data Structures
```solidity
enum Status { Placed, Shipped, Delivered, Cancelled }

struct Order {
    address payable buyer;    // Order buyer address
    address payable seller;   // Order seller address
    uint256 amount;          // Escrowed amount
    Status status;           // Current order status
}
```

#### Order Status Flow
1. **Placed**: Order created, funds in escrow
2. **Shipped**: Seller confirms shipment
3. **Delivered**: Buyer confirms delivery, funds released
4. **Cancelled**: Order cancelled, funds refunded

---

### Events

- `OrderPlaced`: Emitted when a new order is created
- `OrderShipped`: Emitted when seller marks order as shipped
- `OrderDelivered`: Emitted when buyer confirms delivery
- `OrderCancelled`: Emitted when order is cancelled

---

### Deployment & Testing

#### Step 1: Setup
- Open [remix.ethereum.org](https://remix.ethereum.org)
- Create folder: `FlipkartEscrow/`
- Add `FlipkartEscrow.sol` and paste the contract code

#### Step 2: Compile
- Go to Solidity Compiler
- Select compiler version `^0.8.20`
- Compile the contract

#### Step 3: Deploy

##### Ethereum Testnet (Sepolia/Goerli)
- Go to **Deploy & Run Transactions**
- Choose **Injected Provider - MetaMask**
- Connect to testnet
- Deploy contract (no constructor arguments)

##### Local Testing (JavaScript VM)
- Choose **JavaScript VM**
- Deploy contract directly

#### Step 4: Testing Workflow

1. **As Buyer:**
   ```solidity
   // Place order with 0.1 ETH
   placeOrder(sellerAddress, {value: 100000000000000000});
   
   // Check order status
   getOrderStatus(1); // Returns Status.Placed
   ```

2. **As Seller:**
   ```solidity
   // Mark order as shipped
   markAsShipped(1);
   
   // Verify status change
   getOrderStatus(1); // Returns Status.Shipped
   ```

3. **As Buyer (Delivery Confirmation):**
   ```solidity
   // Confirm delivery (releases funds to seller)
   confirmDelivery(1);
   
   // Check final status
   getOrderStatus(1); // Returns Status.Delivered
   ```

4. **As Buyer (Cancellation):**
   ```solidity
   // Cancel order (only before shipping)
   cancelOrder(1);
   
   // Check status
   getOrderStatus(1); // Returns Status.Cancelled
   ```

---

### Example Usage

```solidity
// Deploy contract
FlipkartEscrow escrow = new FlipkartEscrow();

// Buyer places order for 0.5 ETH
uint256 orderID = escrow.placeOrder{value: 0.5 ether}(sellerAddress);

// Seller ships the order
escrow.markAsShipped(orderID);

// Buyer confirms delivery
escrow.confirmDelivery(orderID);

// Check final status
Status finalStatus = escrow.getOrderStatus(orderID);
// finalStatus == Status.Delivered
```

---

### Transaction Flow

#### Successful Transaction
1. **Buyer** places order with payment → Funds locked in escrow
2. **Seller** marks as shipped → Status updated to "Shipped"
3. **Buyer** confirms delivery → Funds released to seller
4. **Final Status**: Delivered

#### Cancelled Transaction
1. **Buyer** places order with payment → Funds locked in escrow
2. **Buyer** cancels order (before shipping) → Refund issued
3. **Final Status**: Cancelled

---

### Use Cases

#### E-commerce Platforms
- **Marketplace Protection**: Secure transactions between unknown parties
- **Buyer Protection**: Funds held until delivery confirmation
- **Seller Protection**: Payment guaranteed upon delivery
- **Dispute Resolution**: Clear status tracking for mediation

#### Business Applications
- **Freelance Services**: Escrow for service delivery
- **Digital Products**: Secure payment for downloads
- **Physical Goods**: Traditional e-commerce escrow
- **Subscription Services**: Recurring payment protection

---

### Security Considerations

- **Fund Security**: Funds locked in contract until delivery or cancellation
- **Access Control**: Only relevant parties can update order status
- **Status Validation**: Strict order status progression
- **Refund Protection**: Automatic refunds on cancellation
- **No Admin Control**: Decentralized system without central authority

---

### Integration Examples

#### Web3 Frontend Integration
```javascript
// Place order
const tx = await contract.placeOrder(sellerAddress, {
    value: ethers.utils.parseEther("0.1")
});

// Listen for order events
contract.on("OrderPlaced", (id, buyer, seller, amount) => {
    console.log(`Order ${id} placed: ${amount} ETH`);
});

// Check order status
const status = await contract.getOrderStatus(orderId);
const statusNames = ["Placed", "Shipped", "Delivered", "Cancelled"];
console.log(`Order status: ${statusNames[status]}`);
```

#### Event Monitoring
```javascript
// Monitor all order events
contract.on("OrderShipped", (id) => {
    console.log(`Order ${id} has been shipped`);
});

contract.on("OrderDelivered", (id) => {
    console.log(`Order ${id} delivered, payment released`);
});

contract.on("OrderCancelled", (id) => {
    console.log(`Order ${id} cancelled, refund issued`);
});
```

---

### Error Handling

Common error scenarios and solutions:

- **"Payment must be greater than zero"**: Send ETH with placeOrder transaction
- **"Only seller can mark shipped"**: Ensure seller address is calling markAsShipped
- **"Only buyer can confirm delivery"**: Ensure buyer address is calling confirmDelivery
- **"Order must be shipped first"**: Cannot confirm delivery before shipping
- **"Cannot cancel after shipping"**: Orders can only be cancelled before shipping

---

### License

This project is licensed under the MIT License.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

### Support

For help, improvements, or bug reports:
- Remix IDE Docs: https://remix-ide.readthedocs.io
- Solidity Documentation: https://docs.soliditylang.org
- Ethereum Development: https://ethereum.org/en/developers/

---

**Built for Secure E-commerce Transactions** 🛒