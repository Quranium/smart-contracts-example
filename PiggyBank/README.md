# PiggyBank

## Contract Name
PiggyBank

## Overview
The **PiggyBank** smart contract is a simple Ethereum wallet that allows the contract owner to deposit and withdraw funds.  
It demonstrates the use of the `receive` function, ownership restrictions, and secure withdrawal logic.  

It can be deployed and tested in the **QRemix IDE** using the JavaScript VM (local testing) or on testnets like the **Quranium Testnet** or **Sepolia**.

---

## Prerequisites
To deploy and test the contract, you need:

* **MetaMask or QSafe** (optional): For testnet deployments.
* **Test ETH or QRN**: Required for deploying to Sepolia or Quranium testnet.
* **QRemix IDE**: Access at [qremix.org](https://qremix.org).
* **Basic Solidity Knowledge**: Understanding of contract deployment and payable functions.

---

## Contract Details

### State Variables
- **`owner`** (`address`):  
  Stores the address of the contract owner (the account that deployed the contract).

### Functions

#### constructor()
- **Purpose**: Sets the `owner` of the contract to the deployer’s address.  
- **Access**: Called only once at deployment.

#### receive() external payable
- **Purpose**: Allows the contract to receive ETH/QRN directly.  
- **Usage**: Send funds to the contract address using MetaMask, Remix, or any wallet.

#### withdraw()
- **Purpose**: Withdraws the entire balance of the contract to the owner’s address.  
- **Access**: Only the `owner` can call.  
- **Restrictions**:  
  - Reverts with `"not owner"` if called by anyone other than the owner.  
  - Transfers the full contract balance to the owner.  

---

## Deployment and Testing in QRemix IDE

### Step 1: Setup
1. Open [qremix.org](https://qremix.org).
2. Create a new file: `PiggyBank.sol`.
3. Copy and paste the contract code.

### Step 2: Compilation
1. Go to the **Solidity Compiler** tab.
2. Select compiler version **0.8.19** or higher.
3. Compile `PiggyBank.sol`.

### Step 3: Deployment

#### For Quranium Testnet:
1. Go to the **Deploy & Run Transactions** tab.
2. Select **Injected Provider - MetaMask** as environment.
3. Connect MetaMask/QSafe to **Quranium Testnet**.
4. Deploy the contract.  
   - The deployer will automatically become the **owner**.

#### For JavaScript VM (Local Testing):
1. Go to the **Deploy & Run Transactions** tab.
2. Select **JavaScript VM** as environment.
3. Deploy the contract locally.

---

## Step 4: Testing

1. **Deposit funds**:  
   - Select the deployed contract.  
   - In the Remix "Value" field, enter some ETH/QRN (e.g., `1 ether`).  
   - Click **Transact** on the contract → funds are stored in the PiggyBank.

2. **Check balance**:  
   - Use the "At Address" section or call `address(this).balance` in Remix to see funds.

3. **Withdraw funds**:  
   - Call `withdraw()` from the **owner** account.  
   - The full balance transfers to the owner’s wallet.  

4. **Test restrictions**:  
   - Switch to a **non-owner account**.  
   - Try calling `withdraw()` → transaction will fail with `"not owner"`.

---

## License
This project is licensed under the MIT License.  
See `SPDX-License-Identifier: MIT` in the contract file.

---

## Support
For help or more information:
* **QRemix Docs**: [docs.qremix.org](https://docs.qremix.org)

