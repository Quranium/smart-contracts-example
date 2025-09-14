# ArtSteward

## Contract Name

**ArtSteward**

---

## Overview

The `ArtSteward` contract is a provenance tracking system for digital or physical artworks on the blockchain. It creates an immutable history of ownership, exhibitions, and other significant events related to an artwork. Authorized verifiers can log events to the artwork's provenance record, creating a transparent and tamper-proof history of the artwork's journey.

This contract is ideal for artists, galleries, collectors, and museums looking to establish verifiable provenance for valuable artworks while maintaining a decentralized record of ownership and exhibition history.

---

## Prerequisites

- **QSafe or MetaMask** (for testnet deployment)
- **Testnet ETH or QRN**
- **QRemix IDE** ([qremix.org](https://qremix.org))
- Basic understanding of Solidity and smart contract interaction

---

## Contract Details

### Artwork Information

- **Artist:** Name of the artwork's creator
- **Title:** Title of the artwork
- **Year Created:** Year the artwork was created
- **Current Owner:** Ethereum address of the current owner

### Provenance Events

Each event in the provenance history contains:

- Timestamp of the event
- Event type (e.g., "Sale", "Exhibition: Louvre 2023", "Restoration")
- Previous owner address
- New owner address (if ownership changed)
- IPFS hash linking to supporting documents
- Address of the verifier who certified the event

---

## Contract Functions

### constructor

```solidity
constructor(
    address _initialOwner,
    string memory _artist,
    string memory _title,
    uint _year,
    address[] memory _verifiers
)
```

- **Purpose:** Initializes the contract with artwork details and authorized verifiers
- **Parameters:**
  - `_initialOwner`: Ethereum address of the initial owner
  - `_artist`: Name of the artist
  - `_title`: Title of the artwork
  - `_year`: Year the artwork was created
  - `_verifiers`: Array of addresses authorized to verify events

---

### logEvent

```solidity
function logEvent(
    string memory _eventType,
    address _newOwner,
    string memory _detailsURI
) external onlyVerifier
```

- **Purpose:** Adds a new event to the artwork's provenance history
- **Access:** Only callable by authorized verifiers
- **Parameters:**
  - `_eventType`: Description of the event (e.g., "Sale", "Exhibition")
  - `_newOwner`: Address of the new owner (if ownership is transferring)
  - `_detailsURI`: IPFS hash or URI linking to supporting documentation
- **Emits:** `NewEventLogged` event with details of the logged event

---

### getProvenanceHistoryCount

```solidity
function getProvenanceHistoryCount() public view returns (uint)
```

- **Purpose:** Returns the total number of events in the provenance history
- **Returns:** Count of provenance events

---

## Access Control

### Verifiers

- **Verifiers:** Pre-approved addresses that can log events to the provenance history
- **Modifier:** `onlyVerifier` restricts function access to authorized verifiers only

---

## Events

### NewEventLogged

```solidity
event NewEventLogged(
    uint256 indexed logIndex,
    string eventType,
    address verifiedBy
)
```

- **Purpose:** Emitted when a new event is added to the provenance history
- **Parameters:**
  - `logIndex`: Index of the new event in the provenance array
  - `eventType`: Type of event that was logged
  - `verifiedBy`: Address of the verifier who logged the event

---

## Deployment & Testing

### Step 1: Setup

- Open [qremix.org](https://qremix.org)
- Create a new file: `ArtSteward.sol`
- Paste the contract code

### Step 2: Compile

- Go to the **Solidity Compiler** tab
- Select compiler version `0.8.19`
- Click **Compile ArtSteward.sol**

### Step 3: Deploy

#### Testnet/Mainnet Deployment

#### Quranium Testnet

- Go to **Deploy & Run Transactions**
- Select **Injected Provider - MetaMask or QSafe**
- Connect to **Quranium Testnet**
- Fill constructor parameters:
  - `_initialOwner`: Address of the initial owner
  - `_artist`: Artist name (in quotes)
  - `_title`: Artwork title (in quotes)
  - `_year`: Creation year (as integer)
  - `_verifiers`: Array of verifier addresses (in square brackets)
- Click **Deploy**

---

## Usage Guide

### Initial Setup

1. Deploy the contract with artwork details and verifier addresses
2. The deployment automatically creates the initial "Creation" event in provenance

### Logging Events

1. As an authorized verifier, call `logEvent` with:
   - Event type description
   - New owner address (if ownership is changing)
   - IPFS hash of supporting documents
2. The contract will update the current owner if a new owner is specified
3. The event is permanently added to the provenance history

### Viewing Provenance

1. Call `getProvenanceHistoryCount` to see how many events are recorded
2. Access the `provenance` array to view specific event details:
   - `timestamp`: When the event occurred
   - `eventType`: Description of the event
   - `from`: Previous owner address
   - `to`: New owner address
   - `detailsURI`: IPFS hash for supporting documents
   - `verifiedBy`: Address of the verifying party

---

## IPFS Integration

For maximum utility, store supporting documents on IPFS:

1. Upload documents, photos, or certificates to IPFS
2. Use the resulting IPFS hash as the `_detailsURI` parameter when logging events
3. The provenance record will permanently reference these documents

---

## Security Considerations

- Carefully choose verifiers as they have authority to modify the provenance history
- The initial owner and verifiers set during deployment cannot be changed
- Consider implementing a verifier management system in future versions
- Regularly backup IPFS content to ensure long-term accessibility of supporting documents

---

## License

This project is licensed under the MIT License.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

## Support

For help or suggestions:

For help or suggestions, refer to:  
QRemix IDE Documentation: [https://docs.qremix.org](https://docs.qremix.org)
