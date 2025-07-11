# Simple Storage

## Contract Name
**SimpleStorage**

---

## Overview

The `SimpleStorage` contract is a minimalistic example of storing and retrieving a single unsigned integer (`uint`) on the Ethereum blockchain. It provides a simple interface with `set()` and `get()` functions and is ideal for educational, demo, or testing purposes.

This contract is perfect for:
- Understanding gas usage
- Learning state variables
- Demonstrating read/write functions
- Testing tools like Remix/QRemix IDE, MetaMask, and testnets

It is designed to be deployed and tested in the QRemix IDE using the JavaScript VM or a testnet.

---

## Prerequisites

- QRemix IDE or Remix
- Basic familiarity with Solidity
- MetaMask or QSafe (for testnet deployment)
- Some testnet ETH (if deploying to a testnet)

---

## Contract Functions

### set

```solidity
set(uint _value)
```
- **Purpose:** Stores the passed `_value` in the contract
- **Access:** Public (any address can call this)
- **State Change:** Updates the `value` variable on-chain
- **Gas Cost:** Yes, since it writes to storage

---

### get

```solidity
get() public view returns (uint)
```
- **Purpose:** Returns the currently stored value
- **Access:** Public and view (read-only)
- **Gas Cost:** Free when called via call (not a transaction)

---

## Contract Variables

### value

```solidity
uint public value;
```
- **Description:** Public state variable that stores the most recent value
- **Visibility:** Public (automatically gets a getter function)

---

## Deployment & Testing on QRemix

### Step 1: Setup
- Go to [qremix.org](https://qremix.org)
- Create folder: `SimpleStorage/`
- Add `SimpleStorage.sol` and paste the contract code

### Step 2: Compile
- Open Solidity Compiler
- Choose compiler version `0.8.19`
- Compile the contract

### Step 3: Deploy

#### JavaScript VM (Recommended)
- Go to Deploy & Run Transactions
- Select "JavaScript VM"
- Deploy without any constructor parameters

#### Quranium Testnet
- Select "Injected Provider - MetaMask"
- Make sure MetaMask is connected to Quranium testnet
- Deploy normally

### Step 4: Testing

#### Call `set()`
- Enter a number (e.g. 42) in the input field
- Click the set button to update the value

#### Call `get()`
- Click the get button
- Returns the last stored number (e.g. 42)

#### Access value directly
- You can also call the public variable `value()` to get the stored data

---

## Example Use Case

This contract is a great starting point to:
- Learn about persistent blockchain storage
- Observe transaction gas costs for state changes
- Integrate into a frontend using Web3.js or Ethers.js as a value setter/retriever

---

## License

This project is licensed under the MIT License.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

## Support

For issues or learning help, check:
QRemix IDE Documentation: https://docs.qremix.org