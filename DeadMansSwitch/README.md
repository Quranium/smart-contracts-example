# DeadMansSwitch

## Contract Name
**DeadMansSwitch**

---

## Overview
DeadMansSwitch is a self-custodial Ethereum contract that lets the owner designate a beneficiary to receive all funds if the owner fails to check in within a defined time period. Useful for estate planning or contingency control over funds.

---

## Prerequisites

- MetaMask or QSafe (for testnet deployment)
- Testnet ETH or QRN
- Access to [QRemix IDE](https://qremix.org)
- Basic Solidity knowledge

---

## Contract Functions

### `constructor(address _beneficiary, uint256 _timeoutPeriodInDays)`
- **Purpose**: Deploys the contract with ETH, sets the beneficiary and timeout period
- **Inputs**:
  - `_beneficiary`: address to receive ETH after timeout
  - `_timeoutPeriodInDays`: number of days before the switch can be triggered
- **Conditions**:
  - Must send ETH during deployment

---

### `checkIn()`
- **Purpose**: Resets the timer to prevent triggering
- **Access**: Only callable by owner
- **Emits**: `CheckIn(address, uint256)`

---

### `trigger()`
- **Purpose**: Transfers all ETH to beneficiary if timeout has passed
- **Conditions**:
  - Enough time has passed since last check-in
  - Contract has ETH
- **Emits**: `Triggered(address, uint256)`

---

### `getTimeLeft()`
- **Purpose**: View how much time remains before the switch can be triggered
- **Returns**: Seconds remaining

---

## Access Control

- Only **owner** can call `checkIn()`
- Anyone can call `trigger()` after timeout

---

## Deployment & Testing on QRemix

### 🔹 Step 1: Setup
- Open [qremix.org](https://qremix.org)
- Create folder: `DeadMansSwitch/`
- Add `DeadMansSwitch.sol` and paste the contract code

### 🔹 Step 2: Compile
- Go to **Solidity Compiler**
- Select version **0.8.0** or later
- Compile the contract

### 🔹 Step 3: Deploy

#### Quranium Testnet
- Select **Injected Provider - MetaMask**
- Deploy the contract
  - Enter beneficiary address
  - Enter timeout in days
  - Send ETH during deployment

#### JavaScript VM
- Use **JavaScript VM**
- Simulate check-ins, time passage, and triggering

### 🔹 Step 4: Testing

#### Flow:
1. Owner deploys contract with ETH and sets beneficiary
2. Owner calls `checkIn()` regularly
3. Wait until timeout passes
4. Anyone can call `trigger()` — sends ETH to beneficiary
5. Try calling `trigger()` early — fails as expected

---

## Events

- `CheckIn(address indexed owner, uint256 time)` – when owner checks in
- `Triggered(address indexed beneficiary, uint256 amount)` – when switch is triggered

---

## License
This project is licensed under the **MIT License**.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

## Support
For issues or feature requests, refer to:

[QRemix IDE Documentation](https://docs.qremix.org)
