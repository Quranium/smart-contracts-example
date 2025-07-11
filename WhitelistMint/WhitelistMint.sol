// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title WhitelistMint - A simple contract to allow only whitelisted addresses to mint once
contract WhitelistMint {
    mapping(address => bool) public whitelisted;
    mapping(address => bool) public hasMinted;
    address public admin;

    event Minted(address indexed user);

    /// @notice Sets the deployer as the admin
    constructor() {
        admin = msg.sender;
    }

    /// @notice Adds a user to the whitelist
    /// @param _user Address to be whitelisted
    function addToWhitelist(address _user) public {
        require(msg.sender == admin, "Only admin");
        whitelisted[_user] = true;
    }

    /// @notice Allows a whitelisted user to mint once
    function mint() public {
        require(whitelisted[msg.sender], "Not whitelisted");
        require(!hasMinted[msg.sender], "Already minted");

        hasMinted[msg.sender] = true;
        emit Minted(msg.sender);
    }
}
