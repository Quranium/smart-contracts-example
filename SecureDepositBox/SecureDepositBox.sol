// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Note: Importing directly from GitHub won't work in Remix or during Solidity compilation via solc.
// It's better to install OpenZeppelin via npm or use a local copy in production setups.
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.3/contracts/access/Ownable.sol";

/// @title SimpleVault
/// @notice A vault that allows only the owner to withdraw ETH; anyone can deposit.
contract SimpleVault is Ownable {
    uint256 public totalBalance;

    event Deposited(address indexed sender, uint256 amount);
    event Withdrawn(address indexed to, uint256 amount);

    /// @notice Allows anyone to deposit ETH to the contract
    receive() external payable {
        totalBalance += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    /// @notice Allows only the owner to withdraw ETH
    /// @param amount Amount in wei to withdraw
    function withdraw(uint256 amount) external onlyOwner {
        require(amount <= address(this).balance, "Insufficient balance");
        totalBalance -= amount;
        payable(owner()).transfer(amount);
        emit Withdrawn(owner(), amount);
    }

    /// @notice Returns the contract's current ETH balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
