# 🎟️ SimpleLottery Smart Contract

The `SimpleLottery` contract is a decentralized lottery system built on Ethereum. Participants can enter the lottery by paying a fixed ticket price in ETH. Once enough players have entered, the manager can draw a winner and distribute the entire pot.

---

## 📜 Features

- ✅ Anyone can join the lottery by paying the exact `ticketPrice`.
- 🎯 Requires a minimum of 3 participants to draw a winner.
- 🧠 Uses a future block hash to simulate randomness.
- 🔁 Resets automatically after each draw for repeated use.
- 🔒 Only the `manager` can trigger winner selection and draw completion.

---

## Deployment and Testing in QRemix IDE

### Step 1: Setup

1. Open qremix.org
2. Copy and paste the respective contract codes

### Step 2: Compilation

1. Go to "Solidity Compiler" tab
2. Select compiler version 0.8.20 or higher
3. Compile `SimpleWallet.sol` first.

### Step 3: Deployment

#### For Quranium Testnet:

1. Go to "Deploy & Run Transactions" tab
2. Select "Injected Provider - MetaMask" as environment
3. Ensure MetaMask/QSafe is connected to Quranium Testnet
4. Deploy `SimpleWallet` contract with ticketPrice in Wei.
