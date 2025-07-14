# SimpleCoinTransfer

---

### Contract Name  
**SimpleCoinTransfer**

---

### Overview

The **SimpleCoinTransfer** smart contract is a minimal Ether transfer system that allows users to deposit, store, and send Ether to other addresses. This contract maintains internal balance tracking while enabling secure peer-to-peer Ether transfers.

The system supports Ether deposits through the receive function, internal balance management, and secure transfers to other addresses with comprehensive event logging for transaction transparency.

Perfect for learning smart contract development, peer-to-peer payment systems, simple wallet applications, or educational blockchain projects demonstrating basic Ether handling.

---

### Prerequisites

- MetaMask or compatible Web3 wallet
- ETH or testnet tokens (for transactions and gas fees)
- Remix IDE or similar development environment
- Basic understanding of smart contract interactions

---

### Contract Functions

#### receive

```solidity
receive() external payable
```
- **Purpose:** Accepts Ether deposits and updates internal balance
- **Access:** Any address can send Ether
- **Automatic:** Triggered when Ether is sent to contract address
- **Effect:** Increases sender's internal balance by deposited amount

#### sendCoin

```solidity
sendCoin(address payable to, uint256 amount) external
```
- **Purpose:** Sends Ether from sender to recipient
- **Access:** Any address with sufficient balance
- **Parameters:** 
  - `to` - recipient address (must be payable)
  - `amount` - amount to send in wei
- **Requirements:** Valid recipient address, sufficient internal balance

#### getContractBalance

```solidity
getContractBalance() external view returns (uint256)
```
- **Purpose:** Returns total Ether held by the contract
- **Access:** Public read-only
- **Returns:** Contract's total Ether balance in wei

#### myBalance

```solidity
myBalance() external view returns (uint256)
```
- **Purpose:** Returns caller's internal balance
- **Access:** Public read-only
- **Returns:** Caller's internal balance in wei

---

### Access Control

This contract implements open access control:

- **Deposit Functions**: `receive()` - anyone can deposit
- **Transfer Functions**: `sendCoin()` - anyone with balance can send
- **View Functions**: `getContractBalance()`, `myBalance()` - public read access

> No admin controls - fully decentralized system.

---

### Contract State

#### Storage Variables
- `internalBalance`: Mapping of user addresses to their internal balances

#### Data Flow
1. **Deposit**: Ether sent to contract → Internal balance updated
2. **Transfer**: Internal balance decreased → Recipient balance increased → Ether sent
3. **Balance Check**: Query internal balance or contract total

---

### Events

- `CoinReceived`: Emitted when Ether is deposited
- `CoinSent`: Emitted when Ether is transferred between users

---

### Deployment & Testing

#### Step 1: Setup
- Open [remix.ethereum.org](https://remix.ethereum.org)
- Create folder: `SimpleCoinTransfer/`
- Add `SimpleCoinTransfer.sol` and paste the contract code

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

1. **Deposit Ether:**
   ```solidity
   // Send 0.1 ETH to contract (triggers receive function)
   // In Remix: Use "Low level interactions" section
   // Send 100000000000000000 wei to contract address
   
   // Check your balance
   myBalance(); // Returns 100000000000000000
   ```

2. **Transfer Ether:**
   ```solidity
   // Send 0.05 ETH to another address
   sendCoin(recipientAddress, 50000000000000000);
   
   // Check updated balance
   myBalance(); // Returns 50000000000000000
   ```

3. **Check Contract Status:**
   ```solidity
   // Check total contract balance
   getContractBalance(); // Returns total ETH in contract
   
   // Check specific user balance
   internalBalance[userAddress]; // Direct mapping access
   ```

---

### Example Usage

```solidity
// Deploy contract
SimpleCoinTransfer coinTransfer = new SimpleCoinTransfer();

// User deposits 1 ETH
coinTransfer.send{value: 1 ether}("");

// Check user's balance
uint256 balance = coinTransfer.myBalance(); // Returns 1 ether

// Send 0.3 ETH to another user
coinTransfer.sendCoin(payable(recipientAddress), 0.3 ether);

// Check remaining balance
balance = coinTransfer.myBalance(); // Returns 0.7 ether
```

---

### Transaction Flow

#### Deposit Process
1. **User** sends Ether to contract address
2. **receive()** function automatically triggered
3. **Internal balance** updated for sender
4. **CoinReceived** event emitted

#### Transfer Process
1. **Sender** calls sendCoin() with recipient and amount
2. **Balance validation** ensures sufficient funds
3. **Internal balances** updated (sender decreased, recipient increased)
4. **Ether transfer** executed to recipient
5. **CoinSent** event emitted

---

### Use Cases

#### Personal Finance
- **Digital Wallet**: Simple Ether storage and transfer
- **Savings Account**: Deposit and withdraw Ether
- **Allowance System**: Parents funding children's accounts
- **Expense Splitting**: Group expense management

#### Business Applications
- **Payroll System**: Distribute payments to employees
- **Vendor Payments**: Pay suppliers and contractors
- **Micro-transactions**: Small value transfers
- **Tip/Donation System**: Receive and distribute tips

#### Educational Uses
- **Blockchain Learning**: Understand Ether handling
- **Smart Contract Basics**: Learn contract interactions
- **Transaction Flow**: Understand deposit/transfer mechanics
- **Event Logging**: Learn about blockchain events

---

### Security Considerations

- **Balance Tracking**: Internal balance prevents double-spending
- **Transfer Validation**: Checks recipient address and balance
- **Reentrancy Protection**: Uses checks-effects-interactions pattern
- **Failed Transfer Handling**: Reverts on transfer failure
- **No Admin Functions**: Decentralized system without central control

---

### Integration Examples

#### Web3 Frontend Integration
```javascript
// Deposit Ether
const depositTx = await signer.sendTransaction({
    to: contractAddress,
    value: ethers.utils.parseEther("0.1")
});

// Send coins
const sendTx = await contract.sendCoin(
    recipientAddress,
    ethers.utils.parseEther("0.05")
);

// Check balance
const balance = await contract.myBalance();
console.log(`Balance: ${ethers.utils.formatEther(balance)} ETH`);
```

#### Event Monitoring
```javascript
// Listen for deposits
contract.on("CoinReceived", (from, amount) => {
    console.log(`${from} deposited ${ethers.utils.formatEther(amount)} ETH`);
});

// Listen for transfers
contract.on("CoinSent", (from, to, amount) => {
    console.log(`${from} sent ${ethers.utils.formatEther(amount)} ETH to ${to}`);
});
```

#### Balance Monitoring
```javascript
// Check user balance
const userBalance = await contract.myBalance();

// Check contract total
const contractBalance = await contract.getContractBalance();

// Check specific user balance
const specificBalance = await contract.internalBalance(userAddress);
```

---

### Error Handling

Common error scenarios and solutions:

- **"Invalid address"**: Ensure recipient address is not zero address
- **"Insufficient balance"**: Check sender has enough internal balance
- **"Transfer failed"**: Recipient contract may have rejected transfer
- **Gas estimation failed**: Ensure sufficient gas for transfer

---

### Gas Optimization

- **Batch Transfers**: Consider implementing multiple transfers in one transaction
- **Balance Queries**: Use view functions to check balances without gas cost
- **Event Filtering**: Use indexed parameters for efficient event filtering

---

### License

This project is licensed under the MIT License.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

### Support

For help, improvements, or bug reports:
- Remix IDE Docs: https://remix-ide.readthedocs.io
- Solidity Documentation: https://docs.soliditylang.org
- Ethereum Development: https://ethereum.org/en/developers/

---

