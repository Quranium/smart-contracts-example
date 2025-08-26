# SimpleInsurance

## Contract Name
**SimpleInsurance**

---

## Overview

The `SimpleInsurance` contract provides a basic insurance model where customers can purchase coverage by paying a fixed premium. Once insured, a customer can make a claim, and the contract will automatically pay out the agreed compensation if sufficient funds are available.

The insurer (contract deployer) can fund the contract to ensure liquidity for payouts. This design makes it ideal for learning, prototyping, and demonstrating decentralized insurance systems in a simplified way.

It is designed to be deployed and tested in the QRemix IDE using the JavaScript VM or a testnet.

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
constructor(uint _premium, uint _payoutAmount)
```
- **Purpose:** Initializes the premium (cost of insurance) and payout amount. Sets the deployer as the insurer.
- **Access:** Called on deployment

---

### buyInsurance

```solidity
buyInsurance() external payable
```
- **Purpose:** Allows a customer to buy insurance by paying the exact premium.
- **Condition:** `msg.value` must equal the premium.
- **Effect:** Marks the customer as insured.

---

### makeClaim

```solidity
makeClaim() external
```
- **Purpose:** Lets an insured customer claim their payout.
- **Conditions:**
  - Caller must be insured.
  - Claim must not have been made already.
- **Effect:** Transfers the payout amount to the claimant.

---

### fundContract

```solidity
fundContract() external payable
```
- **Purpose:** Allows the insurer to add funds to the contract to cover future claims.
- **Access:** Only the insurer can call this function.

---

### getBalance

```solidity
getBalance() external view returns (uint)
```
- **Purpose:** Returns the total ETH balance held by the contract.

---

## Access Control

- **Insurer (Deployer):** Deploys, funds the contract, and defines premium/payout amounts.
- **Customers:** Can buy insurance and make claims if insured.

---

## Deployment & Testing on QRemix

### Step 1: Setup
- Open [qremix.org](https://qremix.org)
- Create folder: `SimpleInsurance/`
- Add `SimpleInsurance.sol` and paste the contract code

### Step 2: Compile
- Go to Solidity Compiler
- Select version `0.8.20`
- Compile the contract

### Step 3: Deploy

#### Quranium Testnet
- Go to Deploy & Run Transactions
- Select Injected Provider - MetaMask
- Connect to Quranium testnet
- Deploy with constructor arguments:
  - `_premium` → e.g., `1000000000000000000` (1 ETH in wei)
  - `_payoutAmount` → e.g., `5000000000000000000` (5 ETH in wei)

#### QRemix VM
- Choose QRemix VM
- Deploy directly with constructor arguments (premium & payout).

### Step 4: Testing
- Call `buyInsurance()` with exact ETH equal to premium.
- Call `makeClaim()` from the insured address to get payout.
- Insurer can call `fundContract()` to add liquidity.
- Use `getBalance()` to check available contract funds.

---

## License

This project is licensed under the MIT License.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

## Support
For issues or feature requests, refer to:  
[QRemix IDE Documentation](https://docs.qremix.org)
