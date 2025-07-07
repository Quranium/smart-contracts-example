# Traffic Violation Tracker

## Contract Name
TrafficViolationTracker

## Overview
TrafficViolationTracker is a smart contract that manages traffic violations and fine payments. The contract allows admin to log violations and enables users to pay fines directly through the blockchain. The system maintains records of all violations and payment statuses. The contract follows **OpenZeppelin** compatible patterns for secure access control and payment handling.

*They are designed to be deployed and tested in the **QRemix IDE** using the JavaScript VM or a testnet like Quranium testnet, Sepolia etc.*

## Prerequisites
To deploy and test the contracts, you need:

* **MetaMask or QSafe**: Browser extension for testnet deployments (optional).
* **Test ETH or QRN**: Required for testnet deployments (e.g., from a Sepolia faucet like sepoliafaucet.com, Quranium faucet.quranium.org).
* **QRemix IDE**: Access at qremix.org.
* **Basic Solidity Knowledge**: Understanding of ERC20 tokens, smart contract deployment, and Remix IDE.

## Contract Details

### Functions

#### constructor()
- **Purpose**: Sets the deployer as admin
- **Parameters**: None
- **Access**: Automatically called during deployment

#### logViolation(string memory vehicleNumber, string memory violationType, uint256 fineAmount)
- **Purpose**: Log a new traffic violation
- **Parameters**: 
  - `vehicleNumber`: Vehicle registration number
  - `violationType`: Type of violation (e.g., "Speeding", "Red Light")
  - `fineAmount`: Fine amount in wei
- **Access**: Only admin

#### payFine(uint256 violationId)
- **Purpose**: Pay fine for a specific violation
- **Parameters**: 
  - `violationId`: ID of the violation to pay
- **Access**: Anyone (must send sufficient Ether)

#### getViolationsByVehicle(string memory vehicleNumber)
- **Purpose**: Get all violation IDs for a specific vehicle
- **Parameters**: 
  - `vehicleNumber`: Vehicle registration number
- **Returns**: Array of violation IDs

#### getViolationDetails(uint256 violationId)
- **Purpose**: Get details of a specific violation
- **Parameters**: 
  - `violationId`: ID of the violation
- **Returns**: Violation struct with all details

#### withdraw()
- **Purpose**: Withdraw collected fines to admin address
- **Parameters**: None
- **Access**: Only admin

#### violations(uint256 id)
- **Purpose**: Get violation details by ID
- **Parameters**: 
  - `id`: Violation ID
- **Returns**: Violation struct

#### vehicleToViolationIds(string vehicleNumber, uint256 index)
- **Purpose**: Get violation ID at specific index for a vehicle
- **Parameters**: 
  - `vehicleNumber`: Vehicle registration number
  - `index`: Index in the array
- **Returns**: Violation ID

### Events
- **ViolationLogged(uint256 id, string vehicleNumber, string violationType, uint256 fineAmount)**: Emitted when a violation is logged
- **FinePaid(uint256 id, string vehicleNumber, uint256 amount)**: Emitted when a fine is paid

### Struct
- **Violation**: Contains vehicleNumber, violationType, fineAmount, isPaid, and timestamp

## Deployment and Testing in QRemix IDE

### Step 1: Setup
1. Open qremix.org
2. Create new file named `TrafficViolationTracker.sol`
3. Copy and paste the contract code

### Step 2: Compilation
1. Go to "Solidity Compiler" tab
2. Select compiler version 0.8.20 or higher
3. Click "Compile TrafficViolationTracker.sol"

### Step 3: Deployment

#### For Quranium Testnet:
1. Go to "Deploy & Run Transactions" tab
2. Select "Injected Provider - MetaMask" as environment
3. Ensure MetaMask/QSafe is connected to Quranium Testnet
4. Select "TrafficViolationTracker" from dropdown
5. Click "Deploy"

#### For JavaScript VM (Local Testing):
1. Go to "Deploy & Run Transactions" tab
2. Select "JavaScript VM" as environment
3. Select "TrafficViolationTracker" from dropdown
4. Click "Deploy"

### Step 4: Testing

#### Log Violations (Admin Functions):
1. Use admin account (deployer account)
2. Call `logViolation` with parameters:
   - vehicleNumber: "ABC123"
   - violationType: "Speeding"
   - fineAmount: 1000000000000000000 (1 ETH in wei)
3. Check `violationCount` increases
4. Verify violation details using `getViolationDetails`

#### Pay Fines:
1. Switch to different user account
2. Set Value field to fine amount (e.g., 1 ETH)
3. Call `payFine` with violation ID
4. Verify `isPaid` becomes true in violation details
5. Check contract balance increases

#### Query Functions:
1. Use `getViolationsByVehicle` to get all violations for a vehicle
2. Use `getViolationDetails` to check specific violation
3. Verify violation data is correct

#### Admin Functions:
1. Use admin account to call `withdraw`
2. Verify contract balance becomes 0
3. Check admin account balance increases

## License
This project is licensed under the MIT License. See the `SPDX-License-Identifier: MIT` in the contract files.

## Support
For issues or feature requests:
* Check the QRemix IDE documentation: https://docs.qremix.org
* Consult OpenZeppelin's documentation: docs.openzeppelin.com