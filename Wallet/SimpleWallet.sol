// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleWallet {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // Payable function to receive ETH
    function deposit() public payable {}

    // Non-payable function to check contract balance
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    // Payable function to allow sending ETH to the contract with a message
    function sendMessage(
        string calldata message
    ) public payable returns (string memory) {
        require(msg.value > 0, "Send some ETH with the message");
        return message;
    }

    // Non-payable function to withdraw all funds (only by owner)
    function withdrawAll() public {
        require(msg.sender == owner, "Only owner can withdraw");
        payable(owner).transfer(address(this).balance);
    }
}
