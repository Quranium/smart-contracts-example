# 💼 SimpleWallet Smart Contract

A minimalistic wallet smart contract that allows deposits, message logging with transfers, balance checking, and owner-only withdrawal functionality.

---

## 🧠 Overview

The `SimpleWallet` is a basic contract for handling transactions with the following features:

- Users can deposit funds to the contract.
- Users can send a message along with amount.
- Anyone can check the contract’s balance.
- Only the contract owner can withdraw all the funds.

---

## Deployment and Testing in QRemix IDE

### Step 1: Setup

1. Open qremix.org
2. Copy and paste the respective contract codes

### Step 2: Compilation

1. Go to "Solidity Compiler" tab
2. Select compiler version 0.8.20 or higher
3. Compile `SimpleWallet.sol` first.

### Step 3: Deployment

#### For Quranium Testnet:

1. Go to "Deploy & Run Transactions" tab
2. Select "Injected Provider - MetaMask" as environment
3. Ensure MetaMask/QSafe is connected to Quranium Testnet
4. Deploy `SimpleWallet` contract.
