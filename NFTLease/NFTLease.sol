// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function ownerOf(uint256 tokenId) external view returns (address);
}

contract NFTLease {
    struct Listing {
        address nft;
        uint256 tokenId;
        address owner;
        address renter;
        uint256 pricePerPeriod; // wei per period
        uint256 periodSeconds;
        uint256 expiry; // timestamp until which renter has rights
        bool exists;
    }

    Listing[] public listings;

    event Listed(uint256 indexed id, address owner, address nft, uint256 tokenId, uint256 pricePerPeriod, uint256 periodSeconds);
    event Rented(uint256 indexed id, address renter, uint256 expiry);
    event ListingCancelled(uint256 indexed id);
    event NFTWithdrawn(uint256 indexed id, address to);
    event LeaseEnded(uint256 indexed id);

    // Create a listing and transfer NFT into contract custody in one call.
    // Caller must approve this contract for the token beforehand.
    function createListingAndDeposit(address nft, uint256 tokenId, uint256 pricePerPeriod, uint256 periodSeconds) external returns (uint256) {
        require(periodSeconds > 0, "period>0");
        // pull NFT into contract
        IERC721(nft).safeTransferFrom(msg.sender, address(this), tokenId);
        Listing memory l = Listing({
            nft: nft,
            tokenId: tokenId,
            owner: msg.sender,
            renter: address(0),
            pricePerPeriod: pricePerPeriod,
            periodSeconds: periodSeconds,
            expiry: 0,
            exists: true
        });
        listings.push(l);
        uint256 id = listings.length - 1;
        emit Listed(id, msg.sender, nft, tokenId, pricePerPeriod, periodSeconds);
        return id;
    }

    // Rent a listing for `n` periods. Pay exactly pricePerPeriod * n in wei.
    function rent(uint256 id, uint256 periods) external payable {
        require(id < listings.length && listings[id].exists, "no listing");
        Listing storage l = listings[id];
        require(l.renter == address(0) || block.timestamp >= l.expiry, "currently rented");
        require(periods > 0, "periods>0");
        uint256 total = l.pricePerPeriod * periods;
        require(msg.value == total, "wrong value");
        // set renter and expiry
        l.renter = msg.sender;
        l.expiry = block.timestamp + (l.periodSeconds * periods);
        // forward funds to owner
        payable(l.owner).transfer(msg.value);
        emit Rented(id, msg.sender, l.expiry);
    }

    // End lease early (renter or owner)
    function endLease(uint256 id) external {
        require(id < listings.length && listings[id].exists, "no listing");
        Listing storage l = listings[id];
        require(l.renter != address(0), "not rented");
        require(msg.sender == l.renter || msg.sender == l.owner, "not allowed");
        l.renter = address(0);
        l.expiry = 0;
        emit LeaseEnded(id);
    }

    // Owner can withdraw the NFT when it's not rented (or after expiry)
    function withdrawNFT(uint256 id) external {
        require(id < listings.length && listings[id].exists, "no listing");
        Listing storage l = listings[id];
        require(msg.sender == l.owner, "only owner");
        require(l.renter == address(0) || block.timestamp >= l.expiry, "currently rented");
        l.exists = false;
        IERC721(l.nft).safeTransferFrom(address(this), l.owner, l.tokenId);
        emit NFTWithdrawn(id, l.owner);
    }

    // Helpers
    function isActive(uint256 id) external view returns (bool) {
        if (id >= listings.length) return false;
        Listing storage l = listings[id];
        return l.exists && l.renter != address(0) && block.timestamp < l.expiry;
    }

    function listingCount() external view returns (uint256) { return listings.length; }

    // ERC721 receiver
    function onERC721Received(address, address, uint256, bytes calldata) external pure returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
