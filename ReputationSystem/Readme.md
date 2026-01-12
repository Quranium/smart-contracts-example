# ReputationSystem

## Contract Name

**ReputationSystem**

---

## Overview

The `ReputationSystem` contract is a decentralized **reputation management system** that allows **moderators** to manage user reputation scores within a community. It provides a transparent and tamper-proof way to track user behavior and contributions.

It securely handles:
- **Reputation score management** for users
- **Moderator role assignment** and management
- **Reputation adjustments** (positive and negative)
- **Event tracking** for all reputation changes

This project is fully compatible with **QRemix IDE** and can be deployed seamlessly.

---

## Features

- Assign and manage moderator roles
- Increase user reputation scores
- Decrease user reputation scores with safety checks
- Transparent reputation tracking with events
- Fully tested on **Quranium Testnet**
- Easily integrable with **QRemix**

---

## Prerequisites

- **MetaMask or QSafe** wallet
- **Testnet ETH or QRN**
- **QRemix IDE** ([https://qremix.org](https://qremix.org))
- Basic understanding of **Solidity** & **Access Control**

---

## Contract Functions

### 1. setModerator

```solidity
function setModerator(address _mod, bool _status) external
```

- **Purpose**: Grant or revoke moderator privileges for an address.
- **Arguments**:
    - `_mod`: Address to set moderator status for
    - `_status`: True to grant moderator role, false to revoke
- **Requires**:
    - Only existing moderators can call this function

---

### 2. giveReputation

```solidity
function giveReputation(address _user, uint256 _score) external
```

- **Purpose**: Increase a user's reputation score.
- **Arguments**:
    - `_user`: Address of the user to reward
    - `_score`: Amount of reputation to add
- **Emits**: `ReputationUpdated(user, newScore)`
- **Requires**:
    - Only moderators can call this function

---

### 3. reduceReputation

```solidity
function reduceReputation(address _user, uint256 _score) external
```

- **Purpose**: Decrease a user's reputation score.
- **Arguments**:
    - `_user`: Address of the user to penalize
    - `_score`: Amount of reputation to subtract
- **Emits**: `ReputationUpdated(user, newScore)`
- **Requires**:
    - Only moderators can call this function
    - User must have sufficient reputation to reduce

---

## Events

| Event            | Description                                |
|------------------|----------------------------------------|
| ReputationUpdated| Emitted when a user's reputation changes   |

---

## Error Handling

- Reverts if:
    - Non-moderator attempts to modify reputation
    - Non-moderator attempts to set moderator status
    - Attempting to reduce reputation below zero
    - Invalid addresses provided

---

## Security Considerations

- **Moderator-only access** for reputation changes
- **Underflow protection** for reputation reduction
- **Immutable reputation history** through events
- **Transparent moderator management**

---

## Deployment Guide (QRemix)

### Step 1: Setup
- Open [https://qremix.org](https://qremix.org)
- Create a folder: `ReputationSystem/`
- Add `Reputation.sol` and paste the contract

### Step 2: Compile
- Select compiler `0.8.0+`
- Click **Compile**

### Step 3: Deploy
- Go to **Deploy & Run Transactions**
- Select **Injected Provider** (MetaMask/QSafe)
- Connect to **Quranium Testnet**
- Deploy the contract (deployer becomes first moderator)

---

## Testing Guide

### 1. Setting Moderator Status
```solidity
setModerator(_moderatorAddress, true) // grant moderator role
setModerator(_moderatorAddress, false) // revoke moderator role
```

### 2. Giving Reputation
```solidity
giveReputation(_userAddress, _score) // only moderators
```

### 3. Reducing Reputation
```solidity
reduceReputation(_userAddress, _score) // only moderators
```

### 4. Checking Reputation
```solidity
reputation(_userAddress) // returns current reputation score
```

### 5. Checking Moderator Status
```solidity
moderators(_address) // returns true if address is moderator
```

---

## Gas Optimization Tips

- Use **mapping** for efficient reputation lookups
- **Minimize storage operations** in loops
- **Batch reputation updates** when possible

---

## Future Improvements

- **Time-decay reputation** system
- **Community voting** for reputation changes
- **Reputation tiers** with different privileges
- **Integration with other DeFi protocols**

---

## License

MIT License © 2025 Quranium Labs

--
