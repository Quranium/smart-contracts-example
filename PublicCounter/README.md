# PublicCounter Contract

## Contract Name  
**PublicCounter**

## Overview  
**PublicCounter** is a fully permissionless smart contract that allows any address to interact once — either to increment a shared counter or reset it to zero. Each address can only interact one time. This enforces fair participation in a decentralized way without requiring any admin or constructor logic. The contract is constructor-free and suitable for decentralized coordination, public engagement tools, and zero-trust systems.

*It is designed to be deployed and tested in the **QRemix IDE** using the JavaScript VM or a testnet like Quranium testnet, Sepolia, etc.*

---

## Prerequisites

To deploy and test the contract, you need:

- **MetaMask or QSafe**: Browser extension for testnet deployments (optional).  
- **Test ETH or QRN**: Required for testnet deployments (e.g., from a Sepolia faucet like [sepoliafaucet.com](https://sepoliafaucet.com), [Quranium Faucet](https://faucet.quranium.org)).  
- **QRemix IDE**: Access at [qremix.org](https://qremix.org).  
- **Basic Solidity Knowledge**: Understanding of public state, mappings, and smart contract design without constructors.

---

## Contract Details

### State Variables

- **counter**: `uint256`  
  - Tracks the shared public counter value.  

- **hasInteracted**: `mapping(address => bool)`  
  - Tracks whether an address has already used their one interaction (either increment or reset).

---

### Main Functions

#### Constructor

- **Purpose**: None – this contract does **not** use a constructor.  
- **Initialization**: Counter starts at `0`, all addresses marked as unused.

---

#### Public Functions

##### increment
- **Function**: `increment()`  
- **Purpose**: Allows any address to increment the shared counter **once**.  
- **Parameters**: None  
- **Returns**: None  
- **Access**: Public  
- **Requirements**:
  - Caller must not have interacted before  
- **Behavior**:
  - Increases counter by 1  
  - Marks caller as interacted  
  - Emits `Incremented` event

##### resetCounter
- **Function**: `resetCounter()`  
- **Purpose**: Allows any address to reset the shared counter to `0` **once**.  
- **Parameters**: None  
- **Returns**: None  
- **Access**: Public  
- **Requirements**:
  - Caller must not have interacted before  
- **Behavior**:
  - Sets counter to 0  
  - Marks caller as interacted  
  - Emits `Reset` event

##### getCounter
- **Function**: `getCounter()`  
- **Purpose**: Returns the current counter value.  
- **Parameters**: None  
- **Returns**: `uint256` – current counter value  
- **Access**: Public view

##### hasUsed
- **Function**: `hasUsed(address user)`  
- **Purpose**: Checks if an address has already used its one interaction.  
- **Parameters**: `address user` – address to check  
- **Returns**: `bool` – true if already interacted  
- **Access**: Public view

---

### Events

- **Incremented**: `event Incremented(address indexed user, uint256 newValue)`  
  - **Purpose**: Emitted when a user successfully increments the counter.  
  - **Parameters**:
    - `user`: The address that incremented
    - `newValue`: The updated counter value

- **Reset**: `event Reset(address indexed user)`  
  - **Purpose**: Emitted when a user resets the counter to zero.  
  - **Parameters**:
    - `user`: The address that performed the reset

---
