```markdown
# NFTLease

## Contract Name
NFTLease

## Overview
`NFTLease` allows NFT owners to deposit an ERC721 into the contract and list it for time-based rentals. Renters pay ETH for one or more periods; the NFT remains in contract custody during the lease. Owners receive rent payments instantly and can withdraw the NFT when it is not rented or after the lease expiry.

This README follows the repository's README style and is written for deployment/testing via QRemix/Remix.

## Prerequisites
- MetaMask or QSafe for testnet interaction (optional for JavaScript VM)
- Test ETH for transactions
- An ERC721 token (deploy a local sample NFT or use an existing one)
- QRemix / Remix IDE

## Contract Details

### Key Functions

#### createListingAndDeposit(address nft, uint256 tokenId, uint256 pricePerPeriod, uint256 periodSeconds)
- **Purpose**: Transfer the NFT into contract custody and create an on-chain listing.
- **Notes**: Caller must `approve` this contract for the tokenId before calling.

#### rent(uint256 id, uint256 periods) payable
- **Purpose**: Rent the listing for `periods` periods by paying `pricePerPeriod * periods` in wei.
- **Notes**: Renter receives temporary rights until `expiry` but the NFT stays held by the contract.

#### endLease(uint256 id)
- **Purpose**: End the lease early. Can be called by the renter or the owner.

#### withdrawNFT(uint256 id)
- **Purpose**: Owner withdraws the NFT when not rented (or after expiry).

#### isActive(uint256 id) view returns (bool)
- **Purpose**: Check whether a listing is currently rented and active.

### Events
- `Listed(id, owner, nft, tokenId, pricePerPeriod, periodSeconds)`
- `Rented(id, renter, expiry)`
- `LeaseEnded(id)`
- `NFTWithdrawn(id, to)`

### Security & Notes
- The contract requires the NFT owner to approve the contract before calling `createListingAndDeposit`.
- Rent payments are forwarded to the owner immediately. The contract does not hold rent funds long-term.
- The NFT remains in custody; ensure the owner trusts the contract before depositing valuable NFTs.

## Deployment & Testing (QRemix / Remix)

### Setup
1. Open QRemix (qremix.org) or Remix (remix.ethereum.org).
2. Create folder `NFTLease/` and add `NFTLease.sol`.
3. Deploy or import an ERC721 token for testing.

### Compilation
1. Select Solidity compiler 0.8.x and compile `NFTLease.sol`.

### Deployment
1. Deploy an ERC721 test token if not already available.
2. In Deploy & Run Transactions, deploy `NFTLease` (no constructor args).

### Example Flow
1. Approve `NFTLease` to transfer tokenId from owner: call `approve(NFTLeaseAddress, tokenId)` on your ERC721 contract.
2. Owner calls `createListingAndDeposit(nftAddress, tokenId, pricePerPeriod, periodSeconds)` to list and deposit the NFT.
3. A renter calls `rent(listingId, periods)` and sends `pricePerPeriod * periods` wei.
4. The renter has rights until `expiry` (check `isActive(listingId)`).
5. Owner or renter can call `endLease(listingId)` to end early.
6. Owner calls `withdrawNFT(listingId)` after expiry to retrieve the NFT.

## Tests to run
- Deploy a sample ERC721 and mint token to account A
- Approve `NFTLease` and create a listing
- Rent from account B and verify `isActive` is true
- Try withdrawing while rented (should fail), then wait for expiry and withdraw (should succeed)

## License
MIT (see SPDX header in contract)

``` 