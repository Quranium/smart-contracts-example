# DecentralizedTalentShow

## Contract Name

**DecentralizedTalentShow**

---

## Overview

The `DecentralizedTalentShow` contract runs multiple talent contests where creators submit entries (IPFS hashes) and the community votes by sending ETH (micro-fees). Each contest has a start and end block. Votes accumulate in the contest `prizePool`. After the contest ends, anyone can `finalizeContest` — the highest-voted submission receives the prize pool minus a platform fee (owner fee). This contract is great for experimenting with pay-to-vote mechanics, on-chain prize distribution, and contest lifecycle management.

---

## Prerequisites

* MetaMask (or other web3 wallet)
* Testnet ETH
* Access to QRemix IDE (or any Solidity environment)
* Familiarity with block numbers vs timestamps and IPFS usage

---

## Contract Functions

### Constructor

```solidity
constructor(uint256 _platformFeeBps)
```

* **Purpose:** Set initial platform fee (basis points) and owner.
* **Access:** Called at deployment.

---

### createContest

```solidity
createContest(string title, uint256 startBlock, uint256 endBlock) → uint256
```

* **Purpose:** Owner creates a new contest with timeframe.
* **Access:** Only owner.
* **Returns:** contestId (uint256)
* **Emits:** `ContestCreated`

---

### submitEntry

```solidity
submitEntry(uint256 contestId, string ipfsHash)
```

* **Purpose:** Submit an entry (IPFS content pointer) during contest active window.
* **Access:** Any address (creator).
* **Emits:** `SubmissionAdded`

---

### vote

```solidity
vote(uint256 contestId, uint256 submissionId) payable
```

* **Purpose:** Vote for a submission by paying ETH. Vote weight equals `msg.value`.
* **Access:** Any address.
* **Conditions:** Each address can vote **once per submission** (but may vote for other submissions).
* **Emits:** `Voted`

---

### finalizeContest

```solidity
finalizeContest(uint256 contestId)
```

* **Purpose:** Finalize contest after `endBlock`. Winner is the submission with highest `votes`. Prize distribution: `payout = prizePool - ownerFee`. Platform owner receives `ownerFee`.
* **Access:** Anyone (after contest ends).
* **Emits:** `ContestFinalized`

---

### getContest

```solidity
getContest(uint256 contestId) → (title, startBlock, endBlock, submissionCount, prizePool, finalized, winningSubmissionId)
```

* **Purpose:** Get contest metadata and status.

---

### getSubmission

```solidity
getSubmission(uint256 contestId, uint256 submissionId) → (creator, ipfsHash, votes, active)
```

* **Purpose:** Get submission metadata.

---

### setPlatformFee

```solidity
setPlatformFee(uint256 bps)
```

* **Purpose:** Update platform fee (basis points).
* **Access:** Only owner.
* **Condition:** Max enforced (e.g., <= 2000 bps = 20%).

---

### ownerWithdraw

```solidity
ownerWithdraw(uint256 amount)
```

* **Purpose:** Withdraw stuck or leftover ETH.
* **Access:** Only owner.

---

## Access Control

* **Owner (Deployer):** Create contests, change platform fee, withdraw stuck funds.
* **Creators:** Submit entries to contests within active windows.
* **Voters:** Vote by sending ETH and are prevented from double-voting the same submission.

---

## Deployment & Testing on QRemix

### Step 1: Setup

* Open [qremix.org](https://qremix.org)
* Create folder: `DecentralizedTalentShow/`
* Add `DecentralizedTalentShow.sol` and paste the contract code.

### Step 2: Compile

* Go to Solidity Compiler
* Select version `0.8.19` (or compatible)
* Compile the contract

### Step 3: Deploy

* Deploy with arg `platformFeeBps` (e.g., `500` for 5%)

### Step 4: Testing Flow

1. Owner calls `createContest("Summer Jam", startBlock, endBlock)`.
2. Users call `submitEntry(contestId, "<ipfsHash>")` during active window.
3. Voters call `vote(contestId, submissionId)` sending small ETH amounts; each voter can vote once per submission.
4. After `endBlock`, anyone calls `finalizeContest(contestId)`. Winner receives prize pool minus owner fee; owner receives fee.

---

## Security Notes & Recommendations

* Double-vote prevention is per-submission per-address. If you want stricter controls (one vote per contest per address), change the mapping accordingly.
* Using `block.number` for time windows is deterministic but dependent on chain block time; optionally use `block.timestamp` if you prefer wall-clock times.
* `call` is used for transfers — watch for reentrancy. Functions that trigger external calls do not update critical state afterwards (checks-effects-interactions used).
* Gas: iterating submissions to find winners is O(n); be cautious of contests with many submissions. Consider off-chain tallying + merkle proof verification for very large contests.


