# SimpleWallet Smart Contract

A minimalistic wallet smart contract that allows deposits, message logging with transfers, balance checking, and owner-only withdrawal functionality.

---

## Overview

The `SimpleWallet` is a basic contract for handling transactions with the following features:

- Users can deposit funds to the contract.
- Users can send a message along with amount.
- Anyone can check the contract’s balance.
- Only the contract owner can withdraw all the funds.

---

## Prerequisites

To deploy and test the contracts, you need:

- **MetaMask or QSafe**: Browser extension for testnet deployments (optional).
- **Test ETH or QRN**: Required for testnet deployments (e.g., from a Sepolia faucet like [sepoliafaucet.com](https://sepoliafaucet.com/), Quranium [faucet.quranium.org](https://faucet.quranium.org/) ).
    - **QRemix IDE**: Access at [qremix.org.](https://www.qremix.org/)
- **Basic Solidity Knowledge**: Understanding of ERC20 tokens, smart contract deployment, and Remix IDE.

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
2. Select "Quranium" as environment
3. Ensure QSafe is connected to Quranium Testnet
4. Deploy `SimpleWallet` contract.
