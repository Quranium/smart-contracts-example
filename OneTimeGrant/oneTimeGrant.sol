// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OneTimeGrant {
    address public recipient;
    bool public claimed;

    event GrantClaimed(address indexed recipient, uint256 amount);
    event Funded(address indexed sender, uint256 amount);

    modifier notClaimed() {
        require(!claimed, "Grant already claimed");
        _;
    }

    receive() external payable {
        emit Funded(msg.sender, msg.value);
    }

    function claimGrant() external notClaimed {
        require(address(this).balance > 0, "No funds to claim");
        recipient = msg.sender;
        claimed = true;

        uint256 amount = address(this).balance;
        payable(msg.sender).transfer(amount);

        emit GrantClaimed(msg.sender, amount);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
