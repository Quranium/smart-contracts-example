// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleMultiSigNoConstructor {
    address[] public owners;
    uint public required;
    bool public isInitialized;

    struct Tx {
        address to;
        uint value;
        bool executed;
        uint confirmations;
    }

    Tx[] public transactions;
    mapping(address => bool) public isOwner;
    mapping(uint => mapping(address => bool)) public confirmed;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not owner");
        _;
    }

    modifier notInitialized() {
        require(!isInitialized, "Already initialized");
        _;
    }

    function setup(address[] memory _owners, uint _required) external notInitialized {
        require(_owners.length >= _required && _required > 0, "Invalid config");
        for (uint i = 0; i < _owners.length; i++) {
            isOwner[_owners[i]] = true;
        }
        owners = _owners;
        required = _required;
        isInitialized = true;
    }

    receive() external payable {}

    function submit(address to, uint value) external onlyOwner {
        transactions.push(Tx(to, value, false, 0));
    }

    function confirm(uint txIndex) external onlyOwner {
        Tx storage txObj = transactions[txIndex];
        require(!txObj.executed, "Already executed");
        require(!confirmed[txIndex][msg.sender], "Already confirmed");

        confirmed[txIndex][msg.sender] = true;
        txObj.confirmations++;

        if (txObj.confirmations >= required) {
            txObj.executed = true;
            (bool success, ) = txObj.to.call{value: txObj.value}("");
            require(success, "Execution failed");
        }
    }
}
