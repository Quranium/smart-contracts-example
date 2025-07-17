# SimpleVault

## Overview

The **SimpleVault** smart contract provides a minimal and secure ETH vault mechanism.  
It allows **anyone to deposit ETH**, while **only the contract owner** (using OpenZeppelin's `Ownable`) can **withdraw** funds.

Ideal for:
- Owner-controlled wallets
- Crowdfunding contracts with manual withdrawal
- Secure ETH holding vaults with restricted access

> Designed for use with **QRemix IDE**, or deployments on testnets like **Sepolia**, **Quranium**, etc.

---

## Prerequisites

To deploy and test the contract, you’ll need:

- **MetaMask or QSafe**: For testnet interactions (optional).
- **Test ETH**: Use from [sepoliafaucet.com](https://sepoliafaucet.com) or [faucet.quranium.org](https://faucet.quranium.org).
- **QRemix IDE**: Visit [https://www.qremix.org](https://www.qremix.org)
- **Basic Solidity Knowledge**: Understanding `Ownable`, `receive`, `payable`, and access control.

---

## Contract Details

### Inheritance

- Inherits from `Ownable` in OpenZeppelin’s access control system.
- Grants the deployer exclusive access to `withdraw()`.

---

### State Variables

- `totalBalance`: Tracks total ETH deposited (for informational purposes).

---

### Functions

- `receive()` (external, payable):
  - Automatically triggered on plain ETH transfers.
  - Increases `totalBalance`.
  - Emits `Deposited`.

- `withdraw(uint256 amount)`:
  - Allows the `owner()` to withdraw a specified amount.
  - Transfers ETH directly to the owner’s address.
  - Emits `Withdrawn`.

- `getBalance()`:
  - Returns the contract’s current ETH balance.

---

### Events

- `Deposited(address sender, uint256 amount)`: Logged on ETH deposit.
- `Withdrawn(address to, uint256 amount)`: Logged on withdrawal by owner.

---

## Deployment and Testing in QRemix IDE

1. Open [QRemix IDE](https://www.qremix.org).
2. Create a file named `SimpleVault.sol`.
3. Paste the smart contract code.
4. Compile with Solidity version `0.8.20`.
5. Under **Deploy & Run Transactions**:
   - Choose **JavaScript VM** or **Injected Provider (MetaMask)**.
   - Click **Deploy**.

> ⚠️ Note: External imports (like OpenZeppelin’s `Ownable.sol`) **won’t work** in Remix without a plugin like Remixd or by copy-pasting the dependency manually.

---

## Sample Interaction Flow

1. **Deposit ETH**  
   Send ETH directly to the contract (via Remix or wallet) to trigger the `receive()` function.

2. **View Balance**  
   Call `getBalance()` to check the contract’s balance.

3. **Withdraw ETH (Owner Only)**  
   As the contract owner, call `withdraw(1 ether)` to withdraw ETH.

---

## License

This project is licensed under the MIT License.  
See the `SPDX-License-Identifier: MIT` declaration in the contract.

---

## Support

For development tools and security guidelines:

- OpenZeppelin Documentation: [https://docs.openzeppelin.com](https://docs.openzeppelin.com)
- QRemix Docs: [https://docs.qremix.org](https://docs.qremix.org)
