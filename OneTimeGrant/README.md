# OneTimeGrant Contract

## Contract Name  
**OneTimeGrant**

## Overview  
**OneTimeGrant** is a minimalist smart contract that allows any address to claim the contract's balance as a one-time grant. The first caller to `claimGrant()` receives the entire balance held by the contract, and no further claims are allowed. This contract is useful for decentralized bounties, one-off payments, or grant distributions with no admin control. Importantly, **it does not use a constructor** — the behavior is purely functional and post-deployment controlled.

*It is designed to be deployed and tested in the **QRemix IDE** using the JavaScript VM or a testnet like Quranium testnet, Sepolia, etc.*

---

## Prerequisites

To deploy and test the contract, you need:

- **MetaMask or QSafe**: Browser extension for testnet deployments (optional).  
- **Test ETH or QRN**: Required for testnet deployments (e.g., from a Sepolia faucet like [sepoliafaucet.com](https://sepoliafaucet.com), [Quranium Faucet](https://faucet.quranium.org)).  
- **QRemix IDE**: Access at [qremix.org](https://qremix.org).  
- **Basic Solidity Knowledge**: Understanding of value transfers, receive functions, and one-time triggers.

---

## Contract Details

### State Variables

- **recipient**: `address`  
  - The address that successfully claimed the grant.  

- **claimed**: `bool`  
  - Indicates whether the grant has been claimed or not.

---

### Main Functions

#### Constructor

- **Purpose**: None – this contract does **not** use a constructor.  
- **Initialization**: State is initialized implicitly.

---

#### Public Functions

##### claimGrant
- **Function**: `claimGrant()`  
- **Purpose**: Allows the first address to claim the full balance as a grant.  
- **Parameters**: None  
- **Returns**: None  
- **Access**: Public  
- **Requirements**:
  - Grant must not have been claimed yet  
  - Contract must hold a positive balance  
- **Behavior**:
  - Transfers all ETH to the caller
  - Sets `recipient` to caller
  - Sets `claimed = true`
  - Emits `GrantClaimed` event

##### getBalance
- **Function**: `getBalance()`  
- **Purpose**: Returns the current ETH balance of the contract.  
- **Parameters**: None  
- **Returns**: `uint256` – contract balance in wei  
- **Access**: Public view

---

#### Special Functions

##### receive
- **Function**: `receive() external payable`  
- **Purpose**: Accepts ETH sent directly to the contract.  
- **Parameters**: None  
- **Access**: Anyone can fund the contract  
- **Behavior**:
  - Accepts ETH and logs the transaction
  - Emits `Funded` event

---

### Events

- **GrantClaimed**: `event GrantClaimed(address indexed recipient, uint256 amount)`  
  - **Purpose**: Emitted when the grant is successfully claimed.  
  - **Parameters**:
    - `recipient`: The address that claimed the funds
    - `amount`: The total ETH transferred

- **Funded**: `event Funded(address indexed sender, uint256 amount)`  
  - **Purpose**: Emitted when ETH is sent to the contract.  
  - **Parameters**:
    - `sender`: Address that sent ETH
    - `amount`: ETH amount received

---
