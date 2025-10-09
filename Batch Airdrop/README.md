```markdown
# Batch Airdrop

## Contract Name
BatchAirdrop

## Overview
The `BatchAirdrop` contract lets an owner fund a contract with an ERC20 token and distribute it to recipients in on-chain batches, and/or enable a Merkle root so recipients can claim their allocation using a Merkle proof. The implementation is intentionally minimal and designed for quick deployment and testing (no external imports).

This README follows the same format as other contracts in this repository and assumes deployment & testing via the QRemix IDE or Remix with a JavaScript VM or testnet.

## Prerequisites
To deploy and test the contract you need:

- **MetaMask or QSafe** (for testnet deployments) — optional for JavaScript VM
- **Test ETH / native token** for gas on the chosen testnet (e.g., Sepolia)
- **An ERC20 token** to distribute (use a local TestToken or deploy a minimal ERC20 in Remix)
- **QRemix / Remix IDE** (https://remix.ethereum.org or qremix.org)
- **Basic Solidity knowledge** (deploying contracts, interacting with transactions, ABI)

## Contract Details

### Purpose
- Owner funds the contract with an ERC20 token and calls `batchAirdrop` to distribute to arrays of recipients.
- Alternatively, set a `merkleRoot` and allow recipients to call `claim(amount, proof)` with a valid Merkle proof to receive their allocation.

### Key Functions

#### constructor(address tokenAddress, bytes32 merkleRoot)
- **Purpose**: Initialize contract with token address and optional merkle root.
- **Parameters**:
  - `tokenAddress`: ERC20 token contract address
  - `merkleRoot`: optional Merkle root (pass `0x0` to leave unset)

#### setMerkleRoot(bytes32 _r)
- **Purpose**: Set or update the Merkle root (owner only)
- **Access**: Owner

#### batchAirdrop(address[] to, uint256[] v)
- **Purpose**: Perform a batch distribution. The contract must hold enough tokens.
- **Parameters**:
  - `to`: array of recipient addresses
  - `v`: array of token amounts (same length as `to`)
- **Notes**: Keep batch sizes moderate to avoid gas limits; call multiple times if needed.

#### claim(uint256 amount, bytes32[] proof)
- **Purpose**: Claim tokens using a Merkle proof (if `merkleRoot` is set).
- **Parameters**:
  - `amount`: the amount allocated to the caller in the merkle tree
  - `proof`: array of bytes32 merkle proof entries
- **Notes**: Prevents double-claims using an internal `claimed` mapping.

#### withdraw(address to, uint256 amount)
- **Purpose**: Owner can withdraw remaining tokens from the contract.

### Events
- `Airdropped(address to, uint256 amount)` — emitted per successful batch transfer
- `Claimed(address who, uint256 amount)` — emitted on successful Merkle claim
- `Withdrawn(address to, uint256 amount)` — emitted on owner withdrawal

### Security & Notes
- Uses a safe internal transfer helper to handle non-standard ERC20s.
- The contract trusts the owner to set a correct Merkle root and fund the contract.
- Keep batch sizes reasonable to avoid out-of-gas; split large distributions into multiple calls.

## Deployment and Testing in QRemix / Remix

### Step 1: Setup
1. Open QRemix (qremix.org) or Remix (remix.ethereum.org).
2. Create folder `Batch Airdrop/` and add `BatchAirdrop.sol`.
3. Make sure an ERC20 token is available (deploy a local test token or use an existing token address).

### Step 2: Compilation
1. In the Solidity Compiler tab select version 0.8.x (>=0.8.0).
2. Compile `BatchAirdrop.sol`.

### Step 3: Deployment
1. In Deploy & Run Transactions select environment (JavaScript VM for local testing or Injected Provider for MetaMask).
2. Deploy `BatchAirdrop` with constructor arguments:
   - `tokenAddress`: address of the ERC20 used for distribution
   - `merkleRoot`: `0x0` if you don't want Merkle-claims enabled initially
3. After deployment, transfer the total tokens to be distributed into the `BatchAirdrop` contract address (use the ERC20 `transfer` from the token deployer account).

### Step 4: Batch Airdrop Example (on Remix)
1. Prepare two arrays in the UI: `to` (addresses) and `v` (amounts) with the same length.
2. Call `batchAirdrop(to, v)` from the owner account.
3. Check recipient balances in the ERC20 contract to confirm receipt.

### Step 5: Merkle Claim Example
1. Generate a Merkle tree off-chain where each leaf = keccak256(abi.encodePacked(address, amount)).
   - You can use a JS library like `merkletreejs` to create the root and proofs.
2. Call `setMerkleRoot(root)` from the owner (if not set at deploy).
3. Each recipient calls `claim(amount, proof)` with their proof; contract verifies and transfers tokens.

#### Helpful snippet (node / merkletreejs)
```js
const { MerkleTree } = require('merkletreejs')
const keccak256 = require('keccak256')

const leaves = recipients.map(r => keccak256(r.address + r.amount)) // ensure same encoding as contract
const tree = new MerkleTree(leaves, keccak256, { sortPairs: true })
const root = tree.getHexRoot()
// proof for recipient i:
const proof = tree.getHexProof(leaves[i])
```

## Testing Checklist
- Verify `batchAirdrop` transfers the correct amounts to recipients
- Verify `claim` succeeds with valid proof and fails on replay
- Verify `withdraw` allows owner to recover leftover tokens
- Test with multiple small batches to emulate large distributions

## License
MIT (see SPDX header in the contract)

## Support
If you encounter issues or want enhancements (gas-optimizations, chunked airdrop helper, or sample scripts), open an issue or request here.

``` 