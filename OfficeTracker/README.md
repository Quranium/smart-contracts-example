# Office Access & Attendance System

## Contract Name
OfficeTracker

## Overview
The Office Access System is a smart contract that manages **employee registration**, **daily attendance check-ins/check-outs**, and **admin controls**. The system ensures that only registered employees can check in/out and keeps a transparent log of office presence.

It is designed to be deployed and tested in the **QRemix IDE** using the JavaScript VM or testnets like Quranium Testnet, Sepolia, etc.

## Prerequisites
To deploy and test the contracts, you need:

* **MetaMask or QSafe**: For connecting to a testnet (optional).
* **Test ETH or QRN**: From a faucet like [sepoliafaucet.com](https://sepoliafaucet.com) or [faucet.quranium.org](https://faucet.quranium.org).
* **QRemix IDE**: Access at [qremix.org](https://qremix.org).
* **Basic Solidity Knowledge**: Familiarity with smart contract deployment and Solidity syntax.

## Contract Details

### OfficeTracker Contract

#### Functions

##### addEmployee(address _employee, string memory _name)
- **Purpose**: Register a new employee.
- **Parameters**:
  - `_employee`: Address of the employee.
  - `_name`: Name of the employee.
- **Access**: Only Owner (Admin)

##### removeEmployee(address _employee)
- **Purpose**: Remove an employee from the system.
- **Parameters**:
  - `_employee`: Address of the employee to remove.
- **Access**: Only Owner (Admin)

##### checkIn()
- **Purpose**: Log employee check-in for the current day.
- **Parameters**: None
- **Access**: Only registered employee, once per day

##### checkOut()
- **Purpose**: Log employee check-out for the current day.
- **Parameters**: None
- **Access**: Only registered employee, once per day

##### isCheckedIn(address _employee, uint256 day)
- **Purpose**: Check if an employee has checked in on a specific day.
- **Returns**: Boolean

##### isCheckedOut(address _employee, uint256 day)
- **Purpose**: Check if an employee has checked out on a specific day.
- **Returns**: Boolean

#### Events
- **EmployeeAdded(address indexed employee, string name)**: Emitted when a new employee is registered.
- **EmployeeRemoved(address indexed employee)**: Emitted when an employee is removed.
- **CheckedIn(address indexed employee, uint256 day)**: Emitted when an employee checks in.
- **CheckedOut(address indexed employee, uint256 day)**: Emitted when an employee checks out.

## Deployment and Testing in QRemix IDE

### Step 1: Setup
1. Open [qremix.org](https://qremix.org)
2. Create a folder named `OfficeSystem/`
3. Create a file `OfficeTracker.sol` inside the folder
4. Paste the contract code into `OfficeTracker.sol`

### Step 2: Compilation
1. Go to the "Solidity Compiler" tab
2. Choose compiler version 0.8.20 or higher
3. Compile the `OfficeTracker.sol` file

### Step 3: Deployment

#### For Quranium Testnet:
1. Go to "Deploy & Run Transactions"
2. Set environment to "Injected Provider - MetaMask"
3. Ensure MetaMask is connected to Quranium Testnet
4. Deploy the `OfficeTracker` contract

#### For JavaScript VM (Local Testing):
1. Go to "Deploy & Run Transactions"
2. Set environment to "JavaScript VM"
3. Deploy the `OfficeTracker` contract

### Step 4: Testing

#### Setup:
1. **Register Employees**: Use `addEmployee` with employee address and name
2. **Check In/Out**:
   - From employee address, call `checkIn` (only once/day)
   - Call `checkOut` (only once/day after check-in)

#### Verification:
1. Use `isCheckedIn` and `isCheckedOut` to confirm attendance
2. Switch accounts to test multiple users
3. Admin-only actions (like `addEmployee`, `removeEmployee`) must fail from non-owner accounts

#### Edge Case Tests:
- Call `checkIn` twice on the same day (should fail)
- Call `checkOut` before `checkIn` (should fail)
- Try `addEmployee` as a non-admin (should fail)

## License
This project is licensed under the MIT License. See `SPDX-License-Identifier: MIT` in the source files.

## Support
For issues or feature requests:
* Check [QRemix IDE documentation](https://docs.qremix.org)
* Refer to OpenZeppelin Contracts [documentation](https://docs.openzeppelin.com/contracts)
