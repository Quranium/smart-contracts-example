// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721Token {
    function transferFrom(address from, address to, uint256 tokenId) external;
}

contract RoyaltyMarketplace {
    struct Listing {
        address seller;
        address nft;
        uint256 tokenId;
        uint256 price;
        address[] collaborators;
        uint256[] shares;
    }

    uint256 public listingCount;
    mapping(uint256 => Listing) public listings;

    event Listed(uint256 id, address seller, uint256 price);
    event Purchased(uint256 id, address buyer);

    function listNFT(
        address _nft,
        uint256 _tokenId,
        uint256 _price,
        address[] memory _collaborators,
        uint256[] memory _shares
    ) external {
        require(_collaborators.length == _shares.length, "Mismatch");

        listings[++listingCount] = Listing({
            seller: msg.sender,
            nft: _nft,
            tokenId: _tokenId,
            price: _price,
            collaborators: _collaborators,
            shares: _shares
        });

        emit Listed(listingCount, msg.sender, _price);
    }

    function buyNFT(uint256 _id) external payable {
        Listing storage l = listings[_id];
        require(msg.value == l.price, "Wrong price");

        uint256 totalShares = 0;
        for (uint256 i = 0; i < l.shares.length; i++) {
            totalShares += l.shares[i];
        }

        for (uint256 i = 0; i < l.collaborators.length; i++) {
            uint256 payout = (msg.value * l.shares[i]) / totalShares;
            payable(l.collaborators[i]).transfer(payout);
        }

        IERC721Token(l.nft).transferFrom(l.seller, msg.sender, l.tokenId);
        emit Purchased(_id, msg.sender);
    }
}
