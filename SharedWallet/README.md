# SharedWallet

## Contract Name

**SharedWallet**

---

## Overview

The `SharedWallet` contract is a multi-signature wallet implementation that allows a primary owner to manage shared access to funds. The contract owner can add or remove shared owners, and any approved owner (including the primary owner) can withdraw funds or transfer them to other addresses. This contract is ideal for family finances, business accounts, or any scenario where multiple parties need controlled access to shared funds.

Built with security and access control in mind, this contract ensures that only authorized addresses can manage or withdraw funds from the shared wallet.

---

## Prerequisites

- **QSafe or MetaMask** (for testnet deployment)
- **Testnet ETH or QRN**
- **QRemix IDE** ([qremix.org](https://qremix.org))
- Basic understanding of Solidity and smart contract interaction

---

## Contract Details

### Access Levels

- **Primary Owner:** The contract deployer with full administrative privileges
- **Shared Owners:** Addresses added by the primary owner with withdrawal capabilities

---

## Contract Functions

### constructor

```solidity
constructor()
```

- **Purpose:** Initializes the contract with the deployer as the primary owner
- **Access:** Called automatically during deployment

---

### addOwner

```solidity
function addOwner(address owner) public isOwner
```

- **Purpose:** Adds a new shared owner to the wallet
- **Access:** Only callable by the primary owner
- **Parameters:** `owner` - Ethereum address to be added as shared owner

---

### removeOwner

```solidity
function removeOwner(address owner) public isOwner
```

- **Purpose:** Removes a shared owner from the wallet
- **Access:** Only callable by the primary owner
- **Parameters:** `owner` - Ethereum address to be removed from shared owners

---

### withdraw

```solidity
function withdraw(uint256 amount) public validOwner
```

- **Purpose:** Withdraws funds from the shared wallet to the caller's address
- **Access:** Callable by primary owner or any shared owner
- **Parameters:** `amount` - Amount of ETH to withdraw in wei
- **Requirements:** Contract must have sufficient balance
- **Emits:** `WithdrawFunds(msg.sender, amount)`

---

### transferTo

```solidity
function transferTo(address payable to, uint256 amount) public validOwner
```

- **Purpose:** Transfers funds from the shared wallet to a specified address
- **Access:** Callable by primary owner or any shared owner
- **Parameters:**
  - `to` - Destination address for the transfer
  - `amount` - Amount of ETH to transfer in wei
- **Requirements:** Contract must have sufficient balance
- **Emits:** `TransferFunds(msg.sender, to, amount)`

---

### receive (fallback)

```solidity
receive() external payable
```

- **Purpose:** Allows the contract to receive ETH deposits
- **Emits:** `DepositFunds(msg.sender, msg.value)`

---

## Access Control Modifiers

### isOwner

```solidity
modifier isOwner()
```

- **Restriction:** Allows only the primary owner to execute the function

### validOwner

```solidity
modifier validOwner()
```

- **Restriction:** Allows primary owner or any shared owner to execute the function

---

## Events

- `DepositFunds(address from, uint256 amount)` - Emitted when ETH is deposited into the contract
- `WithdrawFunds(address from, uint256 amount)` - Emitted when funds are withdrawn from the contract
- `TransferFunds(address from, address to, uint256 amount)` - Emitted when funds are transferred to another address

---

## Deployment & Testing

### Step 1: Setup

- Open [qremix.org](https://qremix.org)
- Create a new file: `SharedWallet.sol`
- Paste the contract code

### Step 2: Compile

- Go to the **Solidity Compiler** tab
- Select compiler version `0.8.28`
- Click **Compile SharedWallet.sol**

### Step 3: Deploy

#### Quranium Testnet

- Go to **Deploy & Run Transactions**
- Select **Injected Provider - MetaMask or QSafe**
- Connect to **Quranium Testnet**
- Click **Deploy**

#### JavaScript VM (Local Testing)

- Choose **JavaScript VM**
- Click **Deploy**

---

## Usage Guide

### Adding Shared Owners

1. After deployment, call `addOwner(address)` from the primary owner's account
2. Provide the Ethereum address of the wallet to grant shared access

### Depositing Funds

1. Send ETH directly to the contract address, or
2. Use the low-level interaction panel in Remix to send ETH to the contract

### Withdrawing Funds

1. As a shared owner or primary owner, call `withdraw(amount)`
2. Specify the amount in wei (e.g., 1000000000000000000 for 1 ETH)

### Transferring Funds

1. As a shared owner or primary owner, call `transferTo(address, amount)`
2. Specify the recipient address and amount in wei

### Removing Shared Owners

1. As the primary owner, call `removeOwner(address)`
2. Provide the Ethereum address to remove from shared owners

---

## Security Considerations

- The primary owner has significant control over the contract
- Shared owners can withdraw any amount from the contract without additional approval
- Regularly monitor and audit the shared owners list
- Consider implementing additional safeguards for large value wallets

---

## License

This project is licensed under the MIT License.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

## Support

For help or suggestions:

For help or suggestions, refer to:  
QRemix IDE Documentation: [https://docs.qremix.org](https://docs.qremix.org)
