# DecentralizedTodoList

## Contract Name

**DecentralizedTodoList**

---

## Overview

The `DecentralizedTodoList` contract allows users to create and manage personal to-do lists directly on-chain. Each user can add tasks with descriptions, mark them as completed, and fetch their full task list.

This contract is ideal for learning how to work with dynamic data structures in Solidity (`structs` and `mappings`) and for building simple dApps where persistent personal data storage is required.

---

## Prerequisites

* MetaMask or QSafe (for testnet deployment)
* Testnet ETH or QRN
* Access to QRemix IDE (or any Solidity dev environment)
* Basic knowledge of Solidity, structs, and arrays

---

## Contract Functions

### createTask

```solidity
createTask(string description)
```

* **Purpose:** Add a new task to the sender’s personal task list.
* **Access:** Any address.
* **Emits:** `TaskCreated` event.

---

### completeTask

```solidity
completeTask(uint taskId)
```

* **Purpose:** Mark a task as completed.
* **Access:** Only the task owner.
* **Condition:** Task must exist and not already be completed.
* **Emits:** `TaskCompleted` event.

---

### getMyTasks

```solidity
getMyTasks() → Task[]
```

* **Purpose:** Retrieve the full list of tasks (description + completion status) for the caller.
* **Access:** Only the task owner.

---

## Access Control

* **Users:** Each address can manage their own tasks independently.
* **No Owner Role:** The contract is fully self-service; no admin or central authority.

---

## Deployment & Testing on QRemix

### Step 1: Setup

* Open [qremix.org](https://qremix.org)
* Create folder: `DecentralizedTodoList/`
* Add `DecentralizedTodoList.sol` and paste the contract code.

### Step 2: Compile

* Go to Solidity Compiler
* Select version `0.8.19` (or compatible)
* Compile the contract

### Step 3: Deploy

* Deploy directly (no constructor args).

### Step 4: Testing Flow

1. Call `createTask("Buy groceries")`.
2. Call `createTask("Finish Solidity project")`.
3. Call `getMyTasks()` to fetch tasks.
4. Call `completeTask(0)` to mark the first task as completed.
5. Call `getMyTasks()` again to verify completion.

---

## Security Notes & Recommendations

* Each user only manages their own tasks (isolated mapping).
* No access for others to modify another user’s tasks.
* Be aware that storing large strings on-chain is costly — use short descriptions.
* For real-world apps, consider off-chain storage (IPFS/Arweave) with on-chain task references.
