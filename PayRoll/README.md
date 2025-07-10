# Payroll

## Contract Name
**Payroll**

---

## Overview
Payroll is a minimalistic smart contract designed for salary management. A designated manager can assign fixed salaries to employee addresses and pay them directly from the contract’s balance. This is useful for decentralized payroll systems within DAOs, startups, or remote teams.

---

## Prerequisites

- MetaMask or QSafe (for testnet deployment)
- Testnet ETH or QRN
- Access to [QRemix IDE](https://qremix.org)
- Basic understanding of Solidity and access control

---

## Contract Functions

### `setManager(address _manager)`
- **Purpose**: Initializes the manager of the contract
- **Parameters**: `_manager` - the manager's address
- **Access**: Can be called only once

---

### `assignSalary(address employee, uint amount)`
- **Purpose**: Assigns a salary to an employee
- **Parameters**:
  - `employee` - address of the employee
  - `amount` - salary in wei
- **Access**: Only callable by the manager

---

### `pay(address employee)`
- **Purpose**: Pays the assigned salary to the employee
- **Parameters**: `employee` - address to be paid
- **Access**: Only callable by the manager

---

### `receive() external payable`
- **Purpose**: Allows the contract to receive ETH for salary payouts

---

## Access Control

- Only the **manager** can assign salaries and trigger payments
- Manager can be set only once via `setManager`

---

## Deployment & Testing on QRemix

### 🔹 Step 1: Setup
- Open [qremix.org](https://qremix.org)
- Create folder: `Payroll/`
- Add `Payroll.sol` and paste the contract code

### 🔹 Step 2: Compile
- Go to **Solidity Compiler**
- Select version **0.8.0** or later
- Compile the contract

### 🔹 Step 3: Deploy

#### Quranium Testnet
- Select **Injected Provider - MetaMask**
- Connect to Quranium testnet
- Deploy contract and set the manager

#### JavaScript VM
- Use **JavaScript VM**
- Deploy and test locally

### 🔹 Step 4: Testing

1. Call `setManager(managerAddress)` (only once)
2. From manager account, call `assignSalary(employeeAddress, amount)`
3. Send ETH to the contract via a simple transaction
4. Call `pay(employeeAddress)` from manager
5. Verify employee received ETH

---

## License
This project is licensed under the **MIT License**.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

## Support
For issues or feature requests, refer to:

[QRemix IDE Documentation](https://docs.qremix.org)
