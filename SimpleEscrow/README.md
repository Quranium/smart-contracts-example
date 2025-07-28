# SimpleEscrow

## Contract Name  
**SimpleEscrow**

---

## Overview

The `SimpleEscrow` smart contract holds Ether securely between a depositor and a beneficiary. Funds can only be released when an **arbiter** approves the transaction. This is ideal for use cases like **freelancing payments**, **purchase protection**, or **escrow-based trust models**.

The contract is designed for easy deployment and testing on the **QRemix IDE** using the **JavaScript VM** or **Quranium Testnet**.

---

## Contract Functions

### `constructor(address _beneficiary, address _arbiter) payable`
- **Purpose:** Initializes the escrow with a beneficiary and arbiter. Ether must be sent during deployment.
- **Who Can Call:** Only once at deployment by depositor
- **Payable:** Yes
- **Sets:**  
  - `depositor` = `msg.sender`  
  - `beneficiary` = `_beneficiary`  
  - `arbiter` = `_arbiter`

---

### `approve() external`
- **Purpose:** Releases the escrow funds to the beneficiary
- **Who Can Call:** Only the arbiter
- **Requires:** Must not already be approved
- **Effect:** Transfers contract balance to the beneficiary

---

### `getBalance() external view returns (uint256)`
- **Purpose:** Returns current contract balance
- **Who Can Call:** Anyone
- **View Function:** Does not modify state

---

## Access Control

- **Depositor:** The person who deploys the contract with Ether  
- **Beneficiary:** The intended recipient of the funds  
- **Arbiter:** The neutral third-party responsible for approval  
- **Approval Restriction:** Only arbiter can call `approve()`

---

## Deployment & Testing on QRemix

### Step 1: Setup
- Visit: [qremix.org](https://qremix.org)
- Create a new folder: `SimpleEscrow/`
- Add a new file `SimpleEscrow.sol` and paste the contract code

### Step 2: Compile
- Go to **Solidity Compiler**
- Select version `0.8.20`
- Click **Compile SimpleEscrow.sol**

### Step 3: Deploy

#### Using Quranium Testnet
- Go to **Deploy & Run Transactions**
- Select `Injected Provider - MetaMask`
- Ensure Quranium testnet is selected in MetaMask
- Deploy with:
  - `_beneficiary` address
  - `_arbiter` address  
  - Send ETH with deployment (e.g., 0.1 ETH)

#### Using JavaScript VM
- Choose `JavaScript VM`
- Deploy locally with valid `_beneficiary`, `_arbiter`, and value

### Step 4: Testing
- **Approve Funds:**  
  Call `approve()` using the arbiter address
- **View Balance:**  
  Call `getBalance()` anytime to check contract ETH
- **Check Restrictions:**  
  Try calling `approve()` from other accounts—it should fail

---

## License

This project is licensed under the MIT License.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

## Support

For help and documentation, refer to:  
📘 QRemix IDE: https://docs.qremix.org
