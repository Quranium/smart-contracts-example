#  SimpleWallet Smart Contract

A minimalistic wallet smart contract that allows deposits, message logging with transfers, balance checking, and owner-only withdrawal functionality.

---

## Overview

The `SimpleWallet` is a basic contract for handling transactions with the following features:

- Users can deposit funds to the contract.
- Users can send a message along with amount.
- Anyone can check the contract’s balance.
- Only the contract owner can withdraw all the funds.

---

## Contract Functions Explained

### `constructor()`
- Sets the contract `owner` as the deployer (`msg.sender`).
- This `owner` is the only one allowed to withdraw funds.

---

### `deposit() public payable`
- Allows anyone to deposit tokens into the contract.
- Tokens sent is stored in the contract's balance.

---

### `getBalance() public view returns (uint)`
- Returns the current balance held by the contract.
- Can be called by anyone.

---

###  `sendMessage(string calldata message) public payable returns (string memory)`
- Accepts a `message` and requires tokens to be sent along with the call.
- The message is returned as output.
- Use this when you want to log a message with your deposit.
- `msg.value` must be greater than 0, otherwise the transaction fails.

---

###  `withdrawAll() public`
- Allows only the contract `owner` to withdraw **all** balance in the contract.
- Transfers the full balance to the owner's address.

---

##  Prerequisites

To deploy and test the contracts, you need:

- **MetaMask or QSafe**: Browser extension for testnet deployments (optional).
- **Test ETH or QRN**: Required for testnet deployments (e.g., from a Sepolia faucet like [sepoliafaucet.com](https://sepoliafaucet.com/), Quranium [faucet.quranium.org](https://faucet.quranium.org/) ).
- **QRemix IDE**: Access at [qremix.org](https://www.qremix.org/)
- **Basic Solidity Knowledge**: Smart contract deployment, and Remix IDE usage.

---

##  Deployment and Testing in QRemix IDE

### Step 1: Setup

1. Open [https://www.qremix.org](https://www.qremix.org)
2. Create and paste the contract into `SimpleWallet.sol`

---

### Step 2: Compilation

1. Go to the "Solidity Compiler" tab.
2. Select compiler version **0.8.20** or higher.
3. Compile the `SimpleWallet.sol` file.

---

### Step 3: Deployment

#### For Quranium Testnet:

1. Go to "Deploy & Run Transactions" tab.
2. Select **"Quranium"** as the environment.
3. Make sure **QSafe** is connected to the Quranium Testnet.
4. Click **Deploy** for the `SimpleWallet` contract.

---

##  License

This project is licensed under the **MIT License**.  
See the `SPDX-License-Identifier: MIT` in the contract source file.

---

##  Support

For issues or feature requests:

- Check the official QRemix IDE documentation:  
  [https://docs.qremix.org](https://docs.qremix.org)
