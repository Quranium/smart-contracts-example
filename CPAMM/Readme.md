# CPAMM Contract

## Contract Name
CPAMM

## Overview
CPAMM (Constant Product Automated Market Maker) is a simple smart contract enabling decentralized token swaps based on the **x * y = k** invariant. It supports token swapping, liquidity provisioning, and LP share tracking. This contract mimics the behavior of Uniswap v2 in a minimal form.

*It is designed to be deployed and tested in the **QRemix IDE** using the JavaScript VM or testnets like Quranium, Sepolia, etc.*

## Prerequisites

To deploy and test the contract, you need:
* **MetaMask or QSafe**
* **QRemix IDE** – [https://qremix.org](https://qremix.org)
* **Test ETH/QRN** – From faucets https://faucet.quranium.org/
* **Two ERC20 tokens**

## Contract Details

### State Variables

- `token0`, `token1`: Address of the two ERC20 tokens
- `reserve0`, `reserve1`: Current reserves of each token
- `shares`: Mapping of user to LP shares
- `totalShares`: Total LP supply issued

### Main Functions

#### Constructor
- Initializes token0 and token1
- Ensures both token addresses are different

#### addLiquidity
- Adds liquidity in proportion to the pool
- Mints LP shares based on the liquidity provided

#### removeLiquidity
- Removes user’s LP shares
- Returns equivalent amounts of token0 and token1

#### swap
- Allows swapping between token0 and token1
- Maintains x * y = k invariant
- Deducts 0.3% fee from input amount

### Internal Utilities

- `_safeTransfer`, `_safeTransferFrom`: Raw ERC20 interaction
- `min`, `sqrt`: For LP share calculations

