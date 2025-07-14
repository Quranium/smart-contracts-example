# TimeLockVault

## Contract Name
**TimeLockVault**

---

## Overview
TimeLockVault is a simple ETH time-lock smart contract. It allows the admin to lock funds for any user until a specified future timestamp. The locked funds can only be withdrawn by the user **after the release time**, enforcing time-based escrow-like behavior.

---

## Prerequisites

- MetaMask or QSafe (for testnet deployment)
- Testnet ETH or QRN
- Access to [QRemix IDE](https://qremix.org)
- Basic Solidity knowledge

---

## Contract Functions

### `constructor()`
- **Purpose**: Sets the deployer as the owner (admin)

---

### `lockFunds(address _user, uint256 _releaseTime)`
- **Purpose**: Locks ETH for a user until the given time
- **Access**: Only callable by owner
- **Conditions**:
  - ETH must be sent with transaction
  - Release time must be in the future
  - User must not already have locked funds
- **Emits**: `FundsLocked(address, uint256, uint256)`

---

### `withdraw()`
- **Purpose**: Allows a user to withdraw their funds after the release time
- **Conditions**:
  - Caller must be the recipient of locked funds
  - Current time must be past release time
- **Emits**: `FundsWithdrawn(address, uint256)`

---

## Access Control

- Only **owner** can call `lockFunds`
- Any user can call `withdraw()` for their own funds after release time

---

## Deployment & Testing on QRemix

### 🔹 Step 1: Setup
- Open [qremix.org](https://qremix.org)
- Create folder: `TimeLockVault/`
- Add `TimeLockVault.sol` and paste the contract code

### 🔹 Step 2: Compile
- Go to **Solidity Compiler**
- Select version **0.8.0** or later
- Compile the contract

### 🔹 Step 3: Deploy

#### Quranium Testnet
- Select **Injected Provider - MetaMask**
- Deploy the contract
- Owner = your deployer address

#### JavaScript VM
- Use **JavaScript VM**
- Test lock and withdraw functions with different accounts

### 🔹 Step 4: Testing

#### Flow:
1. Admin calls `lockFunds(user, releaseTime)` with ETH
2. User waits until `releaseTime`
3. User calls `withdraw()` — receives ETH
4. User tries to withdraw again — fails as expected

---

## Events

- `FundsLocked(address indexed user, uint256 amount, uint256 releaseTime)` – when ETH is locked
- `FundsWithdrawn(address indexed user, uint256 amount)` – when ETH is withdrawn

---

## License
This project is licensed under the **MIT License**.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

## Support
For issues or feature requests, refer to:

[QRemix IDE Documentation](https://docs.qremix.org)
