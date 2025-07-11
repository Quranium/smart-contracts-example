# SimpleAuction

## Contract Name
**SimpleAuction**

---

## Overview
SimpleAuction is a basic auction smart contract where participants can place bids, and the highest bidder wins when the auction ends. Outbid users can withdraw their bids as refunds. Only the owner (deployer) can end the auction and claim the winning amount.

---

## Prerequisites

- MetaMask or QSafe (for testnet deployment)
- Testnet ETH or QRN
- Access to [QRemix IDE](https://qremix.org)
- Basic Solidity knowledge

---

## Contract Functions

### `constructor()`
- **Purpose**: Sets the deployer as the owner of the auction
- **Access**: Internal, runs on contract deployment

---

### `bid() external payable`
- **Purpose**: Allows users to place a higher bid
- **Payable**: Yes
- **Conditions**:
  - Auction must not have ended
  - Bid must be higher than current highest

---

### `withdrawRefund() external`
- **Purpose**: Lets users withdraw their previous bids if they’ve been outbid
- **Conditions**:
  - Caller must have a refundable amount

---

### `endAuction() external`
- **Purpose**: Ends the auction and transfers the highest bid to the owner
- **Access**: Only owner can call
- **Conditions**:
  - Auction must not have already ended

---

## Auction Flow

1. Deploy contract — `owner = deployer`
2. Users call `bid()` with increasing ETH
3. Outbid users can call `withdrawRefund()`
4. Owner calls `endAuction()` to finalize and receive the highest bid

---

## Deployment & Testing on QRemix

### 🔹 Step 1: Setup
- Open [qremix.org](https://qremix.org)
- Create folder: `SimpleAuction/`
- Add `SimpleAuction.sol` and paste the contract code

### 🔹 Step 2: Compile
- Go to **Solidity Compiler**
- Select version **0.8.0** or later
- Compile the contract

### 🔹 Step 3: Deploy

#### Quranium Testnet
- Select **Injected Provider - MetaMask**
- Deploy and become auction owner

#### JavaScript VM
- Use **JavaScript VM**
- Simulate bids and auction lifecycle

### 🔹 Step 4: Testing

#### Bidding Flow:
1. Call `bid()` from multiple accounts with increasing amounts
2. Call `withdrawRefund()` from outbid users
3. Call `endAuction()` from owner to finalize
4. Ensure funds transfer to owner

---

## License
This project is licensed under the **MIT License**.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

## Support
For issues or feature requests, refer to:

[QRemix IDE Documentation](https://docs.qremix.org)
