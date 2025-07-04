# Ticket System

## Contract Name
VotingManager & VotingTicket

## Overview
The Voting System consists of two smart contracts: VotingTicket (ERC-like voting ticket system) and VotingManager (controls ticket issuing process). The system allows users to claim voting tickets and enables admin to manage the voting process. The contracts utilize **OpenZeppelin** compatible patterns for secure access control and ticket management.

*They are designed to be deployed and tested in the **QRemix IDE** using the JavaScript VM or a testnet like Quranium testnet, Sepolia etc.*

## Prerequisites
To deploy and test the contracts, you need:

* **MetaMask or QSafe**: Browser extension for testnet deployments (optional).
* **Test ETH or QRN**: Required for testnet deployments (e.g., from a Sepolia faucet like sepoliafaucet.com, Quranium faucet.quranium.org).
* **QRemix IDE**: Access at qremix.org.
* **Basic Solidity Knowledge**: Understanding of ERC20 tokens, smart contract deployment, and Remix IDE.

## Contract Details

### VotingTicket Contract

#### Functions

##### issueTicket(address user)
- **Purpose**: Issue a voting ticket to a user
- **Parameters**: 
  - `user`: Address to receive the ticket
- **Access**: Anyone (but user can only claim once)

##### invalidateTicket(address user)
- **Purpose**: Invalidate a user's voting ticket
- **Parameters**: 
  - `user`: Address whose ticket to invalidate
- **Access**: Anyone

##### hasValidTicket(address user)
- **Purpose**: Check if a user has a valid voting ticket
- **Parameters**: 
  - `user`: Address to check
- **Returns**: Boolean indicating if user has valid ticket

##### hasTicket(address user)
- **Purpose**: Check if a user has claimed a ticket
- **Parameters**: 
  - `user`: Address to check
- **Returns**: Boolean indicating if user has a ticket

##### isValid(address user)
- **Purpose**: Check if a user's ticket is valid
- **Parameters**: 
  - `user`: Address to check
- **Returns**: Boolean indicating if ticket is valid

#### Events
- **TicketClaimed(address indexed user)**: Emitted when a ticket is claimed
- **TicketInvalidated(address indexed user)**: Emitted when a ticket is invalidated

### VotingManager Contract

#### Functions

##### setAdmin(address _admin)
- **Purpose**: Set the admin address (can only be done once)
- **Parameters**: 
  - `_admin`: Address to set as admin
- **Access**: Anyone (but only once)

##### setTicketContract(address _contract)
- **Purpose**: Set the voting ticket contract address
- **Parameters**: 
  - `_contract`: Address of the VotingTicket contract
- **Access**: Only admin

##### claimTicket()
- **Purpose**: Claim a voting ticket (one per address)
- **Parameters**: None
- **Access**: Anyone (but only once per address)

##### invalidateUser(address user)
- **Purpose**: Invalidate a user's voting ticket
- **Parameters**: 
  - `user`: Address whose ticket to invalidate
- **Access**: Only admin

##### hasClaimed(address user)
- **Purpose**: Check if a user has claimed a ticket through the manager
- **Parameters**: 
  - `user`: Address to check
- **Returns**: Boolean indicating if user has claimed

## Deployment and Testing in QRemix IDE

### Step 1: Setup
1. Open qremix.org
2. Create folder structure: `TicketSystem/`
3. Create `VotingTicket.sol` in the TicketSystem folder
4. Create `VotingManager.sol` in the root directory
5. Copy and paste the respective contract codes

### Step 2: Compilation
1. Go to "Solidity Compiler" tab
2. Select compiler version 0.8.20 or higher
3. Compile `VotingTicket.sol` first
4. Then compile `VotingManager.sol`

### Step 3: Deployment

#### For Quranium Testnet:
1. Go to "Deploy & Run Transactions" tab
2. Select "Injected Provider - MetaMask" as environment
3. Ensure MetaMask/QSafe is connected to Quranium Testnet
4. Deploy `VotingTicket` contract first
5. Deploy `VotingManager` contract

#### For JavaScript VM (Local Testing):
1. Go to "Deploy & Run Transactions" tab
2. Select "JavaScript VM" as environment
3. Deploy `VotingTicket` contract first
4. Deploy `VotingManager` contract

### Step 4: Testing

#### Setup System:
1. **Set Admin**: Call `setAdmin` with an admin address
2. **Set Ticket Contract**: Call `setTicketContract` with VotingTicket contract address

#### Test Ticket Claims:
1. Switch to different user addresses
2. Call `claimTicket` from user addresses
3. Verify `hasClaimed` returns true for users
4. Check `hasValidTicket` on VotingTicket contract

#### Test Admin Functions:
1. Switch to admin address
2. Call `invalidateUser` with a user address
3. Verify ticket is invalidated using `hasValidTicket`
4. Check events are emitted properly

#### Test Restrictions:
1. Try claiming ticket twice from same address (should fail)
2. Try setting admin twice (should fail)
3. Try admin functions from non-admin address (should fail)

## License
This project is licensed under the MIT License. See the `SPDX-License-Identifier: MIT` in the contract files.

## Support
For issues or feature requests:
* Check the QRemix IDE documentation: https://docs.qremix.org
* Consult OpenZeppelin's documentation: docs.openzeppelin.com