// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EtherWallet {
    address public owner = msg.sender;

    function deposit() public payable {}

    function withdraw(uint256 _amount) public {
        require(msg.sender == owner, "Not owner");
        payable(owner).transfer(_amount);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
