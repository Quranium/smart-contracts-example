#  SimpleLottery Smart Contract

The `SimpleLottery` contract is a decentralized lottery system. Participants can enter the lottery by paying a fixed ticket price. Once enough players have entered, the manager can draw a winner and distribute the entire pot.

---

##  Contract Features

- Anyone can join the lottery by paying the exact `ticketPrice`.
- Requires a minimum of 3 participants to draw a winner.
- Uses a future block hash to simulate randomness.
- Resets automatically after each draw for repeated use.
- Only the `manager` can trigger winner selection and draw completion.

---

##  Contract Functions Explained

###  `constructor(uint256 _ticketPrice)`
- Initializes the contract with the deployer as the `manager`.
- Sets the `ticketPrice` in wei.
- Starts the lottery as active (`isActive = true`).

---

###  `enterLottery() public payable`
- Allows users to join the lottery by sending the exact `ticketPrice`.
- Appends the sender to the `participants` array.
- Reverts if the lottery is not active or the sent amount is incorrect.

---

###  `drawWinner() public onlyManager`
- Callable only by the `manager`.
- Requires at least 3 participants.
- Sets a future block number (`drawBlock = block.number + 5`) for randomness.
- Marks the lottery as inactive to prevent further entries.

---

###  `completeDraw() public onlyManager`
- Callable only after the `drawBlock` has passed.
- Uses pseudo-random seed based on `blockhash(drawBlock)` and `block.timestamp`.
- Selects a winner and transfers the full contract balance.
- Resets the lottery: clears participants and sets `isActive = true`.

>  Must be called soon after `drawBlock`, or `blockhash()` will return zero.

---

### `getParticipantsCount() public view returns (uint)`
- Returns the number of participants in the current round.

---

###  `getContractBalance() public view returns (uint)`
- Returns the total balance currently held in the contract.

---

## 🛠 Prerequisites

To deploy and test the contracts, you need:

- **MetaMask or QSafe**: Browser extension for testnet deployments.
- **Test ETH or QRN**: Required for testnet deployments (e.g., from a Sepolia faucet like [sepoliafaucet.com](https://sepoliafaucet.com/), Quranium [faucet.quranium.org](https://faucet.quranium.org/) ).
- **QRemix IDE**: Access at [qremix.org](https://www.qremix.org/)
- **Basic Solidity Knowledge**: Smart contract deployment, and Remix IDE.

---

## Deployment and Testing in QRemix IDE

### Step 1: Setup

1. Open [https://www.qremix.org](https://www.qremix.org)
2. Copy and paste the `SimpleLottery.sol` contract code

---

### Step 2: Compilation

1. Go to the "Solidity Compiler" tab.
2. Select compiler version **0.8.20** or higher.
3. Compile the `SimpleLottery.sol` file.

---

### Step 3: Deployment

#### For Quranium Testnet:

1. Go to the "Deploy & Run Transactions" tab.
2. Select **"Quranium"** as the environment.
3. Ensure **QSafe** is connected to the Quranium Testnet.
4. Deploy the `SimpleLottery` contract with the `ticketPrice` (in **wei**) as constructor input.  
   _Example: `10000000000000000` for 0.01 QRN_

---

##  License

This project is licensed under the **MIT License**.  
See the `SPDX-License-Identifier: MIT` in the contract files.

---

##  Support

For issues or feature requests:

- Check the QRemix IDE documentation:  
  [https://docs.qremix.org](https://docs.qremix.org/)
