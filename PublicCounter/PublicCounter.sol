// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PublicCounter {
    uint256 public counter;
    mapping(address => bool) public hasInteracted;

    event Incremented(address indexed user, uint256 newValue);
    event Reset(address indexed user);

    // No constructor – pure permissionless state

    function increment() external {
        require(!hasInteracted[msg.sender], "Already interacted");
        counter += 1;
        hasInteracted[msg.sender] = true;
        emit Incremented(msg.sender, counter);
    }

    function resetCounter() external {
        require(!hasInteracted[msg.sender], "Already interacted");
        counter = 0;
        hasInteracted[msg.sender] = true;
        emit Reset(msg.sender);
    }

    function getCounter() external view returns (uint256) {
        return counter;
    }

    function hasUsed(address user) external view returns (bool) {
        return hasInteracted[user];
    }
}
