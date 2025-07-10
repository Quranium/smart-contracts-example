# RefundableSale

## Contract Name
**RefundableSale**

---

## Overview
RefundableSale is a basic crowdfunding smart contract that allows users to contribute ETH toward a funding goal. If the goal is met by the deadline, the seller can claim the funds. Otherwise, contributors can get refunds. This ensures a fair and trustless fundraising process.

---

## Prerequisites

- MetaMask or QSafe (for testnet deployment)
- Testnet ETH or QRN
- Access to [QRemix IDE](https://qremix.org)
- Basic Solidity knowledge

---

## Contract Functions

### `init(address _seller, uint _goal, uint _duration)`
- **Purpose**: Initializes the contract with seller address, funding goal, and duration
- **Parameters**:
  - `_seller` - address of the seller
  - `_goal` - funding goal in wei
  - `_duration` - duration in seconds
- **Access**: Callable only once

---

### `contribute() external payable`
- **Purpose**: Allows users to contribute ETH before the deadline
- **Payable**: Yes
- **Access**: Open to anyone before the deadline

---

### `refund() external`
- **Purpose**: Allows contributors to withdraw their funds if goal is not met
- **Access**: After deadline, only if goal is not met
- **Conditions**:
  - Caller must have contributed
  - Goal must not be met

---

### `claimFunds() external`
- **Purpose**: Allows seller to claim raised funds if goal is met
- **Access**: Only the seller, after deadline
- **Conditions**:
  - Total raised ≥ goal
  - Only callable once

---

## Flow Summary

1. **Initialize**: Call `init(seller, goal, duration)` once
2. **Contribute**: Users call `contribute()` before the deadline
3. **After Deadline**:
   - If **goal met**: Seller calls `claimFunds()`
   - If **goal not met**: Contributors call `refund()`

---

## Deployment & Testing on QRemix

### 🔹 Step 1: Setup
- Open [qremix.org](https://qremix.org)
- Create folder: `RefundableSale/`
- Add `RefundableSale.sol` and paste the contract code

### 🔹 Step 2: Compile
- Go to **Solidity Compiler**
- Select version **0.8.0** or later
- Compile the contract

### 🔹 Step 3: Deploy

#### Quranium Testnet
- Select **Injected Provider - MetaMask**
- Deploy and call `init(...)`

#### JavaScript VM
- Use **JavaScript VM**
- Deploy contract and simulate full sale flow

### 🔹 Step 4: Testing

#### Fundraising Flow:
1. Deploy contract and call `init(...)`
2. Call `contribute()` from multiple accounts
3. Check `totalRaised` and wait until deadline

#### Claim Scenario:
- If goal is met, call `claimFunds()` from seller

#### Refund Scenario:
- If goal not met, call `refund()` from contributor accounts

---

## License
This project is licensed under the **MIT License**.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

## Support
For issues or feature requests, refer to:

[QRemix IDE Documentation](https://docs.qremix.org)
