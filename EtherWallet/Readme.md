# EtherWallet

## Contract Name  
**EtherWallet**

---

## Overview

The `EtherWallet` smart contract provides a simple wallet mechanism on the Ethereum blockchain. It allows **any user to deposit Ether**, but **only the contract owner** (the deployer) can withdraw funds. This contract is useful for demonstrating Ethereum's basic smart contract functionality, fund handling, and ownership control.

The contract is designed to be deployed and tested using the **QRemix IDE**, either with the **JavaScript VM** or the **Quranium Testnet**.

---

## Prerequisites

- QSafe (for testnet transactions)
- QRN (Quranium testnet tokens)
- Access to [QRemix IDE](https://qremix.org)
- Basic knowledge of Solidity and smart contract workflow

---

## Contract Functions

### `deposit() external payable`
- **Purpose:** Accepts Ether and stores it in the contract
- **Who Can Call:** Anyone
- **State Change:** Increases contract balance
- **Payable:** Yes

---

### `withdraw(uint256 _amount) external`
- **Purpose:** Allows the contract owner to withdraw the specified amount of Ether
- **Who Can Call:** Only the owner (deployer)
- **Requires:** Sufficient balance and correct caller

---

### `getBalance() external view returns (uint256)`
- **Purpose:** Returns the total Ether held in the contract
- **Who Can Call:** Anyone
- **View Function:** Does not modify state

---

## Access Control

- **Owner:** Set to `msg.sender` at deployment  
  - Can withdraw Ether using `withdraw()`
- **Public Users:** Can deposit Ether using `deposit()`

Ownership logic is implemented directly using `msg.sender`.

---

## Contract Code

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EtherWallet {
    address public owner = msg.sender;

    function deposit() public payable {}

    function withdraw(uint256 _amount) public {
        require(msg.sender == owner, "Not owner");
        payable(owner).transfer(_amount);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
