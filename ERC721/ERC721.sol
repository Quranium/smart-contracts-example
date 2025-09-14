// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract PublicNFT is ERC721URIStorage, Ownable {
    using Strings for uint256; // Enable number-to-string conversion

    uint256 public price = 0.001 ether;
    uint256 public tokenCounter;

    string public constant baseURI =
        "https://indigo-genetic-echidna-662.mypinata.cloud/ipfs/QmRFGb7Vd8QouEKvHtB9jZLwCt7EMSU47XTW1zB3PRqpjy/";

    constructor() ERC721("PublicNFT", "PNFT") {
        tokenCounter = 0;
    }

    function purchaseNFT() external payable {
        require(msg.value >= price, "Insufficient ETH sent");

        uint256 tokenId = tokenCounter;
        _safeMint(msg.sender, tokenId);

        // Generate dynamic token URI (e.g., "1.jpeg")
        string memory tokenUri = string(
            abi.encodePacked(baseURI, tokenId.toString(), ".jpeg")
        );
        _setTokenURI(tokenId, tokenUri); // Assign URI to token

        tokenCounter++; // CRITICAL: Increment counter for next mint
    }
}
