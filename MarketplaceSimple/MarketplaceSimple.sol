// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function ownerOf(uint256 tokenId) external view returns (address);
}

interface IERC20 {
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function transfer(address to, uint256 value) external returns (bool);
}

contract MarketplaceSimple {
    struct Listing {
        address nft;
        uint256 tokenId;
        address seller;
        address paymentToken; // address(0) = ETH
        uint256 price;
        bool active;
    }

    uint256 public nextId;
    mapping(uint256 => Listing) public listings;

    // seller => ETH balance
    mapping(address => uint256) public pendingETH;
    // token => seller => balance
    mapping(address => mapping(address => uint256)) public pendingToken;

    event Listed(uint256 indexed id, address indexed seller, address nft, uint256 tokenId, address paymentToken, uint256 price);
    event Bought(uint256 indexed id, address indexed buyer, uint256 price);
    event Delisted(uint256 indexed id);
    event WithdrawnETH(address indexed seller, uint256 amount);
    event WithdrawnToken(address indexed seller, address indexed token, uint256 amount);

    // List an ERC721. Caller must approve this contract for tokenId.
    function listItem(address nft, uint256 tokenId, address paymentToken, uint256 price) external returns (uint256) {
        require(price > 0, "price>0");
        // transfer NFT into custody
        IERC721(nft).safeTransferFrom(msg.sender, address(this), tokenId);
        uint256 id = nextId++;
        listings[id] = Listing({nft: nft, tokenId: tokenId, seller: msg.sender, paymentToken: paymentToken, price: price, active: true});
        emit Listed(id, msg.sender, nft, tokenId, paymentToken, price);
        return id;
    }

    // Buy listing. For ETH listings send exact msg.value. For ERC20 listings buyer must approve marketplace first.
    function buy(uint256 id) external payable {
        Listing storage l = listings[id];
        require(l.active, "not active");
        require(l.seller != msg.sender, "seller");
        l.active = false;

        if (l.paymentToken == address(0)) {
            // ETH purchase
            require(msg.value == l.price, "wrong value");
            pendingETH[l.seller] += msg.value;
        } else {
            // ERC20 purchase
            require(msg.value == 0, "no ETH");
            bool ok = IERC20(l.paymentToken).transferFrom(msg.sender, address(this), l.price);
            require(ok, "token transfer failed");
            pendingToken[l.paymentToken][l.seller] += l.price;
        }

        // transfer NFT to buyer
        IERC721(l.nft).safeTransferFrom(address(this), msg.sender, l.tokenId);
        emit Bought(id, msg.sender, l.price);
    }

    // Seller can cancel listing and retrieve NFT if still active
    function delist(uint256 id) external {
        Listing storage l = listings[id];
        require(l.active, "not active");
        require(msg.sender == l.seller, "only seller");
        l.active = false;
        IERC721(l.nft).safeTransferFrom(address(this), l.seller, l.tokenId);
        emit Delisted(id);
    }

    // Withdraw ETH proceeds
    function withdrawETH() external {
        uint256 amt = pendingETH[msg.sender];
        require(amt > 0, "no funds");
        pendingETH[msg.sender] = 0;
        payable(msg.sender).transfer(amt);
        emit WithdrawnETH(msg.sender, amt);
    }

    // Withdraw ERC20 proceeds for a given token
    function withdrawToken(address token) external {
        uint256 amt = pendingToken[token][msg.sender];
        require(amt > 0, "no funds");
        pendingToken[token][msg.sender] = 0;
        bool ok = IERC20(token).transfer(msg.sender, amt);
        require(ok, "token transfer failed");
        emit WithdrawnToken(msg.sender, token, amt);
    }

    // View helpers
    function listingExists(uint256 id) external view returns (bool) { return id < nextId && listings[id].active; }

    // Minimal ERC721 receiver
    function onERC721Received(address, address, uint256, bytes calldata) external pure returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
