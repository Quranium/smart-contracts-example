# MultiSig Wallet

## Contract Name
**SimpleMultiSigNoConstructor**

---

## Overview

The `SimpleMultiSigNoConstructor` contract implements a basic multisignature wallet without a constructor. It allows a group of addresses (owners) to collectively manage and approve transactions. Funds are only released once a predefined number of confirmations are collected for a submitted transaction.

**Features:**
- On-chain setup via `setup()` function
- Transaction submission by any owner
- Multi-owner confirmation flow
- Automatic execution once threshold is met

It is ideal for secure fund management by DAOs, joint accounts, and treasury teams.  
The contract is designed to be deployed and tested in the QRemix IDE using the JavaScript VM or a testnet.

---

## Prerequisites

- MetaMask or QSafe (for testnet deployment)
- Testnet ETH or QRN
- Access to QRemix IDE
- Basic knowledge of Solidity, modifiers, and multi-sig mechanisms

---

## Contract Functions

### setup

```solidity
setup(address[] memory _owners, uint _required)
```
- **Purpose:** Initializes owners and required confirmations for execution
- **Access:** Callable once by any address
- **Validation:** `_owners.length >= _required && _required > 0`
- **State Change:** Sets owners, marks contract as initialized

---

### submit

```solidity
submit(address to, uint value)
```
- **Purpose:** Creates a new transaction to be executed after confirmation
- **Access:** Only callable by an owner
- **State Change:** Appends new transaction to the list with `executed = false`

---

### confirm

```solidity
confirm(uint txIndex)
```
- **Purpose:** Approves a pending transaction
- **Access:** Only callable by an owner who hasn't confirmed the transaction yet
- **Execution Trigger:** Automatically executes once confirmations meet the required threshold

---

### receive

```solidity
receive() external payable
```
- **Purpose:** Allows the contract to receive ETH
- **Access:** Anyone can send ETH directly to the contract
- **Use Case:** Fund the multi-sig wallet for shared disbursements

---

## Access Control

- **Owners:** Only owners can call `submit()` and `confirm()` functions
- **Initial Setup:** Anyone can call `setup()` exactly once to initialize the owners and threshold

**Access control is enforced via:**
- `onlyOwner` modifier: Ensures only designated owners can perform sensitive actions
- `notInitialized` modifier: Prevents re-initialization after first setup

---

## Deployment & Testing on QRemix

### Step 1: Setup
- Visit [qremix.org](https://qremix.org)
- Create folder: `MultiSig/`
- Add `SimpleMultiSigNoConstructor.sol` and paste the contract code

### Step 2: Compile
- Go to Solidity Compiler
- Select version `0.8.19`
- Compile the contract

### Step 3: Deploy

#### JavaScript VM (Recommended for testing)
- Choose JavaScript VM
- Deploy contract without parameters (no constructor)

#### Quranium Testnet
- Use Injected Provider - MetaMask
- Deploy without any constructor parameters
- After deployment, call `setup()` with array of owners and required confirmations

### Step 4: Test the Workflow

#### Fund the contract
- Use the address tab to send ETH directly to contract

#### Setup Owners
- Call `setup()` once with desired owner addresses and required confirmations

#### Submit Transaction
- From one of the owner accounts, call `submit(to, value)`

#### Confirm Transaction
- Other owners call `confirm(txIndex)`
- Once the number of confirmations meets the threshold, the transaction executes

#### Verify Execution
- Check the recipient address to verify if ETH was received

---

## Example Use Case

Let’s say 3 founders of a DAO want 2 of them to approve before any ETH gets transferred:

1. Deploy the contract
2. Call `setup([addr1, addr2, addr3], 2)`
3. Any one submits a transaction
4. Any 2 of the 3 owners confirm it
5. Transaction is executed automatically 🪙

---

## License

This project is licensed under the MIT License.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

## Support

For issues or improvements, refer to:
QRemix IDE Docs: https://docs.qremix.org