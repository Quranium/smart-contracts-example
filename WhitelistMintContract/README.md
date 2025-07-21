# WhitelistMint

## Contract Name  
**WhitelistMint**

---

## Overview

The **WhitelistMint** contract facilitates an exclusive minting process where only approved (whitelisted) users can mint tokens. The contract allows the owner to manage the whitelist, toggle sale status, and withdraw funds. Each whitelisted user can mint a specified quantity of tokens at a fixed price, while total minting is capped to a maximum supply.

This contract is ideal for **pre-sales**, **early access NFT launches**, and **private token distributions**. It is designed for deployment and testing in the **QRemix IDE** using JavaScript VM or a testnet.

---

## Prerequisites

- MetaMask or QSafe (for testnet deployment)
- Testnet ETH or QRN
- Access to QRemix IDE
- Basic knowledge of Solidity and smart contract workflow

---

## Contract Functions

### `initialize()`
- **Purpose:** Sets the deployer as the owner (used instead of constructor)
- **Access:** Callable once (only if not already initialized)

---

### `toggleSale()`
- **Purpose:** Starts or pauses the public sale
- **Access:** Only callable by owner

---

### `addToWhitelist(address[] calldata addresses)`
- **Purpose:** Adds a batch of addresses to the whitelist
- **Access:** Only callable by owner

---

### `removeFromWhitelist(address user)`
- **Purpose:** Removes a single address from the whitelist
- **Access:** Only callable by owner

---

### `mint(uint256 quantity)`
- **Purpose:** Allows a whitelisted user to mint tokens during an active sale
- **Access:** Only whitelisted addresses  
- **Conditions:**
  - Sale must be active  
  - Quantity > 0  
  - Total supply must not exceed `maxSupply`  
  - User must send exact ETH (quantity × `mintPrice`)

---

### `withdraw()`
- **Purpose:** Transfers all collected ETH to the owner
- **Access:** Only callable by owner

---

### `getMinted(address user) external view returns (uint256)`
- **Purpose:** Returns how many tokens the given address has minted
- **Access:** Public read-only

---

## Access Control

- **Owner:** Can toggle sale, manage whitelist, and withdraw funds  
- **Whitelisted Users:** Allowed to mint if sale is active  

Role-based access is enforced using the `onlyOwner` modifier and whitelist checks. Initialization protection ensures the contract can’t be hijacked after deployment.

---

## Deployment & Testing on QRemix

### Step 1: Setup
- Open [qremix.org](https://qremix.org)
- Create folder: `WhitelistMint/`
- Add `WhitelistMint.sol` and paste the contract code

---

### Step 2: Compile
- Go to **Solidity Compiler**
- Select version `0.8.20`
- Click **Compile**

---

### Step 3: Deploy

#### 🧪 Quranium Testnet
- Go to **Deploy & Run Transactions**
- Select **Injected Provider - MetaMask**
- Connect to **Quranium testnet**
- Deploy contract (no constructor params)
- Call `initialize()` immediately after deployment

#### 🧪 JavaScript VM
- Choose **JavaScript VM**
- Deploy contract
- Immediately call `initialize()` to set the owner

---

### Step 4: Testing
1. Call `initialize()` to set the owner
2. Call `addToWhitelist([user1, user2, ...])` from the owner account
3. Call `toggleSale()` to activate sale
4. Call `mint(quantity)` from a whitelisted address with sufficient ETH
5. Call `getMinted(user)` to check mint count
6. Call `withdraw()` to transfer funds to the owner

---

## License

This project is licensed under the MIT License.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

## Support

For issues or feature requests, refer to:  
📚 [QRemix IDE Documentation](https://docs.qremix.org)
