# Fixed Reward Staking Smart Contract

This is a simple staking smart contract that allows users to stake and earn a **fixed 5% reward** over a lock period of **5 days**. Early withdrawals incur a **30% penalty** on the rewards only (not on the principal).

---
## Prerequisites

To deploy and test the contract, you need:

- **MetaMask or QSafe**: Browser extension for testnet deployments (optional).
- **Test ETH or QRN**: Required for testnet deployments (e.g., from a Sepolia faucet like sepoliafaucet.com, Quranium faucet.quranium.org).
- **QRemix IDE**: Access at qremix.org.
- **Basic Solidity Knowledge**: Smart contract deployment, and Remix IDE.

---

## Contract Details 
### Features

- Stake to earn fixed rewards (5% over 5 days)
- Early withdrawal incurs a 30% penalty on **rewards only**
- View staked balance, reward amount, and remaining lock time
- Contract can receive to fund rewards via the `receive()` fallback

### 🚀 How It Works

#### 1. Stake Tokens

- Function: `stake() external payable`
- Requirement: `msg.value > 0`
- What Happens:
  - If user already staked before, accrued rewards till now are added to `_pendingRewards`.
  - New stake amount is added to user's total.
  - Timer is reset (timestamp updated to current block).

#### 2. Withdraw Stake + Rewards

- Function: `withdraw() external`
- Requirement: User must have a non-zero stake
- What Happens:
  - Total reward is calculated:
    - If withdrawn **before** 5 days → **30% penalty** on rewards.
    - If withdrawn **after** 5 days → full reward given.
  - Principal + net reward are transferred to the user.
  - User’s stake and reward state is reset.

#### 3. Reward Calculation

- Based on time staked since last action using:
  ```solidity
  (_stakedBalances[user] * BASE_REWARD_RATE * duration) / (LOCK_DURATION * 10000)
  ```



### Deployment and Testing in QRemix IDE

### Step 1: Setup

1. Open qremix.org
2. Copy and paste the respective contract codes

### Step 2: Compilation

1. Go to "Solidity Compiler" tab
2. Select compiler version 0.8.20 or higher
3. Compile `FixedRewardStaking.sol`.

### Step 3: Deployment

#### For Quranium Testnet:

1. Go to "Deploy & Run Transactions" tab
2. Select "Quranium" as environment
3. Ensure QSafe is connected to Quranium Testnet
4. Deploy `FixedRewardStaking.sol` contract.



### License

This project is licensed under the MIT License. See the `SPDX-License-Identifier: MIT` in the contract files. 

### Support

For issues or feature requests:

- Check the QRemix IDE documentation: [https://docs.qremix.org](https://docs.qremix.org/)
