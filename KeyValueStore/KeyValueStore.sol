// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title KeyValueStore - A simple admin-controlled key-value storage contract
contract KeyValueStore {
    mapping(string => string) private store;
    address public admin;

    /// @dev Modifier to restrict function access to admin only
    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    /// @notice Initializes the admin of the contract
    /// @param _admin The address to be set as admin
    function initializeAdmin(address _admin) external {
        require(admin == address(0), "Admin already set");
        admin = _admin;
    }

    /// @notice Sets a value in the key-value store
    /// @param key The key string
    /// @param value The value string to associate with the key
    function set(string memory key, string memory value) public onlyAdmin {
        store[key] = value;
    }

    /// @notice Retrieves the value associated with a key
    /// @param key The key string
    /// @return value The stored string value
    function get(string memory key) public view returns (string memory) {
        return store[key];
    }
}
