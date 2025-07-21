# DubaiTransportPass

## Overview

The **DubaiTransportPass** is a blockchain-based prepaid transport pass system designed for Dubai's smart mobility network. It allows administrators to issue transport passes to users with an initial balance and validity duration. Users can take rides by deducting fare from their pass balance and recharge when needed. Admins can also suspend/reactivate lost or misused passes.

This contract is written in **Solidity v0.8.20** and provides a minimal but extensible base for real-world urban transit systems.

*They are designed to be deployed and tested in the **QRemix IDE** using the JavaScript VM or a testnet like Quranium testnet, Sepolia etc.*

## Prerequisites

To deploy and test the contracts, you need:

- **MetaMask or QSafe**: Browser extension for testnet deployments (optional).
- **Test ETH or QRN**: Required for testnet deployments (e.g., from a Sepolia faucet like [sepoliafaucet.com](https://sepoliafaucet.com/), Quranium [faucet.quranium.org](https://faucet.quranium.org/)).
- **QRemix IDE**: Access at [https://www.qremix.org/](https://www.qremix.org/)
- **Basic Solidity Knowledge**: Understanding of smart contract deployment, roles, and Remix IDE usage.

## Contract Details

### Key Components

- **Struct `Pass`**:
  - `owner`: Address of the pass holder.
  - `balance`: Current balance of the pass.
  - `issuedAt`: Timestamp when the pass was issued.
  - `expiresAt`: Validity deadline.
  - `isActive`: Boolean flag for active/inactive state.

### State Variables

- `admin`: Address of the contract administrator.
- `baseFare`: Ride fare, default `3 ether` (can be adjusted for tokens later).
- `totalIssued`: Tracks total number of passes issued.
- `passes`: Mapping of `passId` to `Pass` struct.
- `passByOwner`: Maps user addresses to their `passId`.

### Functions

- `constructor()`: Sets the deploying address as `admin`.

- `issuePass(address user, uint256 duration, uint256 initialBalance)`:  
  Admin-only function to issue a new pass.

- `takeRide(uint256 passId)`:  
  Lets the pass owner take a ride by deducting `baseFare`.

- `rechargePass(uint256 passId) payable`:  
  Allows users to add Ether to their pass balance.

- `suspendPass(uint256 passId)`:  
  Admin-only function to suspend a pass (e.g., in case of misuse or loss).

- `reactivatePass(uint256 passId)`:  
  Admin-only function to reactivate suspended, unexpired passes.

- `getPass(uint256 passId) view`:  
  Returns full details of a specific pass.

- `getPassIdByUser(address user) view`:  
  Returns the `passId` linked to the provided user address.

### Events

- `PassIssued`: Emitted when a new pass is issued.
- `RideTaken`: Emitted after a successful ride.
- `PassRecharged`: Emitted when a pass is topped up.
- `PassSuspended`: Emitted when a pass is suspended by the admin.
- `PassReactivated`: Emitted when a suspended pass is re-enabled.

## Deployment and Testing in QRemix IDE (optional)

1. Open [QRemix IDE](https://www.qremix.org/).
2. Paste the contract code into a new Solidity file (e.g., `DubaiTransportPass.sol`).
3. Compile the contract using compiler version `0.8.20`.
4. Navigate to the **Deploy & Run Transactions** tab.
5. Select your environment:
   - **JavaScript VM** for testing locally.
   - **Injected Provider - MetaMask** for testnet deployment.
6. Click **Deploy**.

### Interacting with the contract

1. **Issue a Pass**  
   Call `issuePass(user, duration, initialBalance)` using the admin account.

2. **Take a Ride**  
   Call `takeRide(passId)` as the pass holder.

3. **Recharge Pass**  
   Enter Ether value and call `rechargePass(passId)`.

4. **Suspend / Reactivate**  
   As admin, call `suspendPass(passId)` or `reactivatePass(passId)`.

5. **View Pass**  
   Call `getPass(passId)` or `getPassIdByUser(address)` to retrieve info.

## License

This project is licensed under the MIT License.  
See the `SPDX-License-Identifier: MIT` in the contract file.

## Support

For issues or feature requests:

- Check the QRemix IDE documentation: [https://docs.qremix.org](https://docs.qremix.org)
- Consult OpenZeppelin’s documentation: [https://docs.openzeppelin.com](https://docs.openzeppelin.com)
