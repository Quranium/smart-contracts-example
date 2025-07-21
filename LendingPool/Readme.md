# SimpleLendingPool Contract

## Contract Name
SimpleLendingPool

## Overview
SimpleLendingPool is a basic lending protocol allowing users to deposit **ETH as collateral** and borrow a fixed ERC20 token. Borrowing is limited by a fixed **collateral ratio** (e.g., 150%).

*Ideal for educational use, testable in QRemix IDE or Quranium/Sepolia testnet.*

## Prerequisites

To test:
* ERC20 token (borrowable)
* ETH as collateral
* QRemix IDE access and testnet ETH

## Contract Details

### State Variables

- `token`: ERC20 token being borrowed
- `collateralRatio`: e.g., 150 for 150%
- `collateralETH`: Mapping of user to ETH provided
- `debt`: Mapping of user to borrowed amount

### Main Functions

#### depositCollateral
- Accepts ETH as collateral
- Adds to `collateralETH` mapping

#### borrow
- Borrows `token` based on ETH collateral
- Requires sufficient overcollateralization

#### repay
- Repays `token` debt
- Updates internal `debt` tracking

#### withdrawCollateral
- Withdraws ETH if user's health factor is valid

### Internal Methods

- `_safeTransfer`, `_safeTransferFrom`: ERC20 calls
