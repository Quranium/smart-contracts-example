# PublicNFT

## Contract Name

**PublicNFT**

---

## Overview

The `PublicNFT` contract is an ERC-721 compliant non-fungible token (NFT) collection that allows users to mint NFTs by paying a fixed price. Each minted token receives a dynamically generated token URI pointing to metadata stored on IPFS. The contract uses OpenZeppelin's standard implementations for ERC721 functionality, URI storage, and ownership control.

Built with Solidity and OpenZeppelin libraries, this contract provides a simple way to create and distribute NFTs with predictable pricing and standardized metadata.

---

## Prerequisites

- **QSafe or MetaMask** (for testnet deployment)
- **Testnet ETH or QRN**
- **QRemix IDE** ([qremix.org](https://qremix.org))
- Basic understanding of Solidity and smart contract interaction

---

## Contract Details

### Token Information

- **Name:** PublicNFT
- **Symbol:** PNFT
- **Token Standard:** ERC-721
- **Base URI:** https://indigo-genetic-echidna-662.mypinata.cloud/ipfs/QmRFGb7Vd8QouEKvHtB9jZLwCt7EMSU47XTW1zB3PRqpjy/

### Pricing

- **Mint Price:** 0.001 ETH
- **Payment:** Required in native token

---

## Contract Functions

### constructor

```solidity
constructor()
```

- **Purpose:** Initializes the ERC-721 token with name "PublicNFT" and symbol "PNFT"
- **Access:** Called automatically during deployment
- **Initialization:** Sets token counter to 0

---

### purchaseNFT

```solidity
function purchaseNFT() external payable
```

- **Purpose:** Allows users to mint a new NFT by sending the required ETH
- **Payment:** Requires exactly 0.001 ETH (or more)
- **Functionality:**
  - Mints a new token with ID equal to current tokenCounter
  - Generates token URI in format: `baseURI + tokenId + ".jpeg"`
  - Assigns the token to the message sender
  - Increments token counter for next mint
- **Reverts:** If insufficient ETH is sent

---

### Getters

#### price

```solidity
uint256 public price
```

Returns the current mint price (0.001)

#### tokenCounter

```solidity
uint256 public tokenCounter
```

Returns the current token count (total minted tokens)

#### baseURI

```solidity
string public constant baseURI
```

Returns the base IPFS URI for token metadata

---

## Access Control

- **Owner:** The contract deployer has special privileges (inherited from Ownable)
- **Public:** Anyone can call `purchaseNFT()` with the required payment

---

## Deployment & Testing

### Step 1: Setup

- Open [qremix.org](https://qremix.org)
- Create a new file: `PublicNFT.sol`
- Paste the contract code

### Step 2: Compile

- Go to the **Solidity Compiler** tab
- Select compiler version `0.8.28`
- Click **Compile PublicNFT.sol**

### Step 4: Deploy

#### Quranium Testnet

- Go to **Deploy & Run Transactions**
- Select **Injected Provider - MetaMask or QSafe**
- Connect to **Quranium Testnet**
- Click **Deploy**

#### JavaScript VM

- Choose **JavaScript VM** (for local testing)
- Set constructor argument
- Click **Deploy**

---

## Testing

### Purchase an NFT

1. Set the **Value** field to 0.001 ETH (1000000000000000 wei)
2. Call the `purchaseNFT()` function
3. The transaction will mint a new NFT to your address

### Verify NFT Ownership

- Check your wallet's NFT collection
- The token URI will follow the pattern: `https://indigo-genetic-echidna-662.mypinata.cloud/ipfs/QmRFGb7Vd8QouEKvHtB9jZLwCt7EMSU47XTW1zB3PRqpjy/0.jpeg` (for token ID 0)

### Insufficient Payment Test

1. Set **Value** to less than 0.001 ETH
2. Call `purchaseNFT()` - transaction will revert with "Insufficient ETH sent"

---

## Token URI Structure

Each token's metadata is accessible at:

```
https://indigo-genetic-echidna-662.mypinata.cloud/ipfs/QmRFGb7Vd8QouEKvHtB9jZLwCt7EMSU47XTW1zB3PRqpjy/{tokenId}.jpeg
```

Replace `{tokenId}` with the actual token ID (0, 1, 2, etc.)

---

## Important Notes

- The base URI is fixed and cannot be changed after deployment
- Token IDs are sequential starting from 0
- The contract owner can perform Ownable functions (withdraw funds, transfer ownership, etc.)
- Ensure the IPFS directory contains properly named metadata files (0.jpeg, 1.jpeg, etc.)

---

## License

This project is licensed under the MIT License.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

## Support

For help or suggestions:

For help or suggestions, refer to:  
QRemix IDE Documentation: [https://docs.qremix.org](https://docs.qremix.org)
