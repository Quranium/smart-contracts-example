// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Tally {
    int256 public value;

    function increase() external {
        value += 1;
    }

    function decrease() external {
        value -= 1;
    }
}
