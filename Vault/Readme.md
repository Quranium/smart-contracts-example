# SimpleVault Contract

## Contract Name
SimpleVault

## Overview
SimpleVault is a minimal smart contract that allows users to deposit and withdraw **Ether (ETH)** while maintaining internal balance records. It supports safe ETH handling using mappings and events to log each transaction.

This contract is ideal for learning and demonstration purposes and can be deployed directly on **QRemix IDE** using the JavaScript VM or testnets like **Quranium**, **Sepolia**, etc.

## Prerequisites

To deploy and test this contract, you need:
* **MetaMask or QSafe** – Optional for testnet deployment
* **Test ETH / QRN** – Get from [faucet.quranium.org](https://faucet.quranium.org)
* **QRemix IDE** – Available at [https://qremix.org](https://qremix.org)
* **Basic Solidity Knowledge**

## Contract Details

### State Variables

- **owner**: `address` – The deployer of the contract
- **balances**: `mapping(address => uint256)` – Tracks each user’s internal ETH balance

### Main Functions

#### Constructor
- **Purpose**: Initializes the `owner` of the contract as the deployer
- **Parameters**: None
- **Behavior**: Sets the `owner` once during deployment

#### deposit
- **Function**: `deposit() external payable`
- **Purpose**: Allows users to deposit ETH into the vault
- **Requirements**: `msg.value` must be greater than 0
- **Behavior**:
  - Adds deposited ETH to `msg.sender`'s internal balance
  - Emits `Deposited` event

#### withdraw
- **Function**: `withdraw(uint256 amount)`
- **Purpose**: Allows users to withdraw ETH from their vault balance
- **Parameters**:
  - `amount`: Amount of ETH to withdraw (in wei)
- **Requirements**:
  - Caller must have a sufficient balance
- **Behavior**:
  - Subtracts amount from user’s internal balance
  - Transfers actual ETH to user’s wallet
  - Emits `Withdrawn` event

#### vaultBalance
- **Function**: `vaultBalance() external view returns (uint256)`
- **Purpose**: Returns total ETH held by the contract
- **Access**: Public view

### Receive Function

#### receive()
- **Purpose**: Accepts direct ETH transfers to the contract
- **Behavior**:
  - Adds sent ETH to `msg.sender`’s internal balance
  - Emits `Deposited` event

### Events

- **Deposited**: `Deposited(address indexed user, uint256 amount)`
  - Emitted whenever ETH is deposited via `deposit()` or `receive()`

- **Withdrawn**: `Withdrawn(address indexed user, uint256 amount)`
  - Emitted whenever a user successfully withdraws ETH

## Security Notes

- There is no admin-only access to balances — all logic is self-service
- No external contract calls are made; no reentrancy risk in current structure
- ETH can be safely received using the `receive()` fallback

## Deployment

Deploy directly using:
- **QRemix JavaScript VM** (no wallet needed)
- **Quranium Testnet / Sepolia** using MetaMask + injected provider

## License

MIT License – Feel free to use and modify with attribution.
