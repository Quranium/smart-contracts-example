// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TimeCapsule
/// @notice A smart contract to store ETH or messages that unlock at a future date.
contract TimeCapsule {
    struct Capsule {
        address creator;
        uint256 unlockTime;
        string message;
        uint256 amount;
        bool opened;
    }

    uint256 public capsuleCount;
    mapping(uint256 => Capsule) public capsules;

    event CapsuleCreated(uint256 indexed capsuleId, address indexed creator, uint256 unlockTime);
    event CapsuleOpened(uint256 indexed capsuleId, address indexed opener);

    /// @notice Create a new time capsule
    /// @param _unlockTime Timestamp when the capsule can be opened
    /// @param _message A hidden message for the future (optional)
    function createCapsule(uint256 _unlockTime, string memory _message) external payable {
        require(_unlockTime > block.timestamp, "Unlock time must be in the future");

        capsules[capsuleCount] = Capsule({
            creator: msg.sender,
            unlockTime: _unlockTime,
            message: _message,
            amount: msg.value,
            opened: false
        });

        emit CapsuleCreated(capsuleCount, msg.sender, _unlockTime);
        capsuleCount++;
    }

    /// @notice Open a capsule if its unlock time has passed
    /// @param _capsuleId ID of the capsule
    function openCapsule(uint256 _capsuleId) external {
        Capsule storage c = capsules[_capsuleId];

        require(msg.sender == c.creator, "Only creator can open");
        require(!c.opened, "Capsule already opened");
        require(block.timestamp >= c.unlockTime, "Too early to open");

        c.opened = true;

        if (c.amount > 0) {
            payable(msg.sender).transfer(c.amount);
        }

        emit CapsuleOpened(_capsuleId, msg.sender);
    }

    /// @notice View details of a capsule
    /// @dev Message is hidden unless creator or capsule is opened
    function viewCapsule(uint256 _capsuleId) external view returns (
        address creator,
        uint256 unlockTime,
        string memory message,
        uint256 amount,
        bool opened
    ) {
        Capsule memory c = capsules[_capsuleId];

        if (!c.opened && msg.sender != c.creator) {
            return (c.creator, c.unlockTime, "Locked until unlock time", c.amount, c.opened);
        } else {
            return (c.creator, c.unlockTime, c.message, c.amount, c.opened);
        }
    }
}
