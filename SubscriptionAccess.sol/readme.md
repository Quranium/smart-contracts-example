# SubscriptionAccess

## Contract Name

**SubscriptionAccess**

---

## Overview

The `SubscriptionAccess` contract is a decentralized **subscription service** that manages **access control** through **time-based subscriptions**. It allows users to subscribe to different plans and provides access verification for protected content or services.

It securely handles:
- **Subscription plan management** with pricing and duration
- **User subscription tracking** with expiration dates
- **Access verification** for protected resources
- **Event tracking** for all subscription activities

This project is fully compatible with **QRemix IDE** and can be deployed seamlessly.

---

## Features

- Create and manage subscription plans with custom pricing
- User subscription with automatic expiration tracking
- Real-time access verification for protected content
- Owner-controlled plan creation and fund withdrawal
- Fully tested on **Quranium Testnet**
- Easily integrable with **QRemix**

---

## Prerequisites

- **MetaMask or QSafe** wallet
- **Testnet ETH or QRN**
- **QRemix IDE** ([https://qremix.org](https://qremix.org))
- Basic understanding of **Solidity** & **Subscription Models**

---

## Contract Functions

### 1. createPlan

```solidity
function createPlan(uint256 _price, uint256 _duration) external
```

- **Purpose**: Create a new subscription plan with pricing and duration.
- **Arguments**:
    - `_price`: Subscription price in wei
    - `_duration`: Subscription duration in seconds
- **Requires**:
    - Only contract owner can create plans

---

### 2. subscribe

```solidity
function subscribe(uint256 _planId) external payable
```

- **Purpose**: Subscribe to a plan and gain access for the specified duration.
- **Arguments**:
    - `_planId`: ID of the plan to subscribe to
- **Emits**: `Subscribed(user, planId, expiry)`
- **Requires**:
    - Plan must exist and be valid
    - `msg.value` must equal the plan price

---

### 3. hasAccess

```solidity
function hasAccess(address _user) external view returns (bool)
```

- **Purpose**: Check if a user has active subscription access.
- **Arguments**:
    - `_user`: Address to check access for
- **Returns**: `true` if user has active subscription, `false` otherwise

---

### 4. withdraw

```solidity
function withdraw() external
```

- **Purpose**: Withdraw all contract funds to the owner.
- **Requires**:
    - Only contract owner can withdraw funds

---

## Data Structures

### Plan
```solidity
struct Plan {
    uint256 price;    // Subscription price in wei
    uint256 duration; // Duration in seconds
}
```

### Subscriber
```solidity
struct Subscriber {
    uint256 planId;  // ID of subscribed plan
    uint256 expiry;  // Subscription expiration timestamp
}
```

---

## Events

| Event            | Description                                |
|------------------|----------------------------------------|
| Subscribed       | Emitted when a user subscribes to a plan   |

---

## Error Handling

- Reverts if:
    - Non-owner attempts to create plans
    - Non-owner attempts to withdraw funds
    - Invalid plan ID provided
    - Incorrect payment amount sent
    - Attempting to subscribe to non-existent plan

---

## Security Considerations

- **Owner-only access** for plan creation and fund withdrawal
- **Time-based access control** with automatic expiration
- **Direct fund transfers** to prevent reentrancy
- **Immutable subscription data** once created

---

## Deployment Guide (QRemix)

### Step 1: Setup
- Open [https://qremix.org](https://qremix.org)
- Create a folder: `SubscriptionAccess/`
- Add `Access.sol` and paste the contract

### Step 2: Compile
- Select compiler `0.8.0+`
- Click **Compile**

### Step 3: Deploy
- Go to **Deploy & Run Transactions**
- Select **Injected Provider** (MetaMask/QSafe)
- Connect to **Quranium Testnet**
- Deploy the contract (deployer becomes owner)

---

## Testing Guide

### 1. Creating Subscription Plans
```solidity
createPlan(_priceInWei, _durationInSeconds) // only owner
```

### 2. Subscribing to a Plan
```solidity
subscribe(_planId) // send exact price in ETH
```

### 3. Checking Access Status
```solidity
hasAccess(_userAddress) // returns true/false
```

### 4. Checking Plan Details
```solidity
plans(_planId) // returns price and duration
```

### 5. Checking User Subscription
```solidity
subscribers(_userAddress) // returns planId and expiry
```

### 6. Withdrawing Funds
```solidity
withdraw() // only owner
```

---

## Gas Optimization Tips

- Use **view functions** for access checks
- **Minimize storage operations** in loops
- **Batch plan creation** when possible

---

## Future Improvements

- **Recurring subscription** payments
- **Tiered access levels** with different privileges
- **Subscription upgrades** and downgrades
- **Integration with payment tokens**

---

## License

MIT License © 2025 Quranium Labs

--
