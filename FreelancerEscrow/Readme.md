# Escrow

## Contract Name
**Escrow**

---

## Overview

The Escrow contract facilitates secure transactions between a depositor and a beneficiary, with an arbiter acting as a third party in case of disputes. The contract ensures that the funds are only released once the beneficiary delivers the agreed service or product, or upon arbiter resolution. It supports deadline-based cancellation, refunding, and post-deadline automatic claims.

It is ideal for freelance or service-based payment systems and is designed to be deployed and tested in the QRemix IDE using the JavaScript VM or a testnet.

---

## Prerequisites

- MetaMask or QSafe (for testnet deployment)
- Testnet ETH or QRN
- Access to QRemix IDE
- Basic knowledge of Solidity and smart contract workflow

---

## Contract Functions

### Constructor

```solidity
constructor(address _beneficiary, address _arbiter, uint256 _durationInSeconds)
```
- **Purpose:** Initializes the contract with beneficiary, arbiter, deadline duration, and accepts ETH from depositor
- **Access:** Called on deployment (depositor is `msg.sender`)

### markAsDelivered

```solidity
markAsDelivered()
```
- **Purpose:** Beneficiary marks the task as delivered
- **Access:** Only callable by beneficiary
- **State Required:** `AWAITING_DELIVERY`

### releaseToBeneficiary

```solidity
releaseToBeneficiary()
```
- **Purpose:** Releases funds to beneficiary after delivery confirmation
- **Access:** Only callable by depositor
- **State Required:** `DELIVERED`

### refundToDepositor

```solidity
refundToDepositor()
```
- **Purpose:** Refunds deposited amount to depositor if work wasn't delivered
- **Access:** Callable by depositor or arbiter
- **State Required:** `AWAITING_DELIVERY`

### cancelEscrow

```solidity
cancelEscrow()
```
- **Purpose:** Cancels the escrow before deadline and refunds depositor
- **Access:** Only callable by depositor
- **State Required:** `AWAITING_DELIVERY`
- **Condition:** Only before deadline

### resolveDispute

```solidity
resolveDispute(bool releaseToFreelancer)
```
- **Purpose:** Lets arbiter resolve disputes by choosing who gets the funds
- **Access:** Only arbiter
- **State Required:** `AWAITING_DELIVERY` or `DELIVERED`

### claimAfterDeadline

```solidity
claimAfterDeadline()
```
- **Purpose:** Allows depositor to release funds to beneficiary if no action is taken 3 days after deadline
- **Access:** Only depositor
- **State Required:** `DELIVERED`

### getEscrowDetails

```solidity
getEscrowDetails()
```
- **Purpose:** Returns the full escrow details like parties, amount, state, deadline, and delivery confirmation
- **Returns:** depositor, beneficiary, arbiter, amount, state, deadline, delivery status

### getWorkState

```solidity
getWorkState()
```
- **Purpose:** Returns the escrow state as a string
- **Returns:** Human-readable escrow state (`AWAITING_DELIVERY`, `DELIVERED`, etc.)

---

## Access Control

- **Depositor:** Initiates escrow, releases funds, cancels escrow, and can request refund
- **Beneficiary:** Marks task as delivered
- **Arbiter:** Resolves disputes impartially

Access is strictly enforced using modifiers and enum-based state checks.

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