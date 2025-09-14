// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract PublicNFT1155 is ERC1155, Ownable {
    using Strings for uint256;

    uint256 public price = 0.001 ether;
    uint256 public tokenCounter;

    string public name;
    string public symbol;
    string public constant baseURI =
        "https://indigo-genetic-echidna-662.mypinata.cloud/ipfs/QmRFGb7Vd8QouEKvHtB9jZLwCt7EMSU47XTW1zB3PRqpjy/";

    constructor() ERC1155("") {
        name = "PublicNFT1155";
        symbol = "PNFT1155";
        tokenCounter = 0;
    }

    function uri(uint256 tokenId) public view override returns (string memory) {
        return string(abi.encodePacked(baseURI, tokenId.toString(), ".jpeg"));
    }

    function purchaseNFT() external payable {
        require(msg.value >= price, "Insufficient ETH sent");

        uint256 tokenId = tokenCounter;
        _mint(msg.sender, tokenId, 1, "");
        tokenCounter++;
    }

    function withdraw() external onlyOwner {
        (bool success, ) = owner().call{value: address(this).balance}("");
        require(success, "Withdrawal failed");
    }
}
