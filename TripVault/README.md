# SimpleTrip

## Overview

The **SimpleTrip** smart contract enables a single user (the contract owner) to save and retrieve trip information including the trip's name, destination, and date (in UNIX timestamp format).

This is useful for:
- Personal itinerary logging
- Decentralized trip/event records
- Building travel-based dApps with a simple on-chain structure

> Designed for testing and deployment in **QRemix IDE** or on Ethereum-compatible testnets like **Sepolia** or **Quranium**.

---

## Prerequisites

To deploy and interact with this contract, you’ll need:

- **MetaMask or QSafe**: For interacting with testnets (optional).
- **QRemix IDE**: Visit [https://www.qremix.org](https://www.qremix.org)
- **Solidity Knowledge**: Basic understanding of contract ownership, structs, and event emission.

---

## Contract Details

### Structs

- `Trip`:
  - `name`: Name or title of the trip.
  - `destination`: Place the trip is planned for.
  - `date`: UNIX timestamp indicating the trip date.

---

### State Variables

- `owner`: The creator of the contract; only this address can update the trip.
- `myTrip`: Stores the currently saved trip.

---

### Functions

- `setTrip(string _name, string _destination, uint256 _date)`:
  - Updates the trip data.
  - Can only be called by the `owner`.
  - Emits `TripCreated`.

- `getTrip()`:
  - Returns the current trip details: `name`, `destination`, and `date`.

---

### Events

- `TripCreated`: Emitted when a new trip is created or updated.

---

## Deployment and Testing in QRemix IDE (optional)

1. Open [QRemix IDE](https://www.qremix.org).
2. Create a new file named `SimpleTrip.sol`.
3. Paste the smart contract code.
4. Compile using **Solidity 0.8.20**.
5. Under the **Deploy & Run Transactions** tab:
   - Select environment: **JavaScript VM** or **Injected Provider (MetaMask)**.
   - Deploy the contract.

---

## Sample Interaction Flow

1. **Set a Trip**  
   Call `setTrip("Goa Adventure", "Goa", 1767225600)`  
   *(Assumes the timestamp corresponds to a future date.)*

2. **Get Trip Details**  
   Call `getTrip()` to retrieve the saved trip’s name, destination, and date.

---

## License

This project is licensed under the MIT License.  
See the `SPDX-License-Identifier: MIT` declaration in the contract.

---

## Support

For help with development or enhancements:

- QRemix IDE Docs: [https://docs.qremix.org](https://docs.qremix.org)
- Solidity Language Reference: [https://docs.soliditylang.org](https://docs.soliditylang.org)
