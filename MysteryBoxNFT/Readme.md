# 🎁 MysteryBoxNFT – On-Chain Gacha Style NFT Minting

Welcome to **MysteryBoxNFT**, a unique and fun smart contract that lets users **purchase a mystery box**, which mints a **random NFT** with one of four rarities: Common, Rare, Epic, or Legendary. Some rare NFTs even unlock a hidden **on-chain story**!

This project is written entirely in **vanilla Solidity** — no imports, no external dependencies, just pure code.

---

## ✨ Features

- 🎲 **Random Rarity Assignment**  
  Each NFT minted has a rarity determined by pseudo-randomness:
  - Common (60%)
  - Rare (25%)
  - Epic (12%)
  - Legendary (3%)

- 📖 **Hidden Lore**  
  NFTs of Epic and Legendary rarity come with a special on-chain story that can be revealed by the owner.

- 💎 **Fully On-Chain NFT Logic**  
  All data is stored and processed on-chain: no ERC721 library needed.

- 🪙 **Minting Price**  
  Purchase a box for just `0.01 ETH`.

---

## 🔧 How It Works

1. **Purchase a Box**  
   Call `purchaseBox()` while sending `0.01 ETH`.

2. **NFT Minting**  
   A new NFT is minted with:
   - Randomized rarity
   - Optional story if it's Epic or Legendary
   - On-chain metadata URI

3. **Reveal Story**  
   If the NFT has a story, call `getStory(tokenId)` (only if you own it) to read the lore.

4. **Withdraw Funds**  
   The contract owner can withdraw accumulated ETH using `withdraw()`.

---

## 📜 Contract Structure

| Function              | Description                                               |
|-----------------------|-----------------------------------------------------------|
| `purchaseBox()`       | Mints a new NFT with randomized rarity                    |
| `getMyTokens()`       | Returns list of token IDs owned by sender                 |
| `getStory(tokenId)`   | Returns the NFT story if it's unlocked and owned          |
| `withdraw()`          | Allows the owner to withdraw the collected ETH            |
| `tokenURIs[tokenId]`  | Returns metadata URI based on rarity and token ID         |
| `tokens[tokenId]`     | Returns full metadata (owner, rarity, story info)         |

---

## 🧪 Example Usage (Remix)

1. Deploy the contract with no constructor arguments.
2. In the Remix "Deploy & Run" panel:
   - Select `purchaseBox()`, send 0.01 ETH.
   - Call `getMyTokens()` to get your token ID.
   - Call `getStory(tokenId)` if you got an Epic/Legendary.

---

## 🛠 Tech Stack

- ✅ Solidity `^0.8.19`
- 🔥 No imports (no OpenZeppelin, Chainlink, etc.)
- 🧠 All logic built from scratch


## 🧙 About

Inspired by the idea of on-chain loot boxes, storytelling, and collectible rarity. Great for games, lore-based NFTs, or Web3 art projects.

Have ideas? Let's evolve this together!

