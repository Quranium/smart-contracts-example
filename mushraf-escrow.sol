// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title SimpleEscrow - A basic escrow contract for two parties to deposit and release funds.
contract SimpleEscrow {
    address public depositor;      // The address that deposited the funds
    address public beneficiary;    // The address that will receive the funds
    uint256 public amount;         // Amount of Ether deposited
    bool public isDeposited;       // Status of deposit

    /// @notice Deposit Ether into the contract for a beneficiary
    /// @param _beneficiary The address that will receive the funds upon release
    function deposit(address _beneficiary) public payable {
        require(!isDeposited, "Already deposited");
        require(msg.value > 0, "No value sent");
        depositor = msg.sender;
        beneficiary = _beneficiary;
        amount = msg.value;
        isDeposited = true;
    }

    /// @notice Release the deposited funds to the beneficiary
    /// Can only be called by the depositor
    function release() public {
        require(isDeposited, "No deposit");
        require(msg.sender == depositor, "Only depositor can release");
        isDeposited = false;
        payable(beneficiary).transfer(amount);
    }
}
