// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WhitelistMint {
    mapping(address => bool) public whitelisted;
    mapping(address => bool) public hasMinted;
    address public admin;

    event Minted(address indexed user);

    constructor() {
        admin = msg.sender;
    }

    function addToWhitelist(address _user) public {
        require(msg.sender == admin, "Only admin");
        whitelisted[_user] = true;
    }

    function mint() public {
        require(whitelisted[msg.sender], "Not whitelisted");
        require(!hasMinted[msg.sender], "Already minted");

        hasMinted[msg.sender] = true;
        emit Minted(msg.sender);
    }
}