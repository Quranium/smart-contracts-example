// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TrafficViolationTracker {
    address public admin;

    struct Violation {
        string vehicleNumber;
        string violationType;
        uint256 fineAmount;
        bool isPaid;
        uint256 timestamp;
    }

    uint256 public violationCount;

    mapping(uint256 => Violation) public violations;
    mapping(string => uint256[]) public vehicleToViolationIds;

    event ViolationLogged(uint256 id, string vehicleNumber, string violationType, uint256 fineAmount);
    event FinePaid(uint256 id, string vehicleNumber, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin allowed");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logViolation(string memory vehicleNumber, string memory violationType, uint256 fineAmount) external onlyAdmin {
        violationCount++;
        violations[violationCount] = Violation(
            vehicleNumber,
            violationType,
            fineAmount,
            false,
            block.timestamp
        );
        vehicleToViolationIds[vehicleNumber].push(violationCount);

        emit ViolationLogged(violationCount, vehicleNumber, violationType, fineAmount);
    }

    function payFine(uint256 violationId) external payable {
        Violation storage v = violations[violationId];
        require(!v.isPaid, "Fine already paid");
        require(msg.value >= v.fineAmount, "Insufficient fine amount");

        v.isPaid = true;

        emit FinePaid(violationId, v.vehicleNumber, msg.value);
    }

    function getViolationsByVehicle(string memory vehicleNumber) external view returns (uint256[] memory) {
        return vehicleToViolationIds[vehicleNumber];
    }

    function getViolationDetails(uint256 violationId) external view returns (Violation memory) {
        return violations[violationId];
    }

    function withdraw() external onlyAdmin {
        payable(admin).transfer(address(this).balance);
    }
}
