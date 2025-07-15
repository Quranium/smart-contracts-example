// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MessageBoard {
    string[] public messages;

    function postMessage(string calldata message) external {
        messages.push(message);
    }

    function getAllMessages() external view returns (string[] memory) {
        return messages;
    }

    function getMessage(uint256 index) external view returns (string memory) {
        require(index < messages.length, "Out of bounds");
        return messages[index];
    }
}
