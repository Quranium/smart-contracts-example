# Escrow

## Contract Name

**Escrow**

---

## Overview

The `Escrow` contract is a decentralized **escrow service** that facilitates secure transactions between buyers and sellers with **arbitration support**. It holds funds in escrow until both parties agree on completion or an arbitrator resolves disputes.

It securely handles:
- **Fund escrow** for secure transactions
- **Dispute resolution** through arbitration
- **Automatic refunds** when disputes are resolved
- **Event tracking** for all escrow activities

This project is fully compatible with **QRemix IDE** and can be deployed seamlessly.

---

## Features

- Create secure escrow deals between buyers and sellers
- Dispute resolution mechanism with arbitrator
- Automatic fund distribution upon completion
- Refund capability for disputed transactions
- Fully tested on **Quranium Testnet**
- Easily integrable with **QRemix**

---

## Prerequisites

- **MetaMask or QSafe** wallet
- **Testnet ETH or QRN**
- **QRemix IDE** ([https://qremix.org](https://qremix.org))
- Basic understanding of **Solidity** & **Escrow mechanisms**

---

## Contract Functions

### 1. createDeal

```solidity
function createDeal(address _seller) external payable
```

- **Purpose**: Create a new escrow deal with a seller.
- **Arguments**:
    - `_seller`: Address of the seller
- **Emits**: `DealCreated(dealId, buyer, seller, amount)`
- **Requires**:
    - `msg.value` must be greater than 0
    - Valid seller address

---

### 2. completeDeal

```solidity
function completeDeal(uint256 _id) external
```

- **Purpose**: Complete an escrow deal and release funds to seller.
- **Arguments**:
    - `_id`: Deal ID to complete
- **Emits**: `DealCompleted(id)`
- **Requires**:
    - Only the buyer can complete the deal
    - Deal must be in Pending status

---

### 3. raiseDispute

```solidity
function raiseDispute(uint256 _id) external
```

- **Purpose**: Raise a dispute for an escrow deal.
- **Arguments**:
    - `_id`: Deal ID to dispute
- **Requires**:
    - Only buyer or seller can raise dispute
    - Deal must be in Pending status

---

### 4. resolveDispute

```solidity
function resolveDispute(uint256 _id, bool refundBuyer) external
```

- **Purpose**: Resolve a disputed deal by arbitrator.
- **Arguments**:
    - `_id`: Deal ID to resolve
    - `refundBuyer`: Whether to refund buyer (true) or pay seller (false)
- **Emits**: `DealRefunded(id)`
- **Requires**:
    - Only arbitrator can resolve disputes
    - Deal must be in Disputed status

---

## Deal Status

| Status    | Description                                |
|-----------|----------------------------------------|
| Pending   | Deal created, awaiting completion         |
| Completed | Deal completed, funds released to seller  |
| Disputed  | Dispute raised, awaiting arbitration      |
| Refunded  | Dispute resolved, funds refunded to buyer |

---

## Events

| Event            | Description                                |
|------------------|----------------------------------------|
| DealCreated      | Emitted when a new escrow deal is created |
| DealCompleted    | Emitted when a deal is completed          |
| DealRefunded     | Emitted when a deal is refunded           |

---

## Error Handling

- Reverts if:
    - Unauthorized user attempts to complete deal
    - Deal is not in correct status for operation
    - Invalid deal ID provided
    - Non-arbitrator attempts to resolve disputes

---

## Security Considerations

- **Arbitrator role** for dispute resolution
- **Status-based access control** prevents unauthorized actions
- **Direct fund transfers** to prevent reentrancy
- **Immutable deal data** once created

---

## Deployment Guide (QRemix)

### Step 1: Setup
- Open [https://qremix.org](https://qremix.org)
- Create a folder: `Escrow/`
- Add `escrow.sol` and paste the contract

### Step 2: Compile
- Select compiler `0.8.0+`
- Click **Compile**

### Step 3: Deploy
- Go to **Deploy & Run Transactions**
- Select **Injected Provider** (MetaMask/QSafe)
- Connect to **Quranium Testnet**
- Deploy with arbitrator address as constructor parameter

---

## Testing Guide

### 1. Creating an Escrow Deal
```solidity
createDeal(_sellerAddress) // send required ETH
```

### 2. Completing a Deal
```solidity
completeDeal(_dealId) // only buyer can call
```

### 3. Raising a Dispute
```solidity
raiseDispute(_dealId) // buyer or seller can call
```

### 4. Resolving a Dispute
```solidity
resolveDispute(_dealId, _refundBuyer) // only arbitrator
```

### 5. Checking Deal Status
```solidity
deals(_dealId) // returns buyer, seller, amount, status
```

---

## Gas Optimization Tips

- Use **enum** for status management
- **Minimize storage operations** in loops
- **Batch dispute resolutions** when possible

---

## Future Improvements

- **Time-based automatic completion**
- **Multi-signature arbitration**
- **Escrow fee system**
- **Integration with payment tokens**

---

## License

MIT License © 2025 Quranium Labs

--
