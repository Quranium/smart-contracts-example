# 🦄 Simple DEX with ERC20 Token

This project contains two smart contracts:

1. `BasicToken.sol` – a minimal ERC20-compliant token.
2. `DEX.sol` – a simple decentralized exchange contract that enables users to:
   - Add and remove liquidity
   - Swap ETH for tokens and vice versa

---

## 📦 Contracts Overview

### 1. BasicToken.sol

An ERC20-compatible token with:

- `name`, `symbol`, `decimals`, `totalSupply`
- Standard functions: `transfer`, `approve`, `transferFrom`, `allowance`
- Events: `Transfer`, `Approval`

#### Example

```solidity
BasicToken token = new BasicToken("TestToken", "TT", 1000000 ether);
```

### 2. DEX.sol

A basic decentralized exchange using the constant product formula ``` (x * y = k)``` to support token/ETH swaps and liquidity provisioning.

Constructor
```
constructor(address _token);
```
Deploy by passing the address of your deployed ERC20 token.

### 🔧 Key Features

Function	Description

```addLiquidity(uint tokenAmount)``` : 	Deposit ETH and tokens to the pool. Mints proportional liquidity.

```removeLiquidity(uint liquidityAmount)``` :	Withdraws ETH and tokens based on share.

```swapEthToToken()``` :	Converts ETH into tokens using AMM logic.

```swapTokenToEth(uint tokenAmount)``` :	Converts tokens into ETH using AMM logic.

```getAmountOfTokens(inputAmount, inputReserve, outputReserve)``` :	Returns output amount after 1% fee.

```getTokensInContract()``` : 	Returns token reserve of the DEX.

### 🚀 Deployment Guide
1. Deploy BasicToken
```
BasicToken token = new BasicToken("TestToken", "TT", 1000000 ether);
```
2. Deploy DEX Contract
```
DEX dex = new DEX(address(token));
```
### 💡 Usage Example
✅ Add Liquidity (Initial)

```
token.approve(address(dex), 5000 ether);
dex.addLiquidity{value: 1 ether}(5000 ether);
```

🔄 Swap ETH → Token
```
dex.swapEthToToken{value: 0.1 ether}();
```
🔄 Swap Token → ETH
```
token.approve(address(dex), 100 ether);
dex.swapTokenToEth(100 ether);
```
❌ Remove Liquidity
```
dex.removeLiquidity(100); // burns 100 units of liquidity share
```
⚙️ Under the Hood

- Liquidity is tracked via a mapping: ```mapping(address => uint256) public liquidity```

- DEX charges a 1% fee on swaps

AMM formula used:

```output = (input * 99 / 100) * outputReserve / (inputReserve * 100 + input * 99 / 100)```

### 🛡️ Security Notes

- This is an educational project and not production-ready. Known limitations:
- No reentrancy protection (nonReentrant)
- LP tokens are not transferable (no ERC20 liquidity token)
- No slippage/tolerance handling
- No admin functions or emergency controls
