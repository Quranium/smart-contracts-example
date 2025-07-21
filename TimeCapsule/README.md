# TimeCapsule

## Overview

The **TimeCapsule** smart contract enables users to create digital capsules that store ETH and/or a secret message, which can only be opened after a specified future timestamp.

It simulates a digital time capsule, making it ideal for:
- **Delayed ETH gifting**
- **Time-based trustless interactions**
- **Future note/memory reveal**

Each capsule is uniquely linked to its creator, contains a hidden message, an unlock timestamp, and optional ETH. Only the creator can open it after the unlock time.

> This contract is best deployed and tested in the **QRemix IDE** or on testnets like **Quranium**, **Sepolia**, etc.

---

## Prerequisites

To deploy and test the contract, you’ll need:

- **MetaMask or QSafe**: For testnet deployments (optional).
- **Test ETH or QRN**: For testnet deployment (e.g., [sepoliafaucet.com](https://sepoliafaucet.com), [faucet.quranium.org](https://faucet.quranium.org)).
- **QRemix IDE**: Visit [https://www.qremix.org](https://www.qremix.org)
- **Solidity Basics**: Understanding of structs, mappings, and msg.sender/value is recommended.

---

## Contract Details

### Structs

- `Capsule`:
  - `creator`: Address who created the capsule.
  - `unlockTime`: Timestamp when the capsule can be opened.
  - `message`: Secret message stored.
  - `amount`: ETH stored in the capsule.
  - `opened`: Whether the capsule has been opened.

---

### State Variables

- `capsuleCount`: Total number of created capsules.
- `capsules`: Maps a unique capsule ID to a `Capsule`.

---

### Functions

- `createCapsule(uint256 _unlockTime, string _message)`:
  - Creates a new capsule with optional ETH.
  - Requires unlock time to be in the future.
  - Emits `CapsuleCreated`.

- `openCapsule(uint256 _capsuleId)`:
  - Allows the creator to open the capsule after the unlock time.
  - Transfers ETH if present.
  - Emits `CapsuleOpened`.

- `viewCapsule(uint256 _capsuleId)`:
  - Returns capsule details.
  - Hides the message if caller is not creator and capsule isn’t opened.

---

### Events

- `CapsuleCreated`: Emitted on new capsule creation.
- `CapsuleOpened`: Emitted when a capsule is opened.

---

## Deployment and Testing in QRemix IDE (optional)

1. Visit [QRemix IDE](https://www.qremix.org/).
2. Paste the smart contract into a new file, e.g., `TimeCapsule.sol`.
3. Compile with Solidity version `0.8.20`.
4. Under the **Deploy & Run Transactions** tab:
   - Select **JavaScript VM** or **Injected Provider (MetaMask)**.
   - Click **Deploy**.

---

## Sample Interaction Flow

1. **Create a Capsule**  
   Call `createCapsule(futureTimestamp, "Hello Future!")` and send optional ETH.

2. **View Capsule**  
   Call `viewCapsule(0)` to inspect metadata. Message is hidden unless caller is creator or it's opened.

3. **Open Capsule**  
   After the unlock time, call `openCapsule(0)` to reveal the message and withdraw ETH.

---

## License

This project is licensed under the MIT License.  
See the `SPDX-License-Identifier: MIT` in the contract file.

---

## Support

For questions, improvements, or integration help:

- QRemix Documentation: [https://docs.qremix.org](https://docs.qremix.org)
- OpenZeppelin Docs: [https://docs.openzeppelin.com](https://docs.openzeppelin.com)
