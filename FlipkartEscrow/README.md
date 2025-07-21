# FlipkartEscrow

## Overview

The **FlipkartEscrow** contract enables secure and trustless e-commerce transactions between buyers and sellers.  
Funds are held in escrow upon order placement and are only released to the seller upon buyer confirmation of delivery.  
The contract supports order lifecycle stages: **Placed**, **Shipped**, **Delivered**, and **Cancelled**.

This implementation provides a lightweight and secure approach to managing disputes and payment protection on-chain.

*They are designed to be deployed and tested in the **QRemix IDE** using the JavaScript VM or a testnet like Quranium testnet, Sepolia etc.*

## Prerequisites

To deploy and test the contracts, you need:

- **MetaMask or QSafe**: Browser extension for testnet deployments (optional).
- **Test ETH or QRN**: Required for testnet deployments (e.g., from a Sepolia faucet like [sepoliafaucet.com](https://sepoliafaucet.com/), Quranium [faucet.quranium.org](https://faucet.quranium.org/)).
- **QRemix IDE**: Access at [https://www.qremix.org/](https://www.qremix.org/)
- **Basic Solidity Knowledge**: Understanding of payable functions, mappings, enums, and smart contract security.

## Contract Details

### Enums

- `enum Status { Placed, Shipped, Delivered, Cancelled }`:  
  Represents the various stages in the order lifecycle.

### Structs

- `Order`: Contains:
  - `buyer`: Address of the buyer.
  - `seller`: Address of the seller.
  - `amount`: Payment value in escrow.
  - `status`: Current order status.

### State Variables

- `orderId`: Counter to track order IDs.
- `orders`: Mapping of `orderId` to `Order` struct.

### Functions

- `placeOrder(address seller) payable returns (uint256)`:  
  Buyer places an order by sending payment. A new `Order` is created with status `Placed`.

- `markAsShipped(uint256 id)`:  
  Seller changes the order status from `Placed` to `Shipped`.

- `confirmDelivery(uint256 id)`:  
  Buyer confirms delivery. Funds are released to the seller and status changes to `Delivered`.

- `cancelOrder(uint256 id)`:  
  Buyer can cancel an order only if it's still in `Placed` status. Refunds the buyer and sets status to `Cancelled`.

- `getOrderStatus(uint256 id)`:  
  Public view function to return the current order status.

### Events

- `OrderPlaced`: Emitted when a new order is placed.
- `OrderShipped`: Emitted when the seller marks the order as shipped.
- `OrderDelivered`: Emitted when the buyer confirms delivery.
- `OrderCancelled`: Emitted when an order is cancelled by the buyer.

## Deployment and Testing in QRemix IDE (optional)

1. Open [QRemix IDE](https://www.qremix.org/).
2. Paste the smart contract into a new file (e.g., `FlipkartEscrow.sol`).
3. Compile with Solidity version `0.8.20`.
4. Navigate to the **Deploy & Run Transactions** tab.
5. Choose environment: **JavaScript VM**, **Injected Provider**, or **Quranium Testnet**.
6. Click **Deploy**.

### Example Usage Flow

1. **Place an Order**
   - Buyer enters ETH value and seller address, then clicks `placeOrder(seller)`.

2. **Mark as Shipped**
   - Seller (same account as passed to `placeOrder`) calls `markAsShipped(orderId)`.

3. **Confirm Delivery**
   - Buyer confirms by calling `confirmDelivery(orderId)`. Funds are released.

4. **Cancel Order**
   - Buyer cancels the order before it's shipped using `cancelOrder(orderId)`.

5. **Check Status**
   - Anyone can call `getOrderStatus(orderId)` to view the current status.

## License

This project is licensed under the MIT License.  
See the `SPDX-License-Identifier: MIT` in the contract file.

## Support

For issues or feature requests:

- Check the QRemix IDE documentation: [https://docs.qremix.org](https://docs.qremix.org)
- Consult OpenZeppelin’s documentation: [https://docs.openzeppelin.com](https://docs.openzeppelin.com)
