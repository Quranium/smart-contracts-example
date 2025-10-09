```markdown
# SupplyChain

## Contract Name
SupplyChain

## Overview
`SupplyChain` is a minimal on-chain tracking system for physical goods. It supports participant registration (manufacturer, distributor, transporter, retailer), item creation, ownership transfers, status and location updates, and shipment grouping. The contract emits events and stores item history suitable for off-chain indexing.

This README follows the repository's style and is written for deployment and testing via QRemix/Remix.

## Prerequisites
- MetaMask / QSafe for testnet (optional for JavaScript VM)
- Test ETH
- QRemix / Remix IDE

## Contract Details

### Roles
- `Manufacturer`, `Distributor`, `Retailer`, `Transporter`, `Consumer`. Admin (deployer) can register participants.

### Key Functions

#### registerParticipant(address addr, Role role, string name)
- **Purpose**: Admin registers a participant with a role and name.

#### createItem(string sku, string metadata) returns (itemId)
- **Purpose**: Participant creates an item; item is stored with metadata and initial owner.

#### transferItem(uint256 itemId, address to, string note)
- **Purpose**: Owner (or admin) transfers ownership of an item to another participant.

#### updateStatus(uint256 itemId, string status)
- **Purpose**: Participant updates the status of an item (e.g., Manufactured, InTransit, Delivered).

#### recordLocation(uint256 itemId, string location)
- **Purpose**: Participant records a location/note for the item.

#### createShipment(uint256[] itemIds, address to, uint256 eta) returns (shipmentId)
- **Purpose**: Create a shipment grouping multiple items; items are associated with shipment events.

#### updateShipmentStatus(uint256 shipmentId, string status)
- **Purpose**: Update shipment status; when status set to `Delivered`, ownership of items is transferred to the recipient.

#### getHistory(uint256 itemId) returns (ItemEvent[])
- **Purpose**: Retrieve event history for an item (on-chain stored events array).

### Events
- `ParticipantRegistered(addr, role, name)`
- `ItemCreated(itemId, creator, sku)`
- `ItemTransferred(itemId, from, to, note)`
- `StatusUpdated(itemId, status)`
- `LocationRecorded(itemId, location)`
- `ShipmentCreated(shipmentId, from, to)`
- `ShipmentStatusUpdated(shipmentId, status)`

### Notes & Security
- This contract stores events and a simple on-chain history array for each item. For large-scale systems, prefer emitting events and using an off-chain indexer to reconstruct timelines.
- Ownership transfers and shipment deliveries are authoritative on-chain actions.
- Admin (deployer) has the power to register participants. Consider replacing admin with a DAO or multisig for production.

## Deployment & Testing (QRemix / Remix)

### Setup
1. Open QRemix or Remix.
2. Create `SupplyChain/` folder and add `SupplyChain.sol`.

### Compilation
1. Select Solidity compiler 0.8.x and compile.

### Example Flow
1. Deployer registers participants: Manufacturer, Transporter, Distributor
2. Manufacturer calls `createItem(sku, metadata)` to create item
3. Manufacturer calls `createShipment([itemId], distributorAddress, eta)` to ship
4. Transporter updates shipment status to `InTransit` and records locations
5. When delivered, transporter or admin calls `updateShipmentStatus(shipmentId, "Delivered")`; ownership moves to recipient
6. Use `getHistory(itemId)` or listen to emitted events to reconstruct the item's lifecycle

## License
MIT (see SPDX header in the contract)

``` 