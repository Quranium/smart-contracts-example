// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleStorage {
    uint public value;

    function set(uint _value) public {
        value = _value;
    }

    function get() public view returns (uint) {
        return value;
    }
}
