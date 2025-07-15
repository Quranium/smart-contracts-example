# BasicStaking Contract

## Contract Name
BasicStaking

## Overview
BasicStaking is a minimal staking smart contract where users stake an ERC20 token to earn reward tokens at a linear rate. Rewards are distributed per second and can be claimed anytime.

*Deploy and interact through **QRemix IDE** or testnets like Quranium, Sepolia, etc.*

## Prerequisites

To test this contract:
* ERC20 staking token and reward token
* QRemix IDE access ([qremix.org](https://qremix.org))
* Wallet (QSafe) and testnet ETH

## Contract Details

### State Variables

- `stakingToken`: Token to be staked
- `rewardToken`: Token distributed as reward
- `rewardRate`: Tokens emitted per second per staked token
- `userBalance`: Mapping of user staked tokens
- `userRewardDebt`: Tracks user rewards claimed
- `rewardPerTokenStored`: Global reward snapshot
- `lastUpdate`: Last time rewards were calculated

### Main Functions

#### stake
- Transfers `stakingToken` from user to contract
- Updates internal reward accounting

#### withdraw
- Returns staked tokens
- Updates reward snapshot

#### claim
- Sends accumulated reward tokens to user

#### earned
- View function to show claimable rewards for user

### Internal Logic

- `updateRewards()`: Updates rewardPerTokenStored
- `_safeTransfer`, `_safeTransferFrom`: Safe ERC20 interaction
