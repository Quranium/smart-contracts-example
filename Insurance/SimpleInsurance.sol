// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleInsurance {
    address public insurer;   // The insurance company
    uint public premium;      // Fixed premium amount
    uint public payoutAmount; // Amount insurer pays out in case of claim
    bool public claimMade;    // To track if a claim is already made

    mapping(address => bool) public insured;

    constructor(uint _premium, uint _payoutAmount) {
        insurer = msg.sender;
        premium = _premium;
        payoutAmount = _payoutAmount;
        claimMade = false;
    }

    // Customer buys insurance by paying the premium
    function buyInsurance() external payable {
        require(msg.value == premium, "Must pay exact premium amount");
        insured[msg.sender] = true;
    }

    // Customer makes a claim
    function makeClaim() external {
        require(insured[msg.sender], "You are not insured");
        require(!claimMade, "Claim already made");
        
        claimMade = true;
        payable(msg.sender).transfer(payoutAmount);
    }

    // Allow insurer to fund the contract (to cover payouts)
    function fundContract() external payable {
        require(msg.sender == insurer, "Only insurer can fund");
    }

    // Check contract balance
    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}
