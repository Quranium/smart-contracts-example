# Stablecoin

## Contract Name
Stablecoin

## Overview
The Stablecoin System is a smart contract that enables **minting**, **burning**, **transferring**, and **admin control** over a custom ERC-20 stable token. The system ensures that only the admin can mint or burn tokens and that the total supply remains transparent and auditable.

It is designed to be deployed and tested in the **QRemix IDE** using the JavaScript VM or testnets like Quranium Testnet, Sepolia, etc.

## Prerequisites
To deploy and test the contracts, you need:

* **MetaMask or QSafe**: For connecting to a testnet (optional).
* **Test ETH or QRN**: From a faucet like [sepoliafaucet.com](https://sepoliafaucet.com) or [faucet.quranium.org](https://faucet.quranium.org).
* **QRemix IDE**: Access at [qremix.org](https://qremix.org).
* **Basic Solidity Knowledge**: Familiarity with smart contract deployment and Solidity syntax.

## Contract Details

### Stablecoin Contract

#### Functions

##### mint(address _to, uint256 _amount)
- **Purpose**: Mint new stablecoins to a specific address.
- **Parameters**:
  - `_to`: Address receiving the tokens.
  - `_amount`: Amount of tokens to mint.
- **Access**: Only Owner (Admin)

##### burn(address _from, uint256 _amount)
- **Purpose**: Burn stablecoins from a specific address.
- **Parameters**:
  - `_from`: Address from which tokens are burned.
  - `_amount`: Amount of tokens to burn.
- **Access**: Only Owner (Admin)

##### transfer(address _to, uint256 _amount)
- **Purpose**: Transfer tokens to another address.
- **Parameters**:
  - `_to`: Recipient address.
  - `_amount`: Amount to transfer.
- **Access**: Public

##### balanceOf(address _account)
- **Purpose**: Get the token balance of an account.
- **Returns**: Token balance as `uint256`

##### totalSupply()
- **Purpose**: Get the total supply of the stablecoin.
- **Returns**: Total supply as `uint256`

#### Events
- **Mint(address indexed to, uint256 amount)**: Emitted when tokens are minted.
- **Burn(address indexed from, uint256 amount)**: Emitted when tokens are burned.
- **Transfer(address indexed from, address indexed to, uint256 amount)**: Standard ERC-20 event for transfers.

## Deployment and Testing in QRemix IDE

### Step 1: Setup
1. Open [qremix.org](https://qremix.org)
2. Create a folder named `StablecoinSystem/`
3. Create a file `Stablecoin.sol` inside the folder
4. Paste the contract code into `Stablecoin.sol`

### Step 2: Compilation
1. Go to the "Solidity Compiler" tab
2. Choose compiler version 0.8.20 or higher
3. Compile the `Stablecoin.sol` file

### Step 3: Deployment

#### For Quranium Testnet:
1. Go to "Deploy & Run Transactions"
2. Set environment to "Injected Provider - MetaMask"
3. Ensure MetaMask is connected to Quranium Testnet
4. Deploy the `Stablecoin` contract

#### For JavaScript VM (Local Testing):
1. Go to "Deploy & Run Transactions"
2. Set environment to "JavaScript VM"
3. Deploy the `Stablecoin` contract

### Step 4: Testing

#### Setup:
1. **Mint Tokens**: Use `mint` with recipient address and amount
2. **Transfer Tokens**: Use `transfer` from one address to another
3. **Burn Tokens**: Use `burn` with source address and amount

#### Verification:
1. Use `balanceOf` to confirm balances
2. Use `totalSupply` to check total circulating supply
3. Admin-only actions (`mint`, `burn`) must fail from non-owner accounts

#### Edge Case Tests:
- Mint to zero address (should fail)
- Burn more than account balance (should fail)
- Try `mint` or `burn` as a non-admin (should fail)

## License
This project is licensed under the MIT License. See `SPDX-License-Identifier: MIT` in the source files.

## Support
For issues or feature requests:
* Check [QRemix IDE documentation](https://docs.qremix.org)
* Refer to OpenZeppelin Contracts [documentation](https://docs.openzeppelin.com/contracts)