# EtherWallet

## Contract Name  
**EtherWallet**

---

## Overview

The `EtherWallet` smart contract provides a simple wallet mechanism on the Ethereum blockchain. It allows **any user to deposit Ether**, but **only the contract owner** (the deployer) can withdraw funds. This contract is useful for demonstrating Ethereum's basic smart contract functionality, fund handling, and ownership control.

The contract is designed to be deployed and tested using the **QRemix IDE**, either with the **JavaScript VM** or the **Quranium Testnet**.

---

## Contract Functions

### `deposit() external payable`
- **Purpose:** Accepts Ether and stores it in the contract
- **Who Can Call:** Anyone
- **State Change:** Increases contract balance
- **Payable:** Yes

---

### `withdraw(uint256 _amount) external`
- **Purpose:** Allows the contract owner to withdraw the specified amount of Ether
- **Who Can Call:** Only the owner (deployer)
- **Requires:** Sufficient balance and correct caller

---

### `getBalance() external view returns (uint256)`
- **Purpose:** Returns the total Ether held in the contract
- **Who Can Call:** Anyone
- **View Function:** Does not modify state

---

## Access Control

- **Owner:** Set to `msg.sender` at deployment  
  - Can withdraw Ether using `withdraw()`
- **Public Users:** Can deposit Ether using `deposit()`

Ownership logic is implemented directly using `msg.sender`.

---

## Deployment & Testing on QRemix

### Step 1: Setup
- Open [qremix.org](https://qremix.org)
- Create folder: `Escrow/`
- Add `Escrow.sol` and paste the contract code

### Step 2: Compile
- Go to Solidity Compiler
- Select version `0.8.20`
- Compile the contract

### Step 3: Deploy

#### Quranium Testnet
- Go to Deploy & Run Transactions
- Select Injected Provider - MetaMask
- Connect to Quranium testnet
- Deploy with ETH, passing the `_beneficiary`, `_arbiter`, and `_durationInSeconds` values

#### JavaScript VM
- Choose JavaScript VM
- Deploy locally with required constructor parameters and ETH

### Step 4: Testing
- Deploy contract with ETH, beneficiary, arbiter, and time duration
- Call `markAsDelivered()` from the beneficiary address
- Call `releaseToBeneficiary()` from the depositor address
- Call `refundToDepositor()` from arbiter if delivery fails
- Call `resolveDispute(true/false)` from arbiter to test dispute resolution
- Use `claimAfterDeadline()` after 3 days past deadline (simulate using JavaScript VM)

---

## License

This project is licensed under the MIT License.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

## Support

For issues or feature requests, refer to:
QRemix IDE Documentation : https://docs.qremix.org


