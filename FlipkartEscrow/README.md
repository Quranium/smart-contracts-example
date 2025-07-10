Flipkart Escrow

Contract Name
FlipkartEscrow

Overview
FlipkartEscrow is a minimal smart contract designed for secure order transactions between buyers and sellers. It holds buyer funds in escrow and only releases them to the seller upon buyer's confirmation of delivery. The contract ensures a fair and trustless process similar to platforms like Flipkart.

They are designed to be deployed and tested in the QRemix IDE using the JavaScript VM or a testnet like Quranium testnet, Sepolia etc.

Prerequisites
To deploy and test the contract, you need:

MetaMask or QSafe: Browser extension for testnet deployments (optional).

Test ETH or QRN: Required for testnet deployments.

QRemix IDE: Access at qremix.org.

Basic Solidity Knowledge: Understanding of smart contract deployment, payable functions, and enum states.

Contract Details
Functions
placeOrder(address payable seller)
Purpose: Places an order by depositing ETH into escrow.

Parameters:

seller: Address of the seller.

Payable: Yes

Returns: Order ID (uint256)

markAsShipped(uint256 orderId)
Purpose: Seller marks the order as shipped.

Parameters:

orderId: ID of the order to update.

Access: Only the seller of that order.

confirmDelivery(uint256 orderId)
Purpose: Buyer confirms delivery, releasing payment to the seller.

Parameters:

orderId: ID of the order to confirm.

Access: Only the buyer of that order.

cancelOrder(uint256 orderId)
Purpose: Buyer cancels the order before it is shipped and receives a refund.

Parameters:

orderId: ID of the order to cancel.

Access: Only the buyer of that order.

getOrderStatus(uint256 orderId)
Purpose: Retrieves the current status of the order.

Parameters:

orderId: ID of the order.

Returns: Enum Status: Placed, Shipped, Delivered, or Cancelled

Events
OrderPlaced(uint256 indexed id, address buyer, address seller, uint256 amount)

OrderShipped(uint256 indexed id)

OrderDelivered(uint256 indexed id)

OrderCancelled(uint256 indexed id)

Deployment and Testing in QRemix IDE
Step 1: Setup
Open qremix.org

Create folder structure: FlipkartEscrow/

Create FlipkartEscrow.sol in the folder

Paste the contract code

Step 2: Compilation
Go to "Solidity Compiler" tab

Select compiler version 0.8.20 or higher

Compile FlipkartEscrow.sol

Step 3: Deployment
For Quranium Testnet:
Go to "Deploy & Run Transactions" tab

Select "Injected Provider - MetaMask" as environment

Ensure MetaMask/QSafe is connected to Quranium Testnet

Deploy the FlipkartEscrow contract

For JavaScript VM (Local Testing):
Select "JavaScript VM" as environment

Deploy FlipkartEscrow contract

Step 4: Testing
Test Order Flow:
From a buyer account, call placeOrder with a seller address and ETH

From the seller account, call markAsShipped using the order ID

From the buyer account, call confirmDelivery using the same order ID

Verify seller received ETH and order status is Delivered

Test Cancel Flow:
Place a new order

From buyer account, call cancelOrder before shipping

Verify refund is returned and status is Cancelled

Test Restrictions:
Only buyer can cancel or confirm delivery

Only seller can mark order as shipped

Orders cannot be cancelled after shipping

Orders cannot be delivered without shipping

License
This project is licensed under the MIT License. See the SPDX-License-Identifier: MIT in the contract file.

Support
For issues or feature requests:

Check the QRemix IDE documentation: https://docs.qremix.org