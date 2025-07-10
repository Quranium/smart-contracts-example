#  Smart Contract README

## Contract Name

**DAOTreasury.sol**

---

###  Overview:

The `DAOTreasury` smart contract implements a minimalistic DAO (Decentralized Autonomous Organization) treasury system. It allows verified members to:

- Propose fund transfers.
- Vote on those proposals.
- Execute proposals once the majority is reached.

This contract **does not use a constructor**, instead uses an `initialize()` function for upgradeability and proxy compatibility. It’s ideal for governance-based decentralized applications or small DAOs that need consensus before releasing funds.

It avoids external dependencies except for base Solidity constructs. You may extend it using **OpenZeppelin’s `Ownable`, `AccessControl`, or `UUPSUpgradeable`** for production-grade implementations.

**They are designed to be deployed and tested in the [**QRemix IDE**](https://www.qremix.org) using the JavaScript VM or a testnet like Quranium testnet, Sepolia, etc.**

---

###  **Prerequisites**

To deploy and test the contracts, you need:

- **MetaMask or QSafe**: Browser extension for testnet deployments (optional).
- **Test ETH or QRN**: Required for testnet deployments  
    - [Quranium Faucet](https://faucet.quranium.org/)
- **QRemix IDE**: [qremix.org](https://www.qremix.org/)
- **Basic Solidity Knowledge**: Know how to deploy contracts, work with mappings, modifiers, and access functions.

---

### Contract Details

#### State Variables:
- `address public admin`: Stores the DAO's admin.
- `mapping(address => bool) public members`: Tracks DAO members.
- `uint256 public memberCount`: Total number of members.
- `mapping(uint256 => Proposal) public proposals`: Stores proposals.
- `uint256 public proposalCount`: Running count of proposals.
- `bool public initialized`: One-time initialization lock.

#### Struct:
```solidity
struct Proposal {
    address payable recipient;
    uint256 amount;
    uint256 yesVotes;
    bool executed;
    mapping(address => bool) voted;
}
