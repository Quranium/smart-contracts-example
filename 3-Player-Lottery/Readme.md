# SimpleLottery Contract

## Contract Name  
SimpleLottery

## Overview  
SimpleLottery is a minimal, chain-agnostic smart contract that implements a trustless lottery game among exactly three participants. Each participant deposits a fixed entry fee (0.01 ether equivalent) into the contract. When all three participants have entered, the contract uses on-chain block data to select a winner pseudo-randomly and automatically transfers the full prize pool (0.03 ether equivalent) to the winner.

The contract includes an owner-set timeout mechanism to refund participants if the lottery does not fill within a certain block period, ensuring funds are never locked indefinitely.

## Prerequisites  
To deploy and test the SimpleLottery contract, you will need:  
* **Ethereum-compatible wallet**: MetaMask, Q-Safe (for Quranium), or any wallet configured for the target chain.  
* **Test tokens (native coin of the chain)**: e.g., Sepolia ETH on Sepolia testnet, QRN on Quranium testnet, etc. These are required for gas fees and deposits.  
* **Q-Remix**: To compile, deploy, and interact.  
* **Basic Solidity knowledge**: Familiarity with contract deployment, interaction, and functions.

## Contract Details

### State Variables  
- **players**: `address payable` — stores the three unique participants.[3]
- **playerCount**: `uint` — counts the currently joined players (max 3).  
- **ENTRY_FEE**: `uint constant` — fixed entry fee, set to 0.01 ether (chain native).  
- **winnerSelected**: `bool` — true when a winner has been picked.  
- **winner**: `address` — winner’s address.  
- **owner**: `address` — deployer of the contract, who can issue refunds on timeout.  
- **timeoutBlock**: `uint` — block number after which refund is allowed if lottery incomplete.

### Main Functions

#### Constructor  
- **Purpose**: Sets the contract owner and configures the timeout block for refunds.  
- **Parameters**:  
  - `_timeoutBlock` (uint): block number after which refunds can be issued if lottery not complete.  

#### enter  
- **Purpose**: Allows a unique participant to join by sending exactly 0.01 ether.  
- **Requirements**:  
  - Game not finished.  
  - Less than 3 players currently.  
  - Caller not already entered.  
  - Sent value matches `ENTRY_FEE`.  
- **Behavior**:  
  - Adds caller to players.  
  - Emits `PlayerJoined` event.  
  - Automatically picks winner and pays out when 3 players join.

#### _pickWinner (internal)  
- **Purpose**: Randomly selects one of the three players as winner using blockhash entropy.  
- **Behavior**:  
  - Sets `winner`.  
  - Emits `WinnerSelected` event.  
  - Calls payout function.

#### _payout (internal)  
- **Purpose**: Transfers the entire contract balance to the winner.

#### refund  
- **Access**: Only owner.  
- **Purpose**: Refunds all participants if the lottery didn't complete and timeout reached.  
- **Requirements**:  
  - Lottery not finished.  
  - Current block number >= `timeoutBlock`.  
- **Behavior:**  
  - Sends deposits back to players.  
  - Resets player count.  
  - Emits `RefundIssued` event.

### Events  
- **PlayerJoined(address indexed player)** — emitted when a player joins the lottery.  
- **WinnerSelected(address indexed winner)** — emitted when a winner is picked.  
- **RefundIssued()** — emitted when a refund is processed.

***

## Usage Flow  
1. Deploy contract on target EVM blockchain with a suitable timeout block.  
2. Participants call `enter()` sending exactly the entry fee native coin.  
3. After three participants join, winner is chosen and prize sent automatically.  
4. If lottery fails to fill before timeout, owner can call `refund()` to return deposits.

***

## Notes  
- Randomness uses blockhash and is not secure against manipulations; for production, integrate Chainlink VRF or secure randomness oracles.  
- ENTRY_FEE and timeoutBlock can be modified or parameterized to suit different chains or use-cases.  


