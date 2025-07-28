# ContentSubscription

## Contract Name
**ContentSubscription**

---

## Overview
**ContentSubscription** is a simple, on-chain subscription-based smart contract. Users can pay a fixed fee to subscribe for 30 days. Re-subscribing extends their subscription by another 30 days. Only the contract owner can withdraw accumulated funds.

It’s a decentralized way to manage and monetize exclusive content access.

---

## Prerequisites

- MetaMask or QSafe (for testnet deployment)
- Testnet ETH or QRN
- Access to [QRemix IDE](https://qremix.org)
- Basic understanding of Solidity and time-based access control

---

## Contract Functions

### `setOwner()`
- **Purpose**: Sets the contract owner (only once)
- **Conditions**:
  - Can only be called once by the first user

---

### `subscribe()`
- **Purpose**: Pays the subscription fee and extends access
- **Conditions**:
  - Must send exact `subscriptionFee` (0.01 ETH)
  - Extends current subscription by 30 days

---

### `isSubscribed(address user)`
- **Purpose**: Checks if a user is currently subscribed
- **Returns**: `true` if subscription is active, `false` otherwise

---

### `withdraw()`
- **Purpose**: Allows the owner to withdraw all funds
- **Conditions**:
  - Only callable by the contract owner

---

## Access Control

- `owner` is set permanently by `setOwner()`
- Only the `owner` can call `withdraw()`
- Anyone can call `subscribe()` or `isSubscribed()`

---

## Deployment & Testing on QRemix

### 🔹 Step 1: Setup
- Open [qremix.org](https://qremix.org)
- Create folder: `ContentSubscription/`
- Add `ContentSubscription.sol` and paste the contract code

### 🔹 Step 2: Compile
- Go to **Solidity Compiler**
- Select version **0.8.0** or later
- Compile the contract

### 🔹 Step 3: Deploy

#### Quranium Testnet
- Use **Injected Provider - MetaMask**
- Deploy the contract
- First call `setOwner()` to establish ownership

#### JavaScript VM
- Test with multiple accounts:
  - Call `subscribe()` with 0.01 ETH
  - Call `isSubscribed(address)` to check status
  - Try `withdraw()` from non-owner to test access control

---

## Events

**Note**: This contract does **not emit events**, but you may enhance it by adding events such as:
- `Subscribed(address indexed user, uint timestamp)`
- `Withdrawn(address indexed owner, uint amount)`

---

## License
This project is licensed under the **MIT License**.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

## Support
For issues or feature requests, refer to:

[QRemix IDE Documentation](https://docs.qremix.org)
