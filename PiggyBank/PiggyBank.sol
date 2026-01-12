// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PiggyBank {
    address public owner;
    constructor() { owner = msg.sender; }
    receive() external payable {}
    function withdraw() external {
        require(msg.sender == owner, "not owner");
        payable(owner).transfer(address(this).balance);
    }
}
