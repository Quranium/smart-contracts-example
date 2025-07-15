// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HealthcareSupplyChain {
    enum Stage {
        Manufactured,
        InTransit,
        Delivered
    }

    struct Item {
        string name;
        string batchId;
        address manufacturer;
        address distributor;
        address hospital;
        uint256 timestamp;
        Stage stage;
    }

    address public admin;
    mapping(string => Item) public items; // batchId → Item

    event ItemCreated(string batchId, string name, address manufacturer);
    event Shipped(string batchId, address distributor);
    event Delivered(string batchId, address hospital);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin allowed");
        _;
    }

    modifier itemExists(string memory _batchId) {
        require(items[_batchId].manufacturer != address(0), "Item does not exist");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function createItem(
        string memory _name,
        string memory _batchId,
        address _distributor,
        address _hospital
    ) external onlyAdmin {
        require(items[_batchId].manufacturer == address(0), "Item already exists");

        items[_batchId] = Item({
            name: _name,
            batchId: _batchId,
            manufacturer: msg.sender,
            distributor: _distributor,
            hospital: _hospital,
            timestamp: block.timestamp,
            stage: Stage.Manufactured
        });

        emit ItemCreated(_batchId, _name, msg.sender);
    }

    function shipItem(string memory _batchId) external itemExists(_batchId) {
        Item storage item = items[_batchId];
        require(msg.sender == item.distributor, "Only distributor can ship");
        require(item.stage == Stage.Manufactured, "Item must be manufactured first");

        item.stage = Stage.InTransit;
        item.timestamp = block.timestamp;

        emit Shipped(_batchId, msg.sender);
    }

    function deliverItem(string memory _batchId) external itemExists(_batchId) {
        Item storage item = items[_batchId];
        require(msg.sender == item.hospital, "Only hospital can confirm delivery");
        require(item.stage == Stage.InTransit, "Item must be in transit");

        item.stage = Stage.Delivered;
        item.timestamp = block.timestamp;

        emit Delivered(_batchId, msg.sender);
    }

    function getItemDetails(string memory _batchId) external view returns (
        string memory name,
        address manufacturer,
        address distributor,
        address hospital,
        uint256 timestamp,
        string memory currentStage
    ) {
        Item memory item = items[_batchId];
        require(item.manufacturer != address(0), "Item does not exist");

        string memory stageStr = (
            item.stage == Stage.Manufactured ? "Manufactured" :
            item.stage == Stage.InTransit ? "In Transit" :
            "Delivered"
        );

        return (
            item.name,
            item.manufacturer,
            item.distributor,
            item.hospital,
            item.timestamp,
            stageStr
        );
    }
}
