# ClaimableOwner Contract

## Contract Name  
**ClaimableOwner**

## Overview  
**ClaimableOwner** is a minimal and unique smart contract that allows ownership to be claimed *post-deployment* by the first user who interacts with it via the `claimOwnership()` function. This contract demonstrates secure access control without using a constructor. It is useful in proxy setups, factory deployments, or delayed-ownership scenarios. It supports receiving and withdrawing Ether, and emits events for transparency.

*It is designed to be deployed and tested in the **QRemix IDE** using the JavaScript VM or a testnet like Quranium testnet, Sepolia, etc.*

---

## Prerequisites  

To deploy and test the contract, you need:

- **MetaMask or QSafe**: Browser extension for testnet deployments (optional).  
- **Test ETH or QRN**: Required for testnet deployments (e.g., from a Sepolia faucet like [sepoliafaucet.com](https://sepoliafaucet.com), [Quranium Faucet](https://faucet.quranium.org)).  
- **QRemix IDE**: Access at [qremix.org](https://qremix.org).  
- **Basic Solidity Knowledge**: Understanding of contract ownership, receive functions, and deployment through QRemix.

---

## Contract Details

### State Variables

- **owner**: `address`  
  - Stores the address of the current contract owner (once claimed).  

- **isClaimed**: `bool`  
  - Tracks whether ownership has already been claimed.

---

### Main Functions

#### Constructor

- **Purpose**: None – this contract does **not** use a constructor.  
- **Initialization**: `owner` is unset on deployment. Ownership must be claimed explicitly via a function.

---

#### Public Functions

##### claimOwnership
- **Function**: `claimOwnership()`  
- **Purpose**: Allows the first caller to claim ownership of the contract.  
- **Parameters**: None  
- **Returns**: None  
- **Access**: Public  
- **Requirements**:
  - Can only be called once (if `isClaimed == false`)  
- **Behavior**:
  - Sets `msg.sender` as the owner.
  - Sets `isClaimed = true`.
  - Emits `OwnershipClaimed` event.

##### withdraw
- **Function**: `withdraw()`  
- **Purpose**: Allows the owner to withdraw all Ether held by the contract.  
- **Parameters**: None  
- **Returns**: None  
- **Access**: Only owner  
- **Requirements**:
  - Caller must be owner  
  - Contract must hold a non-zero balance  
- **Behavior**:
  - Sends the entire balance to the owner.
  - Emits `Withdrawn` event.

##### getBalance
- **Function**: `getBalance()`  
- **Purpose**: Returns the current Ether balance held by the contract.  
- **Parameters**: None  
- **Returns**: `uint256` – current balance in wei  
- **Access**: Public view

---

#### Special Functions

##### receive
- **Function**: `receive() external payable`  
- **Purpose**: Allows the contract to accept incoming Ether.  
- **Parameters**: None  
- **Access**: Anyone can send Ether  
- **Behavior**:
  - Accepts ETH sent to the contract.
  - Emits `FundsReceived` event.

---

### Events

- **OwnershipClaimed**: `event OwnershipClaimed(address indexed claimer)`  
  - **Purpose**: Emitted when ownership is successfully claimed.  
  - **Parameters**:
    - `claimer`: Address that claimed ownership.

- **FundsReceived**: `event FundsReceived(address indexed from, uint256 amount)`  
  - **Purpose**: Emitted whenever ETH is sent to the contract.  
  - **Parameters**:
    - `from`: Sender's address
    - `amount`: Amount received

- **Withdrawn**: `event Withdrawn(address indexed to, uint256 amount)`  
  - **Purpose**: Emitted when the owner withdraws ETH.  
  - **Parameters**:
    - `to`: Address that received funds
    - `amount`: Amount withdrawn

---
