// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BasicToken {
    string public name;
    string public symbol;
    uint public totalSupply;
    mapping(address => uint) public balanceOf;

    constructor(string memory _name, string memory _symbol, uint _totalSupply) {
        name = _name;
        symbol = _symbol;
        totalSupply = _totalSupply;
        balanceOf[msg.sender] = _totalSupply;
    }

    function transfer(address to, uint amount) public {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
    }
}