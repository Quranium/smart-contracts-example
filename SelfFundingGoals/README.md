# SelfFundingGoals

## Contract Name

**SelfFundingGoals**

---

## Overview

The `SelfFundingGoals` contract is a personal savings contract designed for single-user (deployer-only) interactions. It allows the owner to deposit amount along with a goal-related message, log the purpose of each deposit, view their deposit history, and withdraw the entire balance whenever needed.

This is ideal for individuals who want to self-track their savings goals on-chain with transparency and logging, and can be deployed and tested in the QRemix IDE using a single wallet.

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
constructor()
```

- **Purpose:** Initializes the contract with the deployer as the `owner`.
- **Access:** Called automatically during deployment.

---

### fundGoal

```solidity
function fundGoal(string calldata note) external payable onlyOwner
```

- **Purpose:** Allows the owner to deposit amount with a note describing the savings goal.
- **Access:** Only callable by the owner (deployer).
- **Conditions:** Must send a non-zero amount.
- **Emits:** `GoalFunded(amount, note)`

---

### withdrawAll

```solidity
function withdrawAll() external onlyOwner
```

- **Purpose:** Withdraws all balance from the contract to the owner's wallet.
- **Access:** Only callable by the owner.
- **Conditions:** Contract must have a non-zero balance.
- **Emits:** `AllFundsWithdrawn(amount)`

---

### getBalance

```solidity
function getBalance() external view returns (uint256)
```

- **Purpose:** Returns the current balance held in the contract.
- **Returns:** Balance in wei.

---

### getDepositCount

```solidity
function getDepositCount() external view returns (uint256)
```

- **Purpose:** Returns the number of deposits made (i.e., logged goals).
- **Returns:** Total deposit entries count.

---

### getDeposit

```solidity
function getDeposit(uint256 index) external view returns (uint256 amount, string memory note, uint256 timestamp)
```

- **Purpose:** Returns the details of a specific deposit by index.
- **Access:** Public view.
- **Returns:** Amount, note, and timestamp of the deposit.
- **Conditions:** Index must be less than total deposits.

---

### receive (fallback)

```solidity
receive() external payable
```

- **Purpose:** Accepts amount sent directly to the contract (without function call).
- **Behavior:** Logs the deposit with the note `"Direct deposit"`.
- **Emits:** `GoalFunded(amount, "Direct deposit")`

---

## Access Control

- **Owner (Deployer)** is the only user who can:
  - Fund the goal with notes
  - Withdraw balance
  - View the deposits

Access is enforced using the `onlyOwner` modifier and `msg.sender == owner` logic.

---

## Deployment & Testing on QRemix

### Step 1: Setup

- Open [qremix.org](https://qremix.org)
- Create a new folder: `SelfFundingGoals/`
- Add `SelfFundingGoals.sol` and paste the contract code

### Step 2: Compile

- Go to the **Solidity Compiler** tab
- Select compiler version `0.8.20` or later
- Click **Compile**

### Step 3: Deploy

#### Quranium Testnet

- Go to **Deploy & Run Transactions**
- Select **Injected Provider - MetaMask or QSafe**
- Connect to **Quranium Testnet**
- Click **Deploy** (no constructor arguments needed)

#### JavaScript VM

- Choose **JavaScript VM** (for local testing)
- Click **Deploy**

---

## Testing

### Fund a Goal

- Select `fundGoal(string note)`
- Input a note: `"Saving for Hackathon"`
- Set `Value`: `0.01` ETH or `10000000000000000` wei
- Click **Transact**

### View Deposits

- Call `getDepositCount()` → shows total
- Call `getDeposit(index)` → shows details of a deposit

### Withdraw All

- Call `withdrawAll()` → sends all balance to owner

### Send amount Directly

- Use the **low-level interaction** panel or MetaMask or QSafe to send tokens
- The fallback `receive()` will log the deposit with note `"Direct deposit"`

---

## License

This project is licensed under the MIT License.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

## Support

For help or suggestions, refer to:  
QRemix IDE Documentation: [https://docs.qremix.org](https://docs.qremix.org)
