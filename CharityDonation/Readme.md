# CharityDonationPool

## Contract Name

**CharityDonationPool**

---

## Overview

The `CharityDonationPool` contract acts as a transparent donation pool for charity projects. Donors can contribute Ether, and the contract owner can allocate funds to beneficiaries. The contract keeps track of individual donations and the total donated amount.

This contract is ideal for fundraising prototypes, community-driven donation platforms, and learning owner-controlled fund allocation in Solidity.

---

## Prerequisites

* MetaMask or QSafe (for testnet deployment)
* Testnet ETH or QRN
* Access to QRemix IDE (or any Solidity dev environment)
* Basic knowledge of Solidity and fund management

---

## Contract Functions

### Constructor

```solidity
constructor()
```

* **Purpose:** Initializes the contract and sets the deployer as the owner.
* **Access:** Deployment-only.

---

### donate

```solidity
donate() payable
```

* **Purpose:** Accepts Ether donations from any address.
* **Access:** Public, payable.
* **Condition:** `msg.value > 0`.
* **Emits:** `Donated` event.

---

### allocate

```solidity
allocate(address payable beneficiary, uint256 amount)
```

* **Purpose:** Sends a specified amount to a beneficiary.
* **Access:** Only contract owner.
* **Condition:** `amount <= contract balance`.
* **Emits:** `Allocated` event.

---

### getBalance

```solidity
getBalance() → uint256
```

* **Purpose:** Returns the total Ether balance held in the contract.
* **Access:** Public view.

---

## Access Control

* **Owner (Deployer):** Can allocate funds to beneficiaries.
* **Donors:** Can contribute ETH but cannot control fund allocation.

---

## Deployment & Testing on QRemix

### Step 1: Setup

* Open [qremix.org](https://qremix.org)
* Create folder: `CharityDonationPool/`
* Add `CharityDonationPool.sol` and paste the contract code.

### Step 2: Compile

* Go to Solidity Compiler
* Select version `0.8.19` (or compatible)
* Compile the contract

### Step 3: Deploy

* Deploy directly (no constructor args).

### Step 4: Testing Flow

1. Donor calls `donate()` sending ETH.
2. Owner calls `getBalance()` to check pool balance.
3. Owner calls `allocate(beneficiaryAddress, amount)` to transfer funds.
4. Beneficiary receives funds.

---

## Security Notes & Recommendations

* Contract uses `transfer`, which forwards limited gas. For more complex beneficiary contracts, switch to `call`.
* Centralized allocation by owner — for production, replace with DAO or multisig for decentralized governance.
* Add donation caps, minimums, or recurring donation logic as enhancements.


