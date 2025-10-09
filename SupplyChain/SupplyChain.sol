// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {
    enum Role { None, Manufacturer, Distributor, Retailer, Transporter, Consumer }

    struct Participant {
        address addr;
        Role role;
        string name;
        bool exists;
    }

    struct ItemEvent {
        address actor;
        string action;
        uint256 timestamp;
        string data; // optional extra data (location, note, etc.)
    }

    struct Item {
        uint256 id;
        string sku;
        string metadata; // off-chain pointer or JSON
        address creator;
        address owner;
        string status;
        bool exists;
    }

    struct Shipment {
        uint256 id;
        uint256[] itemIds;
        address from;
        address to;
        string status;
        uint256 eta;
        bool exists;
    }

    address public admin;

    mapping(address => Participant) public participants;
    mapping(uint256 => Item) public items;
    mapping(uint256 => ItemEvent[]) internal history;
    mapping(uint256 => Shipment) public shipments;

    uint256 public nextItemId;
    uint256 public nextShipmentId;

    event ParticipantRegistered(address indexed addr, Role role, string name);
    event ItemCreated(uint256 indexed itemId, address indexed creator, string sku);
    event ItemTransferred(uint256 indexed itemId, address indexed from, address indexed to, string note);
    event StatusUpdated(uint256 indexed itemId, string status);
    event LocationRecorded(uint256 indexed itemId, string location);
    event ShipmentCreated(uint256 indexed shipmentId, address indexed from, address indexed to);
    event ShipmentStatusUpdated(uint256 indexed shipmentId, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "only admin");
        _;
    }

    modifier onlyParticipant() {
        require(participants[msg.sender].exists, "not participant");
        _;
    }

    constructor() {
        admin = msg.sender;
        // register deployer as admin participant (no specific role)
        participants[msg.sender] = Participant({addr: msg.sender, role: Role.None, name: "Admin", exists: true});
    }

    // Admin registers participants with a role and name
    function registerParticipant(address addr, Role role, string calldata name) external onlyAdmin {
        require(addr != address(0), "zero addr");
        participants[addr] = Participant({addr: addr, role: role, name: name, exists: true});
        emit ParticipantRegistered(addr, role, name);
    }

    // Create an item (only participants allowed)
    function createItem(string calldata sku, string calldata metadata) external onlyParticipant returns (uint256) {
        uint256 id = nextItemId++;
        items[id] = Item({id: id, sku: sku, metadata: metadata, creator: msg.sender, owner: msg.sender, status: "Created", exists: true});
        history[id].push(ItemEvent({actor: msg.sender, action: "Created", timestamp: block.timestamp, data: metadata}));
        emit ItemCreated(id, msg.sender, sku);
        return id;
    }

    // Transfer ownership of an item (owner or admin)
    function transferItem(uint256 itemId, address to, string calldata note) external {
        require(items[itemId].exists, "no item");
        Item storage it = items[itemId];
        require(msg.sender == it.owner || msg.sender == admin, "not owner/admin");
        address from = it.owner;
        it.owner = to;
        history[itemId].push(ItemEvent({actor: msg.sender, action: "Transfer", timestamp: block.timestamp, data: note}));
        emit ItemTransferred(itemId, from, to, note);
    }

    // Update status (e.g., Manufactured, InTransit, Delivered)
    function updateStatus(uint256 itemId, string calldata status) external onlyParticipant {
        require(items[itemId].exists, "no item");
        items[itemId].status = status;
        history[itemId].push(ItemEvent({actor: msg.sender, action: "Status", timestamp: block.timestamp, data: status}));
        emit StatusUpdated(itemId, status);
    }

    // Record a location or note for an item
    function recordLocation(uint256 itemId, string calldata location) external onlyParticipant {
        require(items[itemId].exists, "no item");
        history[itemId].push(ItemEvent({actor: msg.sender, action: "Location", timestamp: block.timestamp, data: location}));
        emit LocationRecorded(itemId, location);
    }

    // Create a shipment of multiple items
    function createShipment(uint256[] calldata itemIds, address to, uint256 eta) external onlyParticipant returns (uint256) {
        require(itemIds.length > 0, "empty");
        uint256 id = nextShipmentId++;
        shipments[id] = Shipment({id: id, itemIds: itemIds, from: msg.sender, to: to, status: "Created", eta: eta, exists: true});
        emit ShipmentCreated(id, msg.sender, to);
        // mark items as in shipment in history
        for (uint256 i = 0; i < itemIds.length; i++) {
            uint256 iid = itemIds[i];
            require(items[iid].exists, "item missing");
            history[iid].push(ItemEvent({actor: msg.sender, action: "Shipped", timestamp: block.timestamp, data: string(abi.encodePacked("Shipment:", _uint2str(id)))}));
        }
        return id;
    }

    // Update shipment status
    function updateShipmentStatus(uint256 shipmentId, string calldata status) external onlyParticipant {
        require(shipments[shipmentId].exists, "no shipment");
        shipments[shipmentId].status = status;
        emit ShipmentStatusUpdated(shipmentId, status);
        // if delivered, transfer ownership of items to recipient
        if (_stringsEqual(status, "Delivered")) {
            Shipment storage s = shipments[shipmentId];
            for (uint256 i = 0; i < s.itemIds.length; i++) {
                uint256 iid = s.itemIds[i];
                Item storage it = items[iid];
                address prev = it.owner;
                it.owner = s.to;
                history[iid].push(ItemEvent({actor: msg.sender, action: "Delivered", timestamp: block.timestamp, data: string(abi.encodePacked("Shipment:", _uint2str(shipmentId)))}));
                emit ItemTransferred(iid, prev, s.to, "Delivered via shipment");
            }
        }
    }

    // View history for an item
    function getHistory(uint256 itemId) external view returns (ItemEvent[] memory) {
        return history[itemId];
    }

    // Helper: get item details
    function getItem(uint256 itemId) external view returns (uint256 id, string memory sku, string memory metadata, address creator, address owner, string memory status) {
        require(items[itemId].exists, "no item");
        Item storage it = items[itemId];
        return (it.id, it.sku, it.metadata, it.creator, it.owner, it.status);
    }

    // Simple helpers
    function _stringsEqual(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }

    function _uint2str(uint256 v) internal pure returns (string memory str) {
        if (v == 0) return "0";
        uint256 digits;
        uint256 tmp = v;
        while (tmp != 0) { digits++; tmp /= 10; }
        bytes memory buf = new bytes(digits);
        while (v != 0) {
            digits -= 1;
            buf[digits] = bytes1(uint8(48 + uint256(v % 10)));
            v /= 10;
        }
        return string(buf);
    }
}
