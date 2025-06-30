// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KeyValueStore {
    mapping(string => string) private store;
    address public admin;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    function initializeAdmin(address _admin) external {
        require(admin == address(0), "Admin already set");
        admin = _admin;
    }

    function set(string memory key, string memory value) public onlyAdmin {
        store[key] = value;
    }

    function get(string memory key) public view returns (string memory) {
        return store[key];
    }
}
