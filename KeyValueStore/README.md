# KeyValueStore

## Contract Name
**KeyValueStore**

---

## Overview
KeyValueStore is a simple Solidity smart contract that allows an administrator to store and retrieve key-value pairs. The contract enforces access control such that only the admin can set key-value pairs, while any user can retrieve them.

It is ideal for lightweight configuration storage on-chain and can be deployed using tools like QRemix IDE.

---

## Prerequisites

- MetaMask or QSafe (for testnet deployment)
- Testnet ETH or QRN
- Access to [QRemix IDE](https://qremix.org)
- Basic knowledge of Solidity and contract access control

---

## Contract Functions

### `initializeAdmin(address _admin)`
- **Purpose**: Initializes the admin of the contract
- **Parameters**: `_admin` - the address to set as admin
- **Access**: Can only be called once

---

### `set(string key, string value)`
- **Purpose**: Stores a key-value pair
- **Parameters**:
  - `key` - the key string
  - `value` - the value string
- **Access**: Only callable by admin

---

### `get(string key)`
- **Purpose**: Retrieves the value associated with a key
- **Parameters**: `key` - the key string
- **Returns**: The stored value string

---

## Access Control

- Only the **admin** (set via `initializeAdmin`) can call `set`
- Any user can call `get`
- Admin can be initialized **only once**

---

## Deployment & Testing on QRemix

### 🔹 Step 1: Setup
- Open [qremix.org](https://qremix.org)
- Create folder: `KeyValueStore/`
- Add `KeyValueStore.sol` and paste the contract code

### 🔹 Step 2: Compile
- Go to **Solidity Compiler**
- Select version **0.8.0** or later
- Compile the contract

### 🔹 Step 3: Deploy

#### Quranium Testnet
- Go to **Deploy & Run Transactions**
- Select **Injected Provider - MetaMask**
- Connect to Quranium testnet
- Deploy the contract

#### JavaScript VM
- Choose **JavaScript VM**
- Deploy the contract locally

### 🔹 Step 4: Testing

1. Call `initializeAdmin(adminAddress)` (only once)
2. Use the admin address to call `set("exampleKey", "exampleValue")`
3. Call `get("exampleKey")` from any address and verify the stored value

---

## License
This project is licensed under the **MIT License**.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

## Support
For issues or feature requests, refer to:

[QRemix IDE Documentation](https://docs.qremix.org)
