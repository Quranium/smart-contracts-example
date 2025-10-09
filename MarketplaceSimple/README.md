```markdown
# MarketplaceSimple

## Contract Name
MarketplaceSimple

## Overview
`MarketplaceSimple` is a minimal NFT marketplace that holds ERC721 tokens in custody during listing and supports purchases with ETH or ERC20 tokens. Sellers withdraw proceeds using a pull-withdrawal pattern to avoid reentrancy and gas issues.

This README follows the repository style and assumes use with QRemix/Remix.

## Prerequisites
- MetaMask / QSafe for testnet interactions (optional for JavaScript VM)
- Test ETH
- An ERC721 token for listing and testing
- For ERC20 payments, a token contract to use as payment

## Contract Details

### Key Functions

#### listItem(address nft, uint256 tokenId, address paymentToken, uint256 price)
- **Purpose**: Transfer NFT into contract and create a listing. Caller must `approve` the marketplace first.
- **Parameters**:
  - `nft`: ERC721 address
  - `tokenId`: token id to list
  - `paymentToken`: address(0) = ETH, otherwise ERC20 address
  - `price`: price in wei or token units

#### buy(uint256 id) payable
- **Purpose**: Purchase a listed NFT. For ETH listings, send exact `msg.value`; for ERC20 listings, buyer must `approve` marketplace and `msg.value` must be 0.

#### delist(uint256 id)
- **Purpose**: Seller cancels the listing and retrieves the NFT (if not sold).

#### withdrawETH()
- **Purpose**: Sellers withdraw accumulated ETH proceeds.

#### withdrawToken(address token)
- **Purpose**: Sellers withdraw accumulated ERC20 proceeds for `token`.

### Events
- `Listed(id, seller, nft, tokenId, paymentToken, price)`
- `Bought(id, buyer, price)`
- `Delisted(id)`
- `WithdrawnETH(seller, amount)`
- `WithdrawnToken(seller, token, amount)`

### Security Notes
- Uses pull withdrawals for seller proceeds to reduce reentrancy risks.
- Buyers must ensure they send correct ETH or approve ERC20 before buying.
- Contract holds NFTs in custody while listed; owners trust the contract to return NFT when delisted or on sale.

## Deployment & Testing (QRemix / Remix)

### Setup
1. Open QRemix or Remix.
2. Create `MarketplaceSimple/` folder and add `MarketplaceSimple.sol`.
3. Deploy a sample ERC721 contract if none available.

### Compilation
1. Set Solidity compiler to 0.8.x and compile.

### Example Flow
1. Mint an ERC721 to account A.
2. Approve `MarketplaceSimple` to transfer tokenId from account A.
3. Account A calls `listItem(nftAddress, tokenId, address(0), price)` to list for ETH.
4. Account B calls `buy(id)` sending `msg.value = price`.
5. Account B receives the NFT; account A calls `withdrawETH()` to collect funds.

### ERC20 Purchase Flow
1. Seller lists with `paymentToken` set to token address and `price` set in token units.
2. Buyer approves marketplace to spend `price` tokens.
3. Buyer calls `buy(id)` with zero ETH; marketplace transfers tokens to itself then credits seller's pendingToken balance and transfers NFT to buyer.

## Tests to run
- List then buy with ETH; verify NFT ownership and seller balance.
- List then delist; verify NFT returned to seller and listing inactive.
- List with ERC20 payment; buyer approves and purchases; seller withdraws ERC20.

## License
MIT (see SPDX header in contract)

``` 