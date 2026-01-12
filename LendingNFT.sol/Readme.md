
# NFTRental

## Contract Name

**NFTRental**

---

## Overview

The `NFTRental` contract is a decentralized **NFT rental marketplace** that allows **NFT owners** to list their ERC-721 tokens for rent and enables **renters** to borrow them for a specific duration **without transferring ownership**.

It securely handles:
- **NFT custody**
- **Rental payments**
- **Automatic returns** after expiration
- **Event tracking** for all actions

This project is fully compatible with **QRemix IDE** and can be deployed seamlessly.

---

## Features

- List ERC-721 NFTs for rent
- Rent NFTs for a defined period
- Automatic NFT return after rental expiry
- Secure handling of funds
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
function listNFT(address _nft, uint256 _tokenId, uint256 _price) external
```

- **Purpose**: List ERC721 NFTs for rent.
- **Arguments**:
    - `_nft`: ERC721 contract address
    - `_tokenId`: NFT token ID
    - `_price`: Rental price in wei
- **Emits**: `NFTListed(rentalId, owner, nft, tokenId, price)`
- **Requires**:
    - Owner must approve the contract for NFT transfers.

---

### 2. rentNFT

```solidity
function rentNFT(uint256 _rentalId, uint256 _duration) external payable
```

- **Purpose**: Rent an NFT for a fixed duration.
- **Arguments**:
    - `_rentalId`: ID of the rental listing
    - `_duration`: Duration in seconds
- **Emits**: `NFTRented(rentalId, renter, expiresAt)`
- **Requires**:
    - NFT must not be rented already.
    - `msg.value` must equal the rental price.

---

### 3. returnNFT

```solidity
function returnNFT(uint256 _rentalId) external
```

- **Purpose**: Return rented NFTs to owners.
- **Arguments**:
    - `_rentalId`: Rental listing ID
- **Emits**: `NFTReturned(rentalId)`
- **Requires**:
    - NFT must be rented.
    - Rental period must have expired.

---

### 4. withdrawEarnings

```solidity
function withdrawEarnings() external
```

- **Purpose**: NFT owners withdraw rental earnings.
- **Access**: Only owners.

---

## Events

| Event            | Description                                |
|------------------|----------------------------------------|
| NFTListed        | Emitted when an NFT is listed          |
| NFTRented        | Emitted when an NFT is rented          |
| NFTReturned      | Emitted when an NFT is returned        |

---

## Error Handling

- Reverts if:
    - NFT is already rented
    - Insufficient payment sent
    - Rental period has not expired
    - Unauthorized actions attempted

---

## Security Considerations

- Uses **ReentrancyGuard** for fund transfers.
- Ensures **owner-only listing rights**.
- Prevents renters from **transferring NFTs**.
- Protects against expired rentals.

---

## Deployment Guide (QRemix)

### Step 1: Setup
- Open [https://qremix.org](https://qremix.org)
- Create a folder: `NFTRental/`
- Add `NFTRental.sol` and paste the contract.

### Step 2: Compile
- Select compiler `0.8.20+`
- Click **Compile**.

### Step 3: Deploy
- Go to **Deploy & Run Transactions**
- Select **Injected Provider** (MetaMask/QSafe)
- Connect to **Quranium Testnet**
- Deploy the contract.

---

## Testing Guide

### 1. Listing an NFT
```solidity
listNFT(_nftAddress, _tokenId, _price)
```

### 2. Renting an NFT
```solidity
rentNFT(_rentalId, _duration) // send required ETH
```

### 3. Returning an NFT
```solidity
returnNFT(_rentalId)
```

### 4. Withdrawing Earnings
```solidity
withdrawEarnings()
```

---

## Gas Optimization Tips

- Use **memory** over **storage** where possible.
- Use **unchecked** math for safe operations.
- Minimize event emissions.

---

## Future Improvements

- ERC-1155 support
- Dynamic pricing system
- NFT rental auctions
- Integrated off-chain metadata

---

## License

MIT License © 2025 Quranium Labs

--