# LastOneStanding

## Contract Name
**LastOneStanding**

---

## Overview
**LastOneStanding** is a unique, gamified smart contract that rewards the **last person to join** — if no one else enters within a given interval. Each new entry restarts the countdown. If the timer expires, the last participant wins the entire pot.

It’s a fair game of timing, patience, and nerve — on-chain.

---

## Prerequisites

- MetaMask or QSafe (for testnet deployment)
- Testnet ETH or QRN
- Access to [QRemix IDE](https://qremix.org)
- Basic understanding of Solidity and timing logic

---

## Contract Functions

### `constructor(uint256 _intervalInSeconds, uint256 _entryFeeInWei)`
- **Purpose**: Initializes game duration and entry cost
- **Inputs**:
  - `_intervalInSeconds`: Time window for each new entry
  - `_entryFeeInWei`: Amount of ETH required to participate

---

### `enter()`
- **Purpose**: Joins the game and resets the countdown
- **Conditions**:
  - Must send exact entry fee
  - Game must not have ended
- **Emits**: `NewEntry(address player, uint256 timestamp)`

---

### `checkWinner()`
- **Purpose**: Ends the game if the timer expired; rewards the last player
- **Conditions**:
  - Called after interval passes
  - Transfers full contract balance to `lastPlayer`
- **Emits**: `GameEnded(address winner, uint256 reward)`

---

### `getTimeLeft()`
- **Purpose**: Returns seconds left before timeout
- **Returns**: Remaining seconds

---

## Access Control

- No admin. It’s **fully decentralized**
- Anyone can call `checkWinner()` once the interval passes

---

## Deployment & Testing on QRemix

### 🔹 Step 1: Setup
- Open [qremix.org](https://qremix.org)
- Create folder: `LastOneStanding/`
- Add `LastOneStanding.sol` and paste the contract code

### 🔹 Step 2: Compile
- Go to **Solidity Compiler**
- Select version **0.8.0** or later
- Compile the contract

### 🔹 Step 3: Deploy

#### Quranium Testnet
- Use **Injected Provider - MetaMask**
- Deploy with:
  - Interval in seconds (e.g. `120` for 2 minutes)
  - Entry fee in wei (e.g. `10000000000000000` for 0.01 ETH)
  - Optional ETH funding if needed for prize

#### JavaScript VM
- Deploy and test using multiple accounts

### 🔹 Step 4: Testing

#### Flow:
1. Alice calls `enter()` with entry fee
2. Bob joins within interval — timer resets
3. No one else enters — time expires
4. Anyone calls `checkWinner()` — Bob gets the pot

---

## Events

- `NewEntry(address indexed player, uint256 timestamp)` – emitted on every valid entry
- `GameEnded(address indexed winner, uint256 reward)` – emitted when the winner is paid

---

## License
This project is licensed under the **MIT License**.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

## Support
For issues or feature requests, refer to:

[QRemix IDE Documentation](https://docs.qremix.org)
