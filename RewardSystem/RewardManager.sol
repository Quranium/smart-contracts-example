// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./RewardSystem/RewardToken.sol";

/// @title RewardManager - Token Issuer for Mobile App Without Constructor
contract RewardManager {
    RewardToken public rewardToken;
    address public backend;
    bool public initialized;

    modifier onlyBackend() {
        require(msg.sender == backend, "Not backend");
        _;
    }

    function initialize(address tokenAddress, address backendAddress) external {
        require(!initialized, "Already initialized");
        rewardToken = RewardToken(tokenAddress);
        backend = backendAddress;
        initialized = true;
    }

    function issueReward(address user, uint256 amount) external onlyBackend {
        rewardToken.mint(user, amount);
        emit RewardIssued(user, amount);
    }

    function redeemReward(uint256 amount) external {
        rewardToken.burn(msg.sender, amount);
        emit RewardRedeemed(msg.sender, amount);
    }

    function updateBackend(address newBackend) external onlyBackend {
        backend = newBackend;
    }

    event RewardIssued(address indexed user, uint256 amount);
    event RewardRedeemed(address indexed user, uint256 amount);
}
