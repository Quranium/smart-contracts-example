# Reward System

## Contract Name
RewardManager & RewardToken

## Overview
The Reward System consists of two smart contracts: RewardToken (ERC20-like token) and RewardManager (token issuer for mobile apps). The system allows backend services to issue rewards to users and enables users to redeem their rewards. The contracts utilize **OpenZeppelin** compatible patterns for secure token management and access control.

*They are designed to be deployed and tested in the **QRemix IDE** using the JavaScript VM or a testnet like Quranium testnet, Sepolia etc.*

## Prerequisites
To deploy and test the contracts, you need:

* **MetaMask or QSafe**: Browser extension for testnet deployments (optional).
* **Test ETH or QRN**: Required for testnet deployments (e.g., from a Sepolia faucet like sepoliafaucet.com, Quranium faucet.quranium.org).
* **QRemix IDE**: Access at qremix.org.
* **Basic Solidity Knowledge**: Understanding of ERC20 tokens, smart contract deployment, and Remix IDE.

## Contract Details

### RewardToken Contract

#### Functions

##### initialize(string memory _name, string memory _symbol, address _owner)
- **Purpose**: Initialize the token with name, symbol, and owner
- **Parameters**: 
  - `_name`: Token name
  - `_symbol`: Token symbol
  - `_owner`: Owner address
- **Access**: Anyone (but only once)

##### mint(address to, uint256 amount)
- **Purpose**: Mint new tokens to specified address
- **Parameters**: 
  - `to`: Recipient address
  - `amount`: Amount to mint
- **Access**: Only owner

##### burn(address from, uint256 amount)
- **Purpose**: Burn tokens from specified address
- **Parameters**: 
  - `from`: Address to burn from
  - `amount`: Amount to burn
- **Access**: Only owner

##### transfer(address to, uint256 amount)
- **Purpose**: Transfer tokens to another address
- **Parameters**: 
  - `to`: Recipient address
  - `amount`: Amount to transfer
- **Returns**: Boolean success status

##### approve(address spender, uint256 amount)
- **Purpose**: Approve spender to transfer tokens on behalf of caller
- **Parameters**: 
  - `spender`: Address to approve
  - `amount`: Amount to approve
- **Returns**: Boolean success status

##### transferFrom(address from, address to, uint256 amount)
- **Purpose**: Transfer tokens from one address to another (requires approval)
- **Parameters**: 
  - `from`: Source address
  - `to`: Recipient address
  - `amount`: Amount to transfer
- **Returns**: Boolean success status

#### Events
- **Transfer(address indexed from, address indexed to, uint256 value)**: Emitted on token transfers
- **Approval(address indexed owner, address indexed spender, uint256 value)**: Emitted on approvals

### RewardManager Contract

#### Functions

##### initialize(address tokenAddress, address backendAddress)
- **Purpose**: Initialize the reward manager with token and backend addresses
- **Parameters**: 
  - `tokenAddress`: Address of the RewardToken contract
  - `backendAddress`: Address of the backend service
- **Access**: Anyone (but only once)

##### issueReward(address user, uint256 amount)
- **Purpose**: Issue reward tokens to a user
- **Parameters**: 
  - `user`: User address to receive rewards
  - `amount`: Amount of rewards to issue
- **Access**: Only backend

##### redeemReward(uint256 amount)
- **Purpose**: Redeem reward tokens (burn them)
- **Parameters**: 
  - `amount`: Amount of rewards to redeem
- **Access**: Anyone with sufficient balance

##### updateBackend(address newBackend)
- **Purpose**: Update the backend address
- **Parameters**: 
  - `newBackend`: New backend address
- **Access**: Only current backend

#### Events
- **RewardIssued(address indexed user, uint256 amount)**: Emitted when rewards are issued
- **RewardRedeemed(address indexed user, uint256 amount)**: Emitted when rewards are redeemed

## Deployment and Testing in QRemix IDE

### Step 1: Setup
1. Open qremix.org
2. Create folder structure: `RewardSystem/`
3. Create `RewardToken.sol` in the RewardSystem folder
4. Create `RewardManager.sol` in the root directory
5. Copy and paste the respective contract codes

### Step 2: Compilation
1. Go to "Solidity Compiler" tab
2. Select compiler version 0.8.20 or higher
3. Compile `RewardToken.sol` first
4. Then compile `RewardManager.sol`

### Step 3: Deployment

#### For Quranium Testnet:
1. Go to "Deploy & Run Transactions" tab
2. Select "Injected Provider - MetaMask" as environment
3. Ensure MetaMask/QSafe is connected to Quranium Testnet
4. Deploy `RewardToken` contract first
5. Deploy `RewardManager` contract

#### For JavaScript VM (Local Testing):
1. Go to "Deploy & Run Transactions" tab
2. Select "JavaScript VM" as environment
3. Deploy `RewardToken` contract first
4. Deploy `RewardManager` contract

### Step 4: Testing

#### Initialize Contracts:
1. **Initialize RewardToken**: Call `initialize` with token name, symbol, and owner address
2. **Initialize RewardManager**: Call `initialize` with RewardToken address and backend address

#### Test Token Functions:
1. Check initial `totalSupply` and `balanceOf` (should be 0)
2. Use `mint` function to create tokens
3. Test `transfer` between addresses
4. Test `approve` and `transferFrom` functions

#### Test Reward System:
1. Use backend address to call `issueReward` for a user
2. Check user's token balance
3. Use user address to call `redeemReward`
4. Verify tokens are burned and events are emitted

## License
This project is licensed under the MIT License. See the `SPDX-License-Identifier: MIT` in the contract files.

## Support
For issues or feature requests:
* Check the QRemix IDE documentation: https://docs.qremix.org
* Consult OpenZeppelin's documentation: docs.openzeppelin.com