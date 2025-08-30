pragma solidity ^0.8.19;

contract MysteryBoxNFT {
    string public name = "MysteryBoxNFT";
    string public symbol = "MBX";

    uint256 public boxPrice = 0.01 ether;
    uint256 public totalSupply;

    enum Rarity { Common, Rare, Epic, Legendary }

    struct NFT {
        address owner;
        Rarity rarity;
        bool storyUnlocked;
        string story;
    }

    mapping(uint256 => NFT) public tokens;
    mapping(address => uint256[]) public ownerTokens;
    mapping(uint256 => string) public tokenURIs;

    event NFTMinted(address indexed user, uint256 tokenId, Rarity rarity);
    event BoxPurchased(address indexed buyer);

    modifier onlyOwner(uint256 tokenId) {
        require(tokens[tokenId].owner == msg.sender, "Not the owner");
        _;
    }

    function purchaseBox() public payable {
        require(msg.value >= boxPrice, "Insufficient ETH");
        emit BoxPurchased(msg.sender);
        _mintMysteryNFT(msg.sender);
    }

    function _mintMysteryNFT(address to) internal {
        uint256 tokenId = ++totalSupply;
        Rarity rarity = _randomRarity(tokenId);
        bool unlockStory = (rarity == Rarity.Epic || rarity == Rarity.Legendary);
        string memory story = unlockStory ? _generateStory(tokenId) : "";

        tokens[tokenId] = NFT({
            owner: to,
            rarity: rarity,
            storyUnlocked: unlockStory,
            story: story
        });

        ownerTokens[to].push(tokenId);

        tokenURIs[tokenId] = _generateTokenURI(rarity, tokenId);

        emit NFTMinted(to, tokenId, rarity);
    }

    function _randomRarity(uint256 tokenId) internal view returns (Rarity) {
        uint256 rand = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, tokenId))) % 100;
        if (rand < 60) return Rarity.Common;
        else if (rand < 85) return Rarity.Rare;
        else if (rand < 97) return Rarity.Epic;
        else return Rarity.Legendary;
    }

    function _generateStory(uint256 tokenId) internal pure returns (string memory) {
        return string(abi.encodePacked("Mystery of NFT #", _uint2str(tokenId), ": Once lost in time, now found."));
    }

    function _generateTokenURI(Rarity rarity, uint256 tokenId) internal pure returns (string memory) {
        string memory base = "https://example.com/nft/";
        return string(abi.encodePacked(base, _uint2str(tokenId), "/", _uint2str(uint8(rarity)), ".json"));
    }

    function getMyTokens() public view returns (uint256[] memory) {
        return ownerTokens[msg.sender];
    }

    function getStory(uint256 tokenId) public view onlyOwner(tokenId) returns (string memory) {
        require(tokens[tokenId].storyUnlocked, "No story unlocked");
        return tokens[tokenId].story;
    }

    function withdraw() public {
        payable(address(0x1D109116c4e81Ac2FE7e19ed3456e70412974850)).transfer(address(this).balance); // here use your own address
    }

    // Utility
    function _uint2str(uint256 _i) internal pure returns (string memory str) {
        if (_i == 0) return "0";
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        while (_i != 0) {
            bstr[--k] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        str = string(bstr);
    }
}
