# SimpleCoinTransfer Contract

## Contract Name
SimpleCoinTransfer

## Overview
SimpleCoinTransfer is a minimal smart contract that allows users to send Ether to other addresses while maintaining internal balance tracking. This contract demonstrates basic Ether handling, balance management, and secure transfer mechanisms. The contract follows best practices and utilizes secure patterns similar to those found in **OpenZeppelin** libraries for safe Ether transfers.
*They are designed to be deployed and tested in the **QRemix IDE** using the JavaScript VM or a testnet like Quranium testnet, Sepolia etc.*

## Prerequisites

To deploy and test the contracts, you need:
* **MetaMask or QSafe**: Browser extension for testnet deployments (optional).
* **Test ETH or QRN**: Required for testnet deployments (e.g., from a Sepolia faucet like sepoliafaucet.com, Quranium faucet.quranium.org).
* **QRemix IDE**: Access at qremix.org.

* **Basic Solidity Knowledge**: Understanding of ERC20 tokens, smart contract deployment, and Remix IDE.

## Contract Details

### State Variables
- **internalBalance**: `mapping(address => uint256)` - Tracks internal balance of each address

### Main Functions

#### Constructor

- **Purpose**: No explicit constructor - uses default constructor
- **Parameters**: None
- **Initialization**: Contract starts with empty balances
#### Receive Function

- **Function**: `receive() external payable`
- **Purpose**: Accepts Ether deposits and updates sender's internal balance
- **Parameters**: None (receives msg.value automatically)
- **Access**: Anyone can send Ether to the contract
- **Behavior**: Automatically adds sent Ether to sender's internal balance
#### Public Functions
##### sendCoin
- **Function**: `sendCoin(address payable to, uint256 amount)`
- **Purpose**: Send coins from sender to recipient if balance is sufficient
- **Parameters**:
  - `to`: The recipient address (must be payable)
  - `amount`: Amount to send in wei
- **Returns**: None
- **Access**: Any address with sufficient internal balance
- **Requirements**:
  - Recipient address must not be zero address
  - Sender must have sufficient internal balance
- **Behavior**:
  - Deducts amount from sender's internal balance
  - Adds amount to recipient's internal balance
  - Transfers actual Ether to recipient
  - Emits CoinSent event
#### View Functions
##### getContractBalance
- **Function**: `getContractBalance()`
- **Purpose**: Returns the total Ether held by the contract
- **Parameters**: None
- **Returns**: `uint256` - Contract's total Ether balance in wei
- **Access**: Public view function
##### myBalance
- **Function**: `myBalance()`
- **Purpose**: Returns the caller's internal balance
- **Parameters**: None
- **Returns**: `uint256` - Caller's internal balance in wei
- **Access**: Public view function
##### internalBalance
- **Function**: `internalBalance(address)`
- **Purpose**: Returns the internal balance of any address
- **Parameters**: `address` - The address to check
- **Returns**: `uint256` - Internal balance of the specified address
- **Access**: Public view function
### Events
- **CoinSent**: `CoinSent(address indexed from, address indexed to, uint256 amount)`
  - **Purpose**: Emitted when coins are successfully sent between addresses
  - **Parameters**:
    - `from`: Sender address
    - `to`: Recipient address
    - `amount`: Amount transferred
- **CoinReceived**: `CoinReceived(address indexed from, uint256 amount)`
  - **Purpose**: Emitted when the contract receives Ether
  - **Parameters**:
    - `from`: Address that sent Ether
    - `amount`: Amount received