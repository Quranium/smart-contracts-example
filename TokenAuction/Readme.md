# TokenAuction Contract

## Contract Name
TokenAuction

## Overview
TokenAuction enables a **sealed-bid auction** where users bid ETH to purchase a fixed amount of ERC20 tokens. After the auction ends, the highest bidder receives the tokens, and non-winners can withdraw their ETH.

*Designed for IDO-style launches or limited token sales. Testable in QRemix or Quranium Testnet.*

## Prerequisites

To use:
* ERC20 token
* ETH for bidding
* QRemix IDE or testnet setup

## Contract Details

### State Variables

- `token`: Token to be sold
- `tokensForSale`: Total amount being auctioned
- `seller`: Owner of the auction
- `highestBidder`, `highestBid`: Tracks top bid
- `bids`: Mapping of address to ETH bid
- `endTime`: Auction deadline
- `tokensClaimed`, `ethClaimed`: Claim flags

### Main Functions

#### depositTokens
- Seller deposits tokens to be auctioned

#### bid
- Users place or increase bids using ETH

#### claimTokens
- Winner claims ERC20 tokens post-auction

#### claimETH
- Seller claims highest ETH bid

#### refund
- Non-winners withdraw their ETH

### Internal Utilities

- `_safeTransfer`, `_safeTransferFrom`: Token interactions
