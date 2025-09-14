# SkillEndorsement

## Contract Name

**SkillEndorsement**

---

## Overview

The `SkillEndorsement` contract allows on-chain skill claims where users stake ETH to claim a skill (e.g., "solidity" or "ux"). Other users can `endorse` a claim by staking ETH (which increases the claim's reputation) or `challenge` it by staking ETH (which reduces reputation). The contract owner acts as an arbitrator and resolves claims — funds are distributed according to the resolution outcome.

This contract teaches multi-party staking flows, reputation as on-chain escrow, and pull-pattern distributions for pro-rata payouts. It’s suitable for prototyping decentralized reputation or portfolio systems.

---

## Prerequisites

* MetaMask (or other web3 wallet)
* Testnet ETH
* Access to QRemix IDE (or similar Solidity dev environment)
* Basic knowledge of Solidity, mappings, and fallback/pull payout patterns

---

## Contract Functions

### Constructor

```solidity
constructor(uint256 _minClaimStake, uint256 _minEndorseStake, uint256 _minChallengeStake)
```

* **Purpose:** Initialize contract with minimum stake thresholds and set deployer as owner.
* **Access:** Called on deployment.

---

### claimSkill

```solidity
claimSkill(string skill) payable → uint256
```

* **Purpose:** Create a new skill claim by staking ETH.
* **Access:** Any address.
* **Conditions:** `msg.value >= minClaimStake`
* **Returns:** `claimId` (uint256)
* **Emits:** `ClaimCreated`

---

### endorse

```solidity
endorse(uint256 claimId) payable
```

* **Purpose:** Endorse an existing claim by staking ETH (increases endorsements).
* **Access:** Any address.
* **Conditions:** `msg.value >= minEndorseStake`
* **Emits:** `Endorsed`

---

### challenge

```solidity
challenge(uint256 claimId) payable
```

* **Purpose:** Challenge an existing claim by staking ETH (increases challenges).
* **Access:** Any address.
* **Conditions:** `msg.value >= minChallengeStake`
* **Emits:** `Challenged`

---

### resolveClaim

```solidity
resolveClaim(uint256 claimId, bool validated)
```

* **Purpose:** Owner/arbitrator resolves an active claim (valid or invalid) and triggers distribution logic.
* **Access:** Only contract owner.
* **Notes:** Distributes endorsements/challenges/claimer stake according to example policy.
* **Emits:** `ClaimResolved`

---

### withdrawEndorserShare

```solidity
withdrawEndorserShare(uint256 claimId)
```

* **Purpose:** Endorsers claim their pro-rata payout after resolution.
* **Access:** Endorsers who contributed to claim.

---

### withdrawChallengerShare

```solidity
withdrawChallengerShare(uint256 claimId)
```

* **Purpose:** Challengers claim their pro-rata payout after rejection resolution.
* **Access:** Challengers who contributed to claim.

---

### ownerWithdraw

```solidity
ownerWithdraw(uint256 amount)
```

* **Purpose:** Owner withdraws accumulated platform fees kept in contract.
* **Access:** Only owner.

---

## Access Control

* **Owner (Deployer):** Arbitration power (resolve claims), can withdraw platform fees.
* **Claimers:** Start claims by staking ETH.
* **Endorsers / Challengers:** Stake ETH to endorse/challenge. Use pull-pattern to withdraw pro-rata shares after resolution.

---

## Deployment & Testing on QRemix

### Step 1: Setup

* Open [qremix.org](https://qremix.org)
* Create folder: `SkillEndorsement/`
* Add `SkillEndorsement.sol` and paste the contract code.

### Step 2: Compile

* Go to Solidity Compiler
* Select version `0.8.19` (or compatible)
* Compile the contract

### Step 3: Deploy

* Deploy with constructor args (min stakes as wei), e.g., `10000000000000000` (0.01 ETH) etc.

### Step 4: Testing Flow

1. Alice calls `claimSkill("solidity")` with `msg.value = minClaimStake`. Note `claimId`.
2. Bob calls `endorse(claimId)` with `msg.value >= minEndorseStake`.
3. Carol calls `challenge(claimId)` with `msg.value >= minChallengeStake`.
4. Owner reviews evidence off-chain and calls `resolveClaim(claimId, true/false)`.
5. Endorsers/challengers call `withdrawEndorserShare` or `withdrawChallengerShare` respectively to claim their pro-rata share.

---

## Security Notes & Recommendations

* Owner-based arbitration is centralized; replace with multisig/DAO in production.
* To make distribution transparent and gas-efficient for large contributor sets, consider an ERC20 reward token or off-chain merkle payout with on-chain claim.
* Carefully test edge cases: zero endorsers/challengers, re-entrancy (pull pattern used), rounding issues in pro-rata arithmetic.
* Consider adding evidence storage (IPFS hash) for claims and disputes.

