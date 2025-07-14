# HealthcareSupplyChain

## Contract Name
**HealthcareSupplyChain**

---

## Overview

The `HealthcareSupplyChain` contract is designed to track critical healthcare items such as vaccines, medical equipment, and drugs as they move from manufacturers to hospitals via authorized distributors. It ensures transparency and trust by allowing each party to update the item’s stage and record timestamps for each transition.

It is ideal for blockchain-based healthcare tracking systems and is designed to be deployed and tested in the QRemix IDE using the JavaScript VM or a testnet.

---

## Prerequisites

- MetaMask or QSafe (for testnet deployment)
- Testnet ETH or QRN
- Access to QRemix IDE
- Basic knowledge of Solidity and smart contract design

---

## Contract Functions

### Constructor

```solidity
constructor()
```
- **Purpose:** Sets the deploying address as the admin
- **Access:** Called on deployment

---

### createItem

```solidity
createItem(string _name, string _batchId, address _distributor, address _hospital)
```
- **Purpose:** Creates a new medical item and sets initial supply chain metadata
- **Access:** Only callable by admin
- **Condition:** Batch ID must be unique

---

### shipItem

```solidity
shipItem(string _batchId)
```
- **Purpose:** Marks the item as shipped by the distributor
- **Access:** Only callable by the designated distributor
- **State Required:** Item must be in Manufactured stage

---

### deliverItem

```solidity
deliverItem(string _batchId)
```
- **Purpose:** Marks the item as delivered by the hospital
- **Access:** Only callable by the designated hospital
- **State Required:** Item must be in InTransit stage

---

### getItemDetails

```solidity
getItemDetails(string _batchId)
```
- **Purpose:** Returns full item metadata including stage, parties involved, and timestamp
- **Returns:** name, manufacturer, distributor, hospital, timestamp, current stage

---

## Access Control

- **Admin (Deployer):** Creates items and initiates the tracking process
- **Distributor:** Ships item to hospital after manufacturing
- **Hospital:** Confirms item delivery

Access is enforced through explicit address checks and modifiers.

---

## Deployment & Testing on QRemix

### Step 1: Setup
- Open [qremix.org](https://qremix.org)
- Create folder: `HealthcareSupplyChain/`
- Add `HealthcareSupplyChain.sol` and paste the contract code

### Step 2: Compile
- Go to Solidity Compiler
- Select version `0.8.20`
- Compile the contract

### Step 3: Deploy

#### Quranium Testnet
- Go to Deploy & Run Transactions
- Select Injected Provider - MetaMask
- Connect to Quranium testnet
- Deploy with no constructor parameters

#### JavaScript VM
- Choose JavaScript VM
- Deploy locally with default admin

### Step 4: Testing
- Call `createItem("CovidVax", "BATCH001", distributorAddr, hospitalAddr)` from admin
- Call `shipItem("BATCH001")` from the distributor’s address
- Call `deliverItem("BATCH001")` from the hospital’s address
- Call `getItemDetails("BATCH001")` from any address to view state

---

## License

This project is licensed under the MIT License.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

## Support

For issues or feature requests, refer to:
QRemix IDE Documentation : https://docs.qremix.org

