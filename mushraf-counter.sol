// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title SimpleCounter - A contract for incrementing, decrementing, and resetting a counter.
contract SimpleCounter {
    int256 public counter; // The current value of the counter

    /// @notice Increment the counter by 1
    function increment() public {
        counter += 1;
    }

    /// @notice Decrement the counter by 1
    function decrement() public {
        counter -= 1;
    }

    /// @notice Reset the counter to zero
    function reset() public {
        counter = 0;
    }
} 