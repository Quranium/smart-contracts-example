// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimeLockVault {
    address public owner;
    
    struct Lock {
        uint256 amount;
        uint256 releaseTime;
    }

    mapping(address => Lock) public lockedFunds;

    event FundsLocked(address indexed user, uint256 amount, uint256 releaseTime);
    event FundsWithdrawn(address indexed user, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function lockFunds(address _user, uint256 _releaseTime) external payable onlyOwner {
        require(msg.value > 0, "Must send ETH");
        require(_releaseTime > block.timestamp, "Release time must be in future");
        require(lockedFunds[_user].amount == 0, "Already locked");

        lockedFunds[_user] = Lock({
            amount: msg.value,
            releaseTime: _releaseTime
        });

        emit FundsLocked(_user, msg.value, _releaseTime);
    }

    function withdraw() external {
        Lock memory userLock = lockedFunds[msg.sender];
        require(userLock.amount > 0, "No funds locked");
        require(block.timestamp >= userLock.releaseTime, "Too early to withdraw");

        uint256 amount = userLock.amount;
        delete lockedFunds[msg.sender];
        payable(msg.sender).transfer(amount);

        emit FundsWithdrawn(msg.sender, amount);
    }
}
