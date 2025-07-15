// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeadMansSwitch {
    address public owner;
    address public beneficiary;
    uint256 public lastCheckIn;
    uint256 public timeoutPeriod;

    event CheckIn(address indexed owner, uint256 time);
    event Triggered(address indexed beneficiary, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    constructor(address _beneficiary, uint256 _timeoutPeriodInDays) payable {
        require(msg.value > 0, "Must send ETH");
        require(_beneficiary != address(0), "Invalid beneficiary");
        owner = msg.sender;
        beneficiary = _beneficiary;
        timeoutPeriod = _timeoutPeriodInDays * 1 days;
        lastCheckIn = block.timestamp;
    }

    function checkIn() external onlyOwner {
        lastCheckIn = block.timestamp;
        emit CheckIn(owner, lastCheckIn);
    }

    function trigger() external {
        require(block.timestamp >= lastCheckIn + timeoutPeriod, "Too early to trigger");
        require(address(this).balance > 0, "Nothing to transfer");

        uint256 amount = address(this).balance;
        payable(beneficiary).transfer(amount);

        emit Triggered(beneficiary, amount);
    }

    function getTimeLeft() external view returns (uint256) {
        if (block.timestamp >= lastCheckIn + timeoutPeriod) {
            return 0;
        }
        return (lastCheckIn + timeoutPeriod) - block.timestamp;
    }
}
