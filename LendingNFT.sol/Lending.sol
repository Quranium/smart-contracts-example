// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
}

contract NFTRental {
    struct Rental {
        address owner;
        address renter;
        address nft;
        uint256 tokenId;
        uint256 price;
        uint256 expiresAt;
        bool rented;
    }

    uint256 public rentalCount;
    mapping(uint256 => Rental) public rentals;

    event NFTListed(uint256 indexed rentalId, address owner, address nft, uint256 tokenId, uint256 price);
    event NFTRented(uint256 indexed rentalId, address renter, uint256 expiresAt);
    event NFTReturned(uint256 indexed rentalId);

    function listNFT(address _nft, uint256 _tokenId, uint256 _price) external {
        IERC721(_nft).safeTransferFrom(msg.sender, address(this), _tokenId);

        rentals[++rentalCount] = Rental({
            owner: msg.sender,
            renter: address(0),
            nft: _nft,
            tokenId: _tokenId,
            price: _price,
            expiresAt: 0,
            rented: false
        });

        emit NFTListed(rentalCount, msg.sender, _nft, _tokenId, _price);
    }

    function rentNFT(uint256 _rentalId, uint256 _duration) external payable {
        Rental storage r = rentals[_rentalId];
        require(!r.rented, "Already rented");
        require(msg.value == r.price, "Incorrect price");

        r.renter = msg.sender;
        r.expiresAt = block.timestamp + _duration;
        r.rented = true;

        emit NFTRented(_rentalId, msg.sender, r.expiresAt);
    }

    function returnNFT(uint256 _rentalId) external {
        Rental storage r = rentals[_rentalId];
        require(r.rented, "Not rented");
        require(block.timestamp >= r.expiresAt, "Rental period not over");

        IERC721(r.nft).safeTransferFrom(address(this), r.owner, r.tokenId);
        payable(r.owner).transfer(r.price);

        r.rented = false;
        emit NFTReturned(_rentalId);
    }
}
