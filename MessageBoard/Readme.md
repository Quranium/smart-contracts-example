### 📄 `README.md`

````markdown
# 🗒️ MessageBoard Smart Contract

A simple public message board smart contract written in pure Solidity, without using any external libraries or constructors.

## ✨ Features

- Post any string message to the blockchain
- View individual messages by index
- Retrieve the full list of messages
- Clean, constructor-free design

## 🛠️ Contract Overview

```solidity
function postMessage(string calldata message) external
````

Stores a message posted by the caller.

```solidity
function getMessage(uint256 index) external view returns (string memory)
```

Returns the message at the given index.

```solidity
function getAllMessages() external view returns (string[] memory)
```

Returns all messages ever posted.

