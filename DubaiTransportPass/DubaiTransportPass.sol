// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DubaiTransportPass
/// @notice Blockchain-based prepaid transport pass system for Dubai's smart mobility network.

contract DubaiTransportPass {
    address public admin;
    uint256 public baseFare = 3 ether; // Default fare (e.g., 3 AED in wei format if using custom tokens)
    uint256 public totalIssued;

    struct Pass {
        address owner;
        uint256 balance;
        uint256 issuedAt;
        uint256 expiresAt;
        bool isActive;
    }

    mapping(uint256 => Pass) public passes;
    mapping(address => uint256) public passByOwner;

    event PassIssued(address indexed user, uint256 indexed passId, uint256 duration, uint256 initialBalance);
    event RideTaken(address indexed user, uint256 indexed passId, uint256 fare);
    event PassRecharged(uint256 indexed passId, uint256 amount);
    event PassSuspended(uint256 indexed passId);
    event PassReactivated(uint256 indexed passId);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin allowed.");
        _;
    }

    modifier onlyPassOwner(uint256 passId) {
        require(passes[passId].owner == msg.sender, "Not the pass owner.");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /// @notice Issue a new transport pass to a user
    /// @param user The address receiving the pass
    /// @param duration Validity duration in seconds
    /// @param initialBalance Initial prepaid balance
    function issuePass(address user, uint256 duration, uint256 initialBalance) external onlyAdmin {
        require(passByOwner[user] == 0, "User already has a pass.");

        totalIssued++;
        passes[totalIssued] = Pass({
            owner: user,
            balance: initialBalance,
            issuedAt: block.timestamp,
            expiresAt: block.timestamp + duration,
            isActive: true
        });

        passByOwner[user] = totalIssued;

        emit PassIssued(user, totalIssued, duration, initialBalance);
    }

    /// @notice Use the pass for a ride
    /// @param passId ID of the user's pass
    function takeRide(uint256 passId) external onlyPassOwner(passId) {
        Pass storage pass = passes[passId];
        require(pass.isActive, "Pass is not active.");
        require(block.timestamp <= pass.expiresAt, "Pass expired.");
        require(pass.balance >= baseFare, "Insufficient balance.");

        pass.balance -= baseFare;

        emit RideTaken(msg.sender, passId, baseFare);
    }

    /// @notice Recharge the pass with more balance
    function rechargePass(uint256 passId) external payable onlyPassOwner(passId) {
        require(msg.value > 0, "Must send ETH to recharge.");
        passes[passId].balance += msg.value;
        emit PassRecharged(passId, msg.value);
    }

    /// @notice Suspend a pass (e.g., lost/stolen)
    function suspendPass(uint256 passId) external onlyAdmin {
        passes[passId].isActive = false;
        emit PassSuspended(passId);
    }

    /// @notice Reactivate a suspended pass
    function reactivatePass(uint256 passId) external onlyAdmin {
        require(passes[passId].expiresAt > block.timestamp, "Pass already expired.");
        passes[passId].isActive = true;
        emit PassReactivated(passId);
    }

    /// @notice Get details of a pass
    function getPass(uint256 passId) external view returns (Pass memory) {
        return passes[passId];
    }

    /// @notice Get the pass ID linked to a user address
    function getPassIdByUser(address user) external view returns (uint256) {
        return passByOwner[user];
    }
}
