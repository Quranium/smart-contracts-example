// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LondonCitizenBadge {
    address public admin;
    uint256 public totalBadges;

    struct Badge {
        string name;
        string borough; // e.g., Camden, Hackney, Westminster
        string role;    // e.g., Citizen, Resident, Worker
        uint256 issuedAt;
        bool isActive;
    }

    mapping(address => Badge) public badges;

    event BadgeIssued(address indexed to, string name, string borough, string role);
    event BadgeRevoked(address indexed from);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action.");
        _;
    }

    modifier hasNoBadge(address user) {
        require(badges[user].issuedAt == 0, "Badge already issued to this address.");
        _;
    }

    modifier hasBadge(address user) {
        require(badges[user].issuedAt != 0, "No badge issued to this address.");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function issueBadge(
        address user,
        string memory name,
        string memory borough,
        string memory role
    ) external onlyAdmin hasNoBadge(user) {
        badges[user] = Badge({
            name: name,
            borough: borough,
            role: role,
            issuedAt: block.timestamp,
            isActive: true
        });

        totalBadges++;
        emit BadgeIssued(user, name, borough, role);
    }

    function revokeBadge(address user) external onlyAdmin hasBadge(user) {
        badges[user].isActive = false;
        emit BadgeRevoked(user);
    }

    function hasActiveBadge(address user) external view returns (bool) {
        return badges[user].isActive;
    }

    function getBadgeInfo(address user) external view returns (Badge memory) {
        return badges[user];
    }
}
