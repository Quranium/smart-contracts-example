// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./Ayan-TokenFaucet/Token.sol";

/// @title Faucet - A one-time token dispenser
contract Faucet {
    Token public token;
    uint256 public dripAmount = 100 * 10 ** 18;
    mapping(address => bool) public hasClaimed;

    function setTokenAddress(address tokenAddress) external {
        require(address(token) == address(0), "Token already set");
        token = Token(tokenAddress);
    }

    function claim() external {
        require(!hasClaimed[msg.sender], "Already claimed");
        hasClaimed[msg.sender] = true;
        token.mint(msg.sender, dripAmount);
    }
}
