// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

contract StableCoin {
    // Token name and symbol
    string public name = "Stable Coin";
    string public symbol = "STC";

    // Total supply of tokens
    uint public totalSupply;

    // Mapping of token balances
    mapping(address => uint) public balances;

    // Mapping of token allowances
    mapping(address => mapping(address => uint)) public allowances;

    // Event emitted when tokens are transferred
    event Transfer(address indexed from, address indexed to, uint value);

    // Event emitted when tokens are approved
    event Approval(address indexed owner, address indexed spender, uint value);

    // Event emitted when the yield rate is updated
    event YieldRateUpdated(uint newRate);

    // Yield rate
    uint public yieldRate;

    // Last update timestamp
    uint public lastUpdate;

    // Reserve balance
    uint public reserveBalance;

    // Reserve address
    address public reserveAddress;

    // Constructor to initialize the contract
    constructor(uint _totalSupply, uint _yieldRate, address _reserveAddress) public {
        totalSupply = _totalSupply;
        balances[msg.sender] = totalSupply;
        yieldRate = _yieldRate;
        lastUpdate = block.timestamp;
        reserveAddress = _reserveAddress;
        reserveBalance = 0;
    }

    // Function to transfer tokens
    function transfer(address to, uint value) public {
        require(balances[msg.sender] >= value, "Insufficient balance");
        balances[msg.sender] -= value;
        balances[to] += value;
        emit Transfer(msg.sender, to, value);
    }

    // Function to approve a spender
    function approve(address spender, uint value) public {
        allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
    }

    // Function to get the balance of a specific account
    function balanceOf(address account) public view returns (uint) {
        return balances[account];
    }

    // Function to update the yield rate
    function updateYieldRate(uint newRate) public {
        require(msg.sender == reserveAddress, "Only reserve can update yield rate");
        yieldRate = newRate;
        lastUpdate = block.timestamp;
        emit YieldRateUpdated(newRate);
    }

    // Function to deposit tokens to the reserve
    function deposit(uint value) public {
        require(msg.sender != reserveAddress, "Reserve cannot deposit");
        balances[msg.sender] -= value;
        reserveBalance += value;
    }

    // Function to withdraw tokens from the reserve
    function withdraw(uint value) public {
        require(msg.sender == reserveAddress, "Only reserve can withdraw");
        require(reserveBalance >= value, "Insufficient reserve balance");
        reserveBalance -= value;
        balances[msg.sender] += value;
    }
}