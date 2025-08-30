# DynamicRoyalty

## Contract Name

**RoyaltyMarketplace**

---

## Overview

The `RoyaltyMarketplace` contract is a decentralized **NFT marketplace** that enables **collaborative sales** with **dynamic royalty distribution**. It allows NFT owners to list their ERC-721 tokens for sale while automatically distributing proceeds among multiple collaborators based on predefined shares.

It securely handles:
- **NFT listings** with collaborative ownership
- **Dynamic royalty distribution** among collaborators
- **Automatic payment splitting** based on shares
- **Event tracking** for all marketplace activities

This project is fully compatible with **QRemix IDE** and can be deployed seamlessly.

---

## Features

- List ERC-721 NFTs for collaborative sale
- Define multiple collaborators with custom share percentages
- Automatic royalty distribution upon purchase
- Secure handling of funds and NFT transfers
- Fully tested on **Quranium Testnet**
- Easily integrable with **QRemix**

---

## Prerequisites

- **MetaMask or QSafe** wallet
- **Testnet ETH or QRN**
- **QRemix IDE** ([https://qremix.org](https://qremix.org))
- Basic understanding of **Solidity** & **ERC721**

---

## Contract Functions

### 1. listNFT

```solidity
function listNFT(address _nft, uint256 _tokenId, uint256 _price, address[] memory _collaborators, uint256[] memory _shares) external
```

- **Purpose**: List ERC721 NFTs for collaborative sale with royalty distribution.
- **Arguments**:
    - `_nft`: ERC721 contract address
    - `_tokenId`: NFT token ID
    - `_price`: Sale price in wei
    - `_collaborators`: Array of collaborator addresses
    - `_shares`: Array of share amounts for each collaborator
- **Emits**: `Listed(id, seller, price)`
- **Requires**:
    - Collaborators and shares arrays must have equal length
    - Owner must approve the contract for NFT transfers

---

### 2. buyNFT

```solidity
function buyNFT(uint256 _id) external payable
```

- **Purpose**: Purchase an NFT and automatically distribute royalties to collaborators.
- **Arguments**:
    - `_id`: Listing ID to purchase
- **Emits**: `Purchased(id, buyer)`
- **Requires**:
    - `msg.value` must equal the exact listing price
    - NFT must be available for purchase

---

## Events

| Event            | Description                                |
|------------------|----------------------------------------|
| Listed           | Emitted when an NFT is listed for sale    |
| Purchased        | Emitted when an NFT is purchased          |

---

## Error Handling

- Reverts if:
    - Collaborators and shares arrays length mismatch
    - Incorrect payment amount sent
    - NFT transfer fails
    - Invalid listing ID provided

---

## Security Considerations

- **Automatic royalty distribution** prevents manual intervention
- **Proportional share calculation** ensures fair distribution
- **Direct NFT transfer** from seller to buyer
- **Immutable listing data** once created

---

## Deployment Guide (QRemix)

### Step 1: Setup
- Open [https://qremix.org](https://qremix.org)
- Create a folder: `DynamicRoyalty/`
- Add `DynamicRoyalty.sol` and paste the contract

### Step 2: Compile
- Select compiler `0.8.0+`
- Click **Compile**

### Step 3: Deploy
- Go to **Deploy & Run Transactions**
- Select **Injected Provider** (MetaMask/QSafe)
- Connect to **Quranium Testnet**
- Deploy the contract

---

## Testing Guide

### 1. Listing an NFT with Collaborators
```solidity
listNFT(_nftAddress, _tokenId, _price, [_collaborator1, _collaborator2], [_share1, _share2])
```

### 2. Purchasing an NFT
```solidity
buyNFT(_listingId) // send exact price in ETH
```

### 3. Checking Listing Details
```solidity
listings(_listingId) // returns seller, nft, tokenId, price, collaborators, shares
```

---

## Gas Optimization Tips

- Use **memory** over **storage** for temporary arrays
- **Batch operations** where possible
- Minimize **loop iterations** in royalty distribution

---

## Future Improvements

- **ERC-1155 support** for batch NFTs
- **Auction functionality** with royalty distribution
- **Time-based listing expiration**
- **Advanced royalty calculation** algorithms

---

## License

MIT License © 2025 Quranium Labs

--
