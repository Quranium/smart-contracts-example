// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TokenAuction {
    address public seller;
    address public token;
    uint256 public tokensForSale;
    uint256 public endTime;

    address public highestBidder;
    uint256 public highestBid;

    bool public tokensClaimed;
    bool public ethClaimed;

    mapping(address => uint256) public bids;

    constructor(address _token, uint256 _tokensForSale, uint256 _duration) {
        seller = msg.sender;
        token = _token;
        tokensForSale = _tokensForSale;
        endTime = block.timestamp + _duration;
    }

    function _safeTransferFrom(address _token, address from, address to, uint256 amount) internal {
        (bool success, bytes memory data) = _token.call(
            abi.encodeWithSignature("transferFrom(address,address,uint256)", from, to, amount)
        );
        require(success && (data.length == 0 || abi.decode(data, (bool))), "TransferFrom failed");
    }

    function _safeTransfer(address _token, address to, uint256 amount) internal {
        (bool success, bytes memory data) = _token.call(
            abi.encodeWithSignature("transfer(address,uint256)", to, amount)
        );
        require(success && (data.length == 0 || abi.decode(data, (bool))), "Transfer failed");
    }

    function depositTokens() external {
        require(msg.sender == seller, "Only seller");
        _safeTransferFrom(token, msg.sender, address(this), tokensForSale);
    }

    function bid() external payable {
        require(block.timestamp < endTime, "Auction ended");
        require(msg.value > 0, "Bid must be > 0");

        bids[msg.sender] += msg.value;

        if (bids[msg.sender] > highestBid) {
            highestBid = bids[msg.sender];
            highestBidder = msg.sender;
        }
    }

    function claimTokens() external {
        require(block.timestamp >= endTime, "Auction not ended");
        require(msg.sender == highestBidder, "Not winner");
        require(!tokensClaimed, "Tokens already claimed");

        tokensClaimed = true;
        _safeTransfer(token, highestBidder, tokensForSale);
    }

    function claimETH() external {
        require(block.timestamp >= endTime, "Auction not ended");
        require(msg.sender == seller, "Not seller");
        require(!ethClaimed, "ETH already claimed");

        ethClaimed = true;
        payable(seller).transfer(highestBid);
    }

    function refund() external {
        require(block.timestamp >= endTime, "Auction not ended");
        require(msg.sender != highestBidder, "Winner can't refund");

        uint256 amount = bids[msg.sender];
        require(amount > 0, "Nothing to refund");

        bids[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}
