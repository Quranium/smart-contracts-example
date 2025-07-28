# SimpleVoting

## Contract Name  
**SimpleVoting**

---

## Overview

The `SimpleVoting` smart contract allows a set of candidates to receive votes from Ethereum users. Each address can **vote only once**, and the voting can be **ended by the contract owner**.

This contract is useful for demonstrating **decentralized governance**, **polling**, or **community decision-making** on the blockchain.

---

## Contract Functions

### `constructor(string[] memory _candidates)`
- **Purpose:** Initializes the list of candidates and sets the deployer as the owner
- **Who Can Call:** Only during deployment
- **Sets:**
  - `owner` = `msg.sender`
  - `candidates` = `_candidates`
  - `votingActive` = `true`

---

### `vote(string memory _candidate) external`
- **Purpose:** Casts a vote for the given candidate
- **Who Can Call:** Any address (once only)
- **Requires:** 
  - Voting must be active  
  - Caller has not voted before  
  - Candidate must be valid

---

### `endVoting() external`
- **Purpose:** Ends the voting session
- **Who Can Call:** Only the owner
- **Effect:** Sets `votingActive` to `false`

---

### `getVotes(string memory _candidate) external view returns (uint256)`
- **Purpose:** Gets the vote count for a specific candidate
- **Who Can Call:** Anyone
- **View Function:** Read-only

---

### `getAllCandidates() external view returns (string[] memory)`
- **Purpose:** Returns the list of all candidates
- **Who Can Call:** Anyone
- **View Function:** Read-only

---

## Access Control

- **Owner:**  
  - Set to the deploying address  
  - Can end the voting session using `endVoting()`

- **Voters:**  
  - Any address can vote once using `vote()`  
  - Voting is disabled once ended

---

## Deployment & Testing on QRemix

### Step 1: Setup
- Open [qremix.org](https://qremix.org)
- Create a new folder: `VotingSystem/`
- Add a new file: `SimpleVoting.sol` and paste the code

### Step 2: Compile
- Go to **Solidity Compiler**
- Select version `0.8.20`
- Click **Compile SimpleVoting.sol**

### Step 3: Deploy

#### Using JavaScript VM
- Go to **Deploy & Run Transactions**
- Select `JavaScript VM`
- Input constructor parameters like: `["Alice", "Bob", "Charlie"]`
- Click **Deploy**

#### Using Quranium Testnet
- Connect MetaMask to Quranium testnet
- Select `Injected Provider - MetaMask`
- Deploy contract with candidate array as constructor input

### Step 4: Testing
- Call `vote("Alice")` from different accounts
- Call `getVotes("Alice")` to verify count
- Call `endVoting()` from owner account
- Try voting again — should be rejected

---

## License

This project is licensed under the MIT License.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

## Support

For issues or feature requests, refer to:  
📘 QRemix IDE Documentation: https://docs.qremix.org
