# DubaiTransportPass

---

### Contract Name  
**DubaiTransportPass**

---

### Overview

The **DubaiTransportPass** smart contract is a blockchain-based prepaid transport pass system designed for Dubai's smart mobility network. This contract enables the issuance, management, and usage of digital transport passes stored on-chain, providing a transparent and secure solution for public transportation payments.

The system supports pass issuance, balance management, ride deduction, recharging, and administrative controls for pass suspension/reactivation. Built with modern Solidity practices and comprehensive event logging for transparency.

Perfect for smart city initiatives, public transport digitization, or educational blockchain projects demonstrating real-world utility.

---

## Prerequisites

- MetaMask or compatible Web3 wallet
- ETH or testnet tokens (for gas fees)
- Remix IDE or similar development environment
- Basic understanding of smart contract interactions

---

### Contract Functions

#### issuePass

```solidity
issuePass(address user, uint256 duration, uint256 initialBalance) external onlyAdmin
```
- **Purpose:** Issues a new transport pass to a user
- **Access:** Admin only
- **Parameters:** 
  - `user` - recipient address
  - `duration` - validity period in seconds
  - `initialBalance` - initial prepaid amount
- **Requirement:** User must not already have a pass

#### takeRide

```solidity
takeRide(uint256 passId) external onlyPassOwner(passId)
```
- **Purpose:** Deducts base fare from pass balance for a ride
- **Access:** Pass owner only
- **Parameters:** `passId` - ID of the user's pass
- **Requirements:** Pass must be active, not expired, and have sufficient balance

#### rechargePass

```solidity
rechargePass(uint256 passId) external payable onlyPassOwner(passId)
```
- **Purpose:** Adds more balance to the pass
- **Access:** Pass owner only
- **Parameters:** `passId` - ID of the user's pass
- **Requirement:** Must send ETH with the transaction

#### suspendPass

```solidity
suspendPass(uint256 passId) external onlyAdmin
```
- **Purpose:** Suspends a pass (e.g., for lost/stolen cases)
- **Access:** Admin only
- **Parameters:** `passId` - ID of the pass to suspend

#### reactivatePass

```solidity
reactivatePass(uint256 passId) external onlyAdmin
```
- **Purpose:** Reactivates a suspended pass
- **Access:** Admin only
- **Parameters:** `passId` - ID of the pass to reactivate
- **Requirement:** Pass must not be expired

#### getPass

```solidity
getPass(uint256 passId) external view returns (Pass memory)
```
- **Purpose:** Returns complete pass information
- **Access:** Public read-only
- **Returns:** Pass struct containing owner, balance, timestamps, and status

#### getPassIdByUser

```solidity
getPassIdByUser(address user) external view returns (uint256)
```
- **Purpose:** Returns the pass ID associated with a user address
- **Access:** Public read-only
- **Returns:** Pass ID (0 if user has no pass)

---

### Access Control

This contract implements role-based access control:

- **Admin Functions**: `issuePass`, `suspendPass`, `reactivatePass`
- **Pass Owner Functions**: `takeRide`, `rechargePass`
- **Public Functions**: `getPass`, `getPassIdByUser`

> The admin is set to the contract deployer and cannot be changed.

---

### Contract State

#### Constants
- `baseFare`: Default ride cost (3 ether/wei)
- `admin`: Contract administrator address
- `totalIssued`: Total number of passes issued

#### Data Structures
```solidity
struct Pass {
    address owner;      // Pass holder's address
    uint256 balance;    // Available balance
    uint256 issuedAt;   // Creation timestamp
    uint256 expiresAt;  // Expiration timestamp
    bool isActive;      // Suspension status
}
```

---

### Events

- `PassIssued`: Emitted when a new pass is created
- `RideTaken`: Emitted when a ride is taken
- `PassRecharged`: Emitted when balance is added
- `PassSuspended`: Emitted when pass is suspended
- `PassReactivated`: Emitted when pass is reactivated

---

### Deployment & Testing

#### Step 1: Setup
- Open [remix.ethereum.org](https://remix.ethereum.org)
- Create folder: `DubaiTransportPass/`
- Add `DubaiTransportPass.sol` and paste the contract code

#### Step 2: Compile
- Go to Solidity Compiler
- Select compiler version `^0.8.20`
- Compile the contract

#### Step 3: Deploy

##### Ethereum Testnet (Sepolia/Goerli)
- Go to **Deploy & Run Transactions**
- Choose **Injected Provider - MetaMask**
- Connect to testnet
- Deploy contract (no constructor arguments)

##### Local Testing (JavaScript VM)
- Choose **JavaScript VM**
- Deploy contract directly

#### Step 4: Testing Workflow

1. **As Admin:**
   ```solidity
   // Issue a pass (30 days = 2592000 seconds)
   issuePass(userAddress, 2592000, 1000000000000000000); // 1 ETH initial balance
   ```

2. **As User:**
   ```solidity
   // Take a ride
   takeRide(1);
   
   // Recharge pass with 0.5 ETH
   rechargePass(1, {value: 500000000000000000});
   
   // Check pass details
   getPass(1);
   ```

3. **Admin Controls:**
   ```solidity
   // Suspend pass
   suspendPass(1);
   
   // Reactivate pass
   reactivatePass(1);
   ```

---

### Example Usage

```solidity
// Deploy contract (admin = deployer)
DubaiTransportPass transportPass = new DubaiTransportPass();

// Issue pass to user (30 days, 1 ETH balance)
transportPass.issuePass(userAddress, 2592000, 1 ether);

// User takes ride
transportPass.takeRide(1);

// Check remaining balance
Pass memory userPass = transportPass.getPass(1);
console.log("Remaining balance:", userPass.balance);
```

---

### Security Considerations

- **Single Pass Limitation**: Each address can only have one active pass
- **Time-based Expiration**: Passes automatically expire after the set duration
- **Balance Validation**: Rides require sufficient balance
- **Admin Controls**: Only admin can issue/suspend passes
- **Owner Validation**: Only pass owners can use their passes

---

### License

This project is licensed under the MIT License.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

### Support

For help, improvements, or bug reports:
- Remix IDE Docs: https://remix-ide.readthedocs.io
- Solidity Documentation: https://docs.soliditylang.org
- OpenZeppelin Contracts: https://docs.openzeppelin.com


