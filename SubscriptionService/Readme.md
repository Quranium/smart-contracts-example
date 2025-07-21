# SubscriptionService

## Contract Name
**SubscriptionService**

---

## Overview

The `SubscriptionService` contract enables a simple subscription model where users can pay a fixed fee in ETH to subscribe for a specific duration. If users subscribe again before expiry, their subscription is extended accordingly. The contract supports access verification, subscription renewal, dynamic fee/duration changes, and owner withdrawal of collected ETH.

It is ideal for DApps offering premium content, SaaS platforms, or any time-based services and is designed to be deployed and tested in the QRemix IDE using the JavaScript VM or a testnet.

---

## Prerequisites

- MetaMask or QSafe (for testnet deployment)
- Testnet ETH or QRN
- Access to QRemix IDE
- Basic knowledge of Solidity and smart contract workflow

---

## Contract Functions

### Constructor

```solidity
constructor(uint256 _fee, uint256 _durationInSeconds)
```
- **Purpose:** Initializes the contract with the subscription fee and duration
- **Access:** Called on deployment by the owner

---

### subscribe

```solidity
subscribe()
```
- **Purpose:** Subscribes or extends subscription for the caller based on payment
- **Access:** Callable by anyone
- **Condition:** Must send exact `subscriptionFee` in ETH

---

### isSubscribed

```solidity
isSubscribed(address _user) → bool
```
- **Purpose:** Checks if a given user has an active subscription
- **Returns:** `true` if current timestamp < subscription expiry

---

### getSubscriptionExpiry

```solidity
getSubscriptionExpiry(address _user) → uint256
```
- **Purpose:** Returns the subscription expiry timestamp for a user

---

### updateSubscriptionFee

```solidity
updateSubscriptionFee(uint256 _newFee)
```
- **Purpose:** Updates the subscription fee
- **Access:** Only callable by owner

---

### updateSubscriptionDuration

```solidity
updateSubscriptionDuration(uint256 _newDuration)
```
- **Purpose:** Updates the duration of a subscription period
- **Access:** Only callable by owner

---

### withdraw

```solidity
withdraw()
```
- **Purpose:** Withdraws all collected ETH to the owner's wallet
- **Access:** Only callable by owner
- **Condition:** Contract balance must be greater than zero

---

## Access Control
- **Owner:** Deploys the contract, manages fee/duration, and withdraws funds
- **Subscribers:** Any address can subscribe by paying the correct ETH amount

Access control is enforced through an `onlyOwner` modifier based on the deployer's address.

---

## Deployment & Testing on QRemix
### Step 1: Setup
- Open [qremix.org](https://qremix.org)
- Create folder: `SubscriptionService/`
- Add `SubscriptionService.sol` and paste the contract code

### Step 2: Compile
- Go to **Solidity Compiler**
- Select version `0.8.20`
- Compile the contract

### Step 3: Deploy
**Quranium Testnet**
- Go to **Deploy & Run Transactions**
- Select **Injected Provider - MetaMask**
- Connect to Quranium testnet
- Deploy with appropriate `_fee` (in wei) and `_durationInSeconds`

**JavaScript VM**
- Choose **JavaScript VM**
- Deploy locally with constructor parameters like `100000000000000000` (0.1 ETH) and `2592000` (30 days)

### Step 4: Testing
- Call `subscribe()` with exact ETH from different addresses
- Use `isSubscribed(address)` to check if user has access
- Use `getSubscriptionExpiry(address)` to see expiry timestamp
- Owner can update fee/duration using their respective functions
- Owner can withdraw funds anytime using `withdraw()`

---

## License
This project is licensed under the MIT License.
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

## Support
For issues or feature requests, refer to:
- [QRemix IDE Documentation](https://docs.qremix.org)

