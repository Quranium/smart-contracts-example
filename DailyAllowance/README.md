# DailyAllowance

## Contract Name

**DailyAllowance**

---

## Overview

The `DailyAllowance` contract is a personal budgeting smart contract designed for **single-user** (deployer-only) interaction. It allows the contract owner to withdraw a fixed allowance once every 24 hours. This is ideal for individuals who want to self-impose withdrawal limits on their funds and simulate a smart contract-based daily budget system.

Deployed and tested easily using [QRemix IDE](https://qremix.org) with only a single wallet.

---

## Prerequisites

- **QSafe or MetaMask** (for testnet deployment)
- **Testnet ETH or QRN**
- **QRemix IDE** ([qremix.org](https://qremix.org))
- Basic understanding of Solidity and smart contract interaction

---

## Contract Functions

### constructor

```solidity
constructor(uint256 _allowanceAmount)
```

- **Purpose:** Initializes the contract with the deployer as the `owner` and sets the fixed daily allowance.
- **Access:** Called automatically during deployment.
- **Arguments:** `_allowanceAmount` in wei (e.g., `100000000000000000` for 0.1 ETH/QRN).

---

### setAllowance

```solidity
function setAllowance(uint256 _amount) external onlyOwner
```

- **Purpose:** Updates the daily allowance amount.
- **Access:** Only callable by the owner.
- **Emits:** `AllowanceUpdated(_amount)`

---

### deposit

```solidity
function deposit() external payable
```

- **Purpose:** Allows the owner to deposit amount into the contract.
- **Conditions:** Must send a non-zero amount.
- **Emits:** `Deposited(msg.sender, msg.value)`

---

### claim

```solidity
function claim() external onlyOwner canClaim
```

- **Purpose:** Transfers the daily allowance to the owner.
- **Access:** Only callable by the owner.
- **Conditions:** Can only be claimed once every 24 hours.
- **Emits:** `Claimed(owner, allowanceAmount)`

---

### getBalance

```solidity
function getBalance() external view returns (uint256)
```

- **Purpose:** Returns the current balance in the contract.
- **Returns:** Balance in wei.

---

### timeUntilNextClaim

```solidity
function timeUntilNextClaim() external view returns (uint256)
```

- **Purpose:** Returns the time remaining (in seconds) until the next claim is allowed.
- **Returns:** `0` if claim is currently available.

---

### receive (fallback)

```solidity
receive() external payable
```

- **Purpose:** Allows direct transfers to the contract.
- **Emits:** `Deposited(msg.sender, msg.value)`

---

## Access Control

- **Owner (Deployer)** is the only one allowed to:
  - Claim the allowance
  - Change the daily allowance
  - Deposit amount
- Access is enforced using the `onlyOwner` modifier (`msg.sender == owner`).

---

## Deployment & Testing on QRemix

### Step 1: Setup

- Open [qremix.org](https://qremix.org)
- Create a new folder: `DailyAllowance/`
- Add `DailyAllowance.sol` and paste the contract code

---

### Step 2: Compile

- Go to the **Solidity Compiler** tab
- Select compiler version `0.8.20` or later
- Click **Compile**

---

### Step 3: Deploy

#### Quranium Testnet

- Go to **Deploy & Run Transactions**
- Select **Injected Provider - MetaMask or QSafe**
- Connect to **Quranium Testnet**
- Set constructor argument (e.g., `100000000000000000` for 0.1 ETH/QRN)
- Click **Deploy**

#### JavaScript VM

- Choose **JavaScript VM** (for local testing)
- Set constructor argument
- Click **Deploy**

---

## Testing

### Deposit Funds

- Call `deposit()` with `Value`: e.g., `1 ETH` or `1000000000000000000` wei

### Claim Daily Allowance

- Call `claim()`
- Fails if 24 hours have not passed since the last claim

### Change Allowance

- Call `setAllowance(newAmountInWei)` to update the daily withdrawal amount

### Check Balance

- Call `getBalance()` to view how much balance the contract holds

### Check Claim Timer

- Call `timeUntilNextClaim()` → shows how long (in seconds) until the next claim is allowed

### Send Directly

- Use MetaMask, QSafe, or the low-level interaction panel in QRemix to send QRN directly to the contract address

---

## Events

- `Deposited(address indexed from, uint256 amount)`
- `Claimed(address indexed owner, uint256 amount)`
- `AllowanceUpdated(uint256 newAmount)`

---

## License

This project is licensed under the MIT License.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

## Support

For help or suggestions, refer to:  
QRemix IDE Documentation: [https://docs.qremix.org](https://docs.qremix.org)
