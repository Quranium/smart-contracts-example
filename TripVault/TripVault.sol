// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SimpleTrip
/// @notice Allows users to save a trip with a destination and date.

contract SimpleTrip {
    address public owner;

    struct Trip {
        string name;
        string destination;
        uint256 date; // UNIX timestamp
    }

    Trip public myTrip;

    event TripCreated(string name, string destination, uint256 date);

    constructor() {
        owner = msg.sender;
    }

    /// @notice Create or update a trip
    /// @param _name Name of the trip
    /// @param _destination Destination of the trip
    /// @param _date Date of the trip (UNIX timestamp)
    function setTrip(string calldata _name, string calldata _destination, uint256 _date) external {
        require(msg.sender == owner, "Only owner can set the trip");

        myTrip = Trip({
            name: _name,
            destination: _destination,
            date: _date
        });

        emit TripCreated(_name, _destination, _date);
    }

    /// @notice Get details of your trip
    function getTrip() external view returns (string memory, string memory, uint256) {
        return (myTrip.name, myTrip.destination, myTrip.date);
    }
}
