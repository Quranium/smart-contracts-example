# TimeForge

#### Smart Contract: Proof-of-Time Commitment NFT

---

## Overview

**TimeForge** is a gamified smart contract system that rewards users with a unique NFT for successfully completing a time-based challenge. Participants must check in daily over a set number of days. If completed without missing a check-in, the user receives a non-transferable NFT as proof of dedication.

Ideal for:
- Fitness or wellness challenges (e.g., 30-day yoga)
- Learning milestones (e.g., daily coding)
- Habit tracking (e.g., meditation, journaling)
- DAO work consistency rewards

> Fully compatible with **OpenZeppelin** libraries and deployable via **QRemix IDE**, JavaScript VM, or testnets like **Quranium** or **Sepolia**.

---

## Prerequisites

To deploy and test the contract, you’ll need:

- **MetaMask or QSafe**: Wallet extension for testnet deployment  
- **Test ETH or QRN**: Get from [sepoliafaucet.com](https://sepoliafaucet.com) or [faucet.quranium.org](https://faucet.quranium.org)  
- **QRemix IDE**: Visit [qremix.org](https://qremix.org)  
- **Solidity Knowledge**: Understanding of smart contracts and NFT standards

---

## Contract Details

###  Structs

#### `Challenge`
- `user`: Participant address  
- `startTime`: Timestamp when challenge started  
- `durationDays`: Total days required  
- `lastCheckIn`: Timestamp of last check-in  
- `checkIns`: Number of completed check-ins  
- `completed`: True if challenge was successful  
- `failed`: True if challenge failed  

---

###  Functions

#### `startChallenge(uint256 durationDays)`
- **Purpose**: Begins a new challenge for the sender  
- **Parameters**:
  - `durationDays`: Total number of days to complete  
- **Access**: Anyone (one challenge per address)  

#### `checkIn()`
- **Purpose**: Perform a daily check-in  
- **Rules**:
  - Must be at least 23 hours after previous check-in  
  - Automatically completes challenge after final check-in  

#### `failChallenge()`
- **Purpose**: Allows user or external app to mark challenge as failed  
- **Rules**: Can be failed if >48 hours since last check-in  

#### `getChallengeStatus(address user)`
- **Returns**: "In Progress", "Completed", or "Failed"

---

### 🖼 NFT Reward

- Minted using `_safeMint()` when challenge is completed  
- Uses `_setTokenURI()` for attaching metadata  
- NFT serves as verifiable, non-transferable proof of consistency  

---

## Deployment and Testing in QRemix IDE

###  Step 1: Setup
1. Visit [qremix.org](https://qremix.org)
2. Create folder: `TimeForge/`
3. Create file: `TimeForge.sol`
4. Paste the smart contract code

###  Step 2: Compilation
1. Go to **Solidity Compiler**
2. Select version `^0.8.20` or above
3. Compile `TimeForge.sol`

###  Step 3: Deployment

#### JavaScript VM (Local Testing)
1. Go to **Deploy & Run Transactions**
2. Select environment: `JavaScript VM`
3. Deploy the `TimeForge` contract

#### Quranium or Sepolia Testnet
1. Select environment: `Injected Provider - MetaMask`
2. Ensure MetaMask is connected to the correct testnet
3. Deploy the contract

---

## Testing Instructions

###  Start and Complete a Challenge
1. Call `startChallenge` with e.g. `7` for 7 days
2. Call `checkIn()` once per day (every 23+ hrs)
3. After final check-in, NFT is automatically minted

###  Challenge Status
1. Use `getChallengeStatus(address)` to monitor state  
2. Returns:
   - `"In Progress"` during challenge
   - `"Completed"` after all check-ins
   - `"Failed"` if check-ins missed

###  Failure Conditions
1. Call `failChallenge()` if >48 hrs passed since last check-in  
2. `checkIn()` or reward is blocked if challenge fails

---

## License

This project is licensed under the MIT License.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

## Support

For questions, feedback, or bug reports:
- Visit the [QRemix IDE Documentation](https://docs.qremix.org)
- Refer to [OpenZeppelin Docs](https://docs.openzeppelin.com/contracts)

