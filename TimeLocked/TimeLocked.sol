// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TimeLockedVault {
    struct Lock {
        uint256 amount;
        uint256 unlockTime;
    }

    mapping(address => Lock) public vaults;

    event Deposited(address indexed user, uint256 amount, uint256 unlockTime);
    event Withdrawn(address indexed user, uint256 amount);

    function deposit(uint256 lockDurationInSeconds) external payable {
        require(msg.value > 0, "Must deposit ETH");
        require(vaults[msg.sender].amount == 0, "Already locked");

        uint256 unlockTime = block.timestamp + lockDurationInSeconds;
        vaults[msg.sender] = Lock(msg.value, unlockTime);

        emit Deposited(msg.sender, msg.value, unlockTime);
    }

    function withdraw() external {
        Lock memory userLock = vaults[msg.sender];
        require(userLock.amount > 0, "No locked funds");
        require(block.timestamp >= userLock.unlockTime, "Too early");

        delete vaults[msg.sender];
        payable(msg.sender).transfer(userLock.amount);

        emit Withdrawn(msg.sender, userLock.amount);
    }

    function getVault(address user) external view returns (uint256 amount, uint256 unlockTime) {
        Lock memory l = vaults[user];
        return (l.amount, l.unlockTime);
    }

    receive() external payable {
        revert("Use deposit()");
    }
}
