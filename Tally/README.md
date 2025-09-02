# Tally Counter

## Contract Name
Tally

## Overview
The **Tally** smart contract is a simple counter that allows users to increase or decrease a stored integer value.  
It can be deployed and tested in the **QRemix IDE** using the JavaScript VM (local testing) or on testnets such as the **Quranium Testnet** or **Sepolia**.

This contract is useful for learning Solidity basics and testing increment/decrement logic in a blockchain environment.

---

## Prerequisites
To deploy and test the contract, you need:

* **MetaMask or QSafe** (optional): For testnet deployments.
* **Test ETH or QRN**: Required for deploying to Sepolia or Quranium testnet.
* **QRemix IDE**: Access at [qremix.org](https://qremix.org).
* **Basic Solidity Knowledge**: Understanding of contract deployment and function calls.

---

## Contract Details

### State Variables
- **`value`** (`int256`):  
  The stored integer that can be increased or decreased.

### Functions

#### increase()
- **Purpose**: Increment the `value` by 1.  
- **Parameters**: None  
- **Access**: Public (anyone can call)

#### decrease()
- **Purpose**: Decrement the `value` by 1.  
- **Parameters**: None  
- **Access**: Public (anyone can call)

---

## Deployment and Testing in QRemix IDE

### Step 1: Setup
1. Open [qremix.org](https://qremix.org).
2. Create a new file: `Tally.sol`.
3. Copy and paste the contract code.

### Step 2: Compilation
1. Go to the **Solidity Compiler** tab.
2. Select compiler version **0.8.19** or higher.
3. Compile `Tally.sol`.

### Step 3: Deployment

#### For Quranium Testnet:
1. Go to the **Deploy & Run Transactions** tab.
2. Select **Injected Provider - MetaMask** as environment.
3. Connect MetaMask/QSafe to **Quranium Testnet**.
4. Deploy the contract.

#### For JavaScript VM (Local Testing):
1. Go to the **Deploy & Run Transactions** tab.
2. Select **JavaScript VM** as environment.
3. Deploy the contract locally.

---

## Step 4: Testing

1. **Check initial value**: Call `value()` → should return `0` (default).
2. **Increase counter**: Call `increase()` → `value` increases by 1 each call.
3. **Decrease counter**: Call `decrease()` → `value` decreases by 1 each call.
4. **Multiple accounts**: Switch accounts in QRemix/MetaMask and test that anyone can call the functions.
5. **Negative values**: Since `value` is `int256`, it can go below zero.

---

## License
This project is licensed under the MIT License.  
See `SPDX-License-Identifier: MIT` in the contract file.

---

## Support
For help or more information:
* **QRemix Docs**: [docs.qremix.org](https://docs.qremix.org)
