# WhitelistMint

## Contract Name
**WhitelistMint**

---

## Overview
WhitelistMint is a minimal smart contract that allows only **whitelisted users** to mint once. It ensures that users are pre-approved by an admin and that each user can only mint one time. This contract is suitable for simple NFT whitelist checks or pre-sale participation.

---

## Prerequisites

- MetaMask or QSafe (for testnet deployment)
- Testnet ETH or QRN (only if minting involves token interaction)
- Access to [QRemix IDE](https://qremix.org)
- Basic Solidity knowledge

---

## Contract Functions

### `constructor()`
- **Purpose**: Sets the deployer as the contract admin

---

### `addToWhitelist(address _user)`
- **Purpose**: Adds an address to the whitelist
- **Access**: Only callable by admin

---

### `mint()`
- **Purpose**: Allows whitelisted users to mint once
- **Conditions**:
  - Caller must be whitelisted
  - Caller must not have minted already
- **Emits**: `Minted(address user)`

---

## Access Control

- Only **admin** (deployer) can call `addToWhitelist`
- Anyone whitelisted can call `mint()` once

---

## Deployment & Testing on QRemix

### 🔹 Step 1: Setup
- Open [qremix.org](https://qremix.org)
- Create folder: `WhitelistMint/`
- Add `WhitelistMint.sol` and paste the contract code

### 🔹 Step 2: Compile
- Go to **Solidity Compiler**
- Select version **0.8.0** or later
- Compile the contract

### 🔹 Step 3: Deploy

#### Quranium Testnet
- Select **Injected Provider - MetaMask**
- Deploy the contract
- Admin = your deployer address

#### JavaScript VM
- Use **JavaScript VM**
- Simulate minting with different accounts

### 🔹 Step 4: Testing

#### Flow:
1. Admin calls `addToWhitelist(userAddress)`
2. Whitelisted user calls `mint()` — emits `Minted`
3. User tries to mint again — fails as expected

---

## Events

- `Minted(address indexed user)` – Emitted when a user successfully mints

---

## License
This project is licensed under the **MIT License**.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

## Support
For issues or feature requests, refer to:

[QRemix IDE Documentation](https://docs.qremix.org)
