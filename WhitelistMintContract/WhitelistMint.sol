// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract WhitelistMint {
    uint256 public mintPrice = 0.01 ether;
    uint256 public totalSupply;
    uint256 public maxSupply = 1000;
    bool public saleActive;

    address public owner;
    bool private _initialized;

    mapping(address => bool) public whitelist;
    mapping(address => uint256) public minted;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function initialize() external {
        require(!_initialized, "Already initialized");
        owner = msg.sender;
        _initialized = true;
    }

    function toggleSale() external onlyOwner {
        saleActive = !saleActive;
    }

    function addToWhitelist(address[] calldata addresses) external onlyOwner {
        for (uint i = 0; i < addresses.length; i++) {
            whitelist[addresses[i]] = true;
        }
    }

    function removeFromWhitelist(address user) external onlyOwner {
        whitelist[user] = false;
    }

    function mint(uint256 quantity) external payable {
        require(saleActive, "Sale not active");
        require(whitelist[msg.sender], "Not whitelisted");
        require(quantity > 0, "Quantity must be > 0");
        require(totalSupply + quantity <= maxSupply, "Exceeds max supply");
        require(msg.value == quantity * mintPrice, "Incorrect ETH");

        minted[msg.sender] += quantity;
        totalSupply += quantity;

        // In real-world, NFTs or tokens would be minted here
    }

    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    function getMinted(address user) external view returns (uint256) {
        return minted[user];
    }
}
