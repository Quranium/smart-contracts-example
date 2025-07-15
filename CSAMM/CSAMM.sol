// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CSAMM {
    address public immutable token0;
    address public immutable token1;

    uint256 public reserve0;
    uint256 public reserve1;

    mapping(address => uint256) public shares;
    uint256 public totalShares;

    constructor(address _token0, address _token1) {
        require(_token0 != _token1, "Tokens must differ");
        token0 = _token0;
        token1 = _token1;
    }

    // Safe ERC20 transferFrom wrapper
    function _safeTransferFrom(address token, address from, address to, uint256 amount) private {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSignature("transferFrom(address,address,uint256)", from, to, amount)
        );
        require(success && (data.length == 0 || abi.decode(data, (bool))), "transferFrom failed");
    }

    // Safe ERC20 transfer wrapper
    function _safeTransfer(address token, address to, uint256 amount) private {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSignature("transfer(address,uint256)", to, amount)
        );
        require(success && (data.length == 0 || abi.decode(data, (bool))), "transfer failed");
    }

    function addLiquidity(uint256 amount0, uint256 amount1) external returns (uint256 share) {
        _safeTransferFrom(token0, msg.sender, address(this), amount0);
        _safeTransferFrom(token1, msg.sender, address(this), amount1);

        if (totalShares == 0) {
            share = amount0 + amount1;
        } else {
            share = ((amount0 + amount1) * totalShares) / (reserve0 + reserve1);
        }

        require(share > 0, "Zero share");

        shares[msg.sender] += share;
        totalShares += share;

        reserve0 += amount0;
        reserve1 += amount1;
    }

    function removeLiquidity(uint256 share) external returns (uint256 amount0, uint256 amount1) {
        require(shares[msg.sender] >= share, "Not enough share");

        amount0 = (share * reserve0) / totalShares;
        amount1 = (share * reserve1) / totalShares;

        shares[msg.sender] -= share;
        totalShares -= share;

        reserve0 -= amount0;
        reserve1 -= amount1;

        _safeTransfer(token0, msg.sender, amount0);
        _safeTransfer(token1, msg.sender, amount1);
    }

    function swap(address tokenIn, uint256 amountIn) external returns (uint256 amountOut) {
        require(tokenIn == token0 || tokenIn == token1, "Invalid token");

        bool isToken0In = tokenIn == token0;
        address tokenOut = isToken0In ? token1 : token0;

        uint256 reserveIn = isToken0In ? reserve0 : reserve1;
        uint256 reserveOut = isToken0In ? reserve1 : reserve0;

        _safeTransferFrom(tokenIn, msg.sender, address(this), amountIn);

        // 0.3% fee
        uint256 amountInWithFee = (amountIn * 997) / 1000;

        require(amountInWithFee <= reserveOut, "Insufficient liquidity");

        amountOut = amountInWithFee;

        if (isToken0In) {
            reserve0 += amountIn;
            reserve1 -= amountOut;
        } else {
            reserve1 += amountIn;
            reserve0 -= amountOut;
        }

        _safeTransfer(tokenOut, msg.sender, amountOut);
    }
}
