# CSAMM Contract

## Contract Name
CSAMM

## Overview
CSAMM (Constant Sum AMM) is a decentralized automated market maker based on the **x + y = k** invariant. It is designed for stable pairs with 1:1 ratios, providing **zero slippage** until liquidity drains. Includes swap, add/remove liquidity, and LP shares functionality.

*Deployable via **QRemix IDE**, supporting testnets like Quranium or Sepolia.*

## Prerequisites

To deploy and test the contract, you need:
* MetaMask or QSafe
* QRemix IDE: [qremix.org](https://qremix.org)
* Two ERC20 tokens
* Basic testnet ETH/QRN: https://faucet.quranium.org/

## Contract Details

### State Variables

- `token0`, `token1`: ERC20 token pair
- `reserve0`, `reserve1`: Balances held by pool
- `shares`: Mapping of address to LP shares
- `totalShares`: Total LP supply

### Main Functions

#### addLiquidity
- Accepts tokens in 1:1 ratio
- Mints LP shares accordingly

#### removeLiquidity
- Returns tokens proportional to user's LP share

#### swap
- Swaps token0 <-> token1
- Uses constant sum logic with 0.3% fee
- Reverts if output exceeds reserve

### Internal Functions

- `_safeTransfer`, `_safeTransferFrom`: Low-level ERC20 methods
