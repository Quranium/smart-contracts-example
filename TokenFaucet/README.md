# Token Faucet

## Contract Name
Faucet & Token

## Overview
The Token Faucet system consists of two smart contracts: Token (ERC20-like minimal token) and Faucet (one-time token dispenser). The system allows users to claim tokens once from the faucet for testing purposes. The contracts utilize **OpenZeppelin** compatible patterns for secure token management and distribution.

*They are designed to be deployed and tested in the **QRemix IDE** using the JavaScript VM or a testnet like Quranium testnet, Sepolia etc.*

## Prerequisites
To deploy and test the contracts, you need:

* **MetaMask or QSafe**: Browser extension for testnet deployments (optional).
* **Test ETH or QRN**: Required for testnet deployments (e.g., from a Sepolia faucet like sepoliafaucet.com, Quranium faucet.quranium.org).
* **QRemix IDE**: Access at qremix.org.
* **Basic Solidity Knowledge**: Understanding of ERC20 tokens, smart contract deployment, and Remix IDE.

## Contract Details

### Token Contract

#### Functions

##### mint(address to, uint256 amount)
- **Purpose**: Mint new tokens to specified address
- **Parameters**: 
  - `to`: Recipient address
  - `amount`: Amount to mint
- **Access**: Anyone

##### transfer(address to, uint256 amount)
- **Purpose**: Transfer tokens to another address
- **Parameters**: 
  - `to`: Recipient address
  - `amount`: Amount to transfer
- **Returns**: Boolean success status

##### balanceOf(address account)
- **Purpose**: Check token balance of an address
- **Parameters**: 
  - `account`: Address to check
- **Returns**: Token balance

#### Events
- **Transfer(address indexed from, address indexed to, uint256 value)**: Emitted on token transfers

### Faucet Contract

#### Functions

##### setTokenAddress(address tokenAddress)
- **Purpose**: Set the token contract address (can only be done once)
- **Parameters**: 
  - `tokenAddress`: Address of the Token contract
- **Access**: Anyone (but only once)

##### claim()
- **Purpose**: Claim tokens from the faucet (one-time per address)
- **Parameters**: None
- **Access**: Anyone (but only once per address)

##### hasClaimed(address user)
- **Purpose**: Check if a user has already claimed tokens
- **Parameters**: 
  - `user`: Address to check
- **Returns**: Boolean indicating if user has claimed

##### dripAmount()
- **Purpose**: Get the amount of tokens dispensed per claim
- **Returns**: Amount of tokens (100 tokens with 18 decimals)

## Deployment and Testing in QRemix IDE

### Step 1: Setup
1. Open qremix.org
2. Create folder structure: `TokenFaucet/`
3. Create `Token.sol` in the TokenFaucet folder
4. Create `Faucet.sol` in the root directory
5. Copy and paste the respective contract codes

### Step 2: Compilation
1. Go to "Solidity Compiler" tab
2. Select compiler version 0.8.20 or higher
3. Compile `Token.sol` first
4. Then compile `Faucet.sol`

### Step 3: Deployment

#### For Quranium Testnet:
1. Go to "Deploy & Run Transactions" tab
2. Select "Injected Provider - MetaMask" as environment
3. Ensure MetaMask/QSafe is connected to Quranium Testnet
4. Deploy `Token` contract first
5. Deploy `Faucet` contract

#### For JavaScript VM (Local Testing):
1. Go to "Deploy & Run Transactions" tab
2. Select "JavaScript VM" as environment
3. Deploy `Token` contract first
4. Deploy `Faucet` contract

### Step 4: Testing

#### Setup System:
1. **Set Token Address**: Call `setTokenAddress` on Faucet contract with Token contract address
2. Check `dripAmount` to confirm it's 100 tokens

#### Test Token Claims:
1. Switch to different user addresses
2. Call `claim` from user addresses
3. Verify `hasClaimed` returns true for users
4. Check `balanceOf` on Token contract shows 100 tokens

#### Test Token Transfers:
1. Use `transfer` function to send tokens between addresses
2. Verify balances update correctly
3. Check Transfer events are emitted

#### Test Restrictions:
1. Try claiming tokens twice from same address (should fail)
2. Try setting token address twice (should fail)
3. Verify proper error messages

## License
This project is licensed under the MIT License. See the `SPDX-License-Identifier: MIT` in the contract files.

## Support
For issues or feature requests:
* Check the QRemix IDE documentation: https://docs.qremix.org
* Consult OpenZeppelin's documentation: docs.openzeppelin.com