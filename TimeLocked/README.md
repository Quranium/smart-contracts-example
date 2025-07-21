# TimeLockedVault

## Contract Name  
**TimeLockedVault**

---

## Overview

The **TimeLockedVault** smart contract allows users to deposit ETH and lock it for a specific duration. Once locked, funds can only be withdrawn after the lock time has passed. This ensures a secure and decentralized way to time-restrict access to funds — useful for vesting, savings, or trustless time delays.

The contract is constructor-free and requires no admin. It is fully self-serve and public, and works on any EVM-compatible blockchain.

---

## Prerequisites

- MetaMask or QSafe wallet (for testnet deployment)
- Testnet ETH or QRN
- Remix or QRemix IDE
- Basic knowledge of Solidity and ETH transfers

---

## Contract Functions

### deposit

```solidity
deposit(uint256 lockDurationInSeconds)
