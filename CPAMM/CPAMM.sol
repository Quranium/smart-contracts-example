// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CPAMM {
    address public token0;
    address public token1;

    uint256 public reserve0;
    uint256 public reserve1;

    mapping(address => uint256) public shares;
    uint256 public totalShares;

    constructor(address _token0, address _token1) {
        require(_token0 != _token1, "Tokens must be different");
        token0 = _token0;
        token1 = _token1;
    }

    // Basic ERC20 transferFrom wrapper
    function _safeTransferFrom(address token, address from, address to, uint256 amount) private {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSignature("transferFrom(address,address,uint256)", from, to, amount)
        );
        require(success && (data.length == 0 || abi.decode(data, (bool))), "transferFrom failed");
    }

    // Basic ERC20 transfer wrapper
    function _safeTransfer(address token, address to, uint256 amount) private {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSignature("transfer(address,uint256)", to, amount)
        );
        require(success && (data.length == 0 || abi.decode(data, (bool))), "transfer failed");
    }

    function addLiquidity(uint256 amount0, uint256 amount1) external returns (uint256 share) {
        _safeTransferFrom(token0, msg.sender, address(this), amount0);
        _safeTransferFrom(token1, msg.sender, address(this), amount1);

        if (reserve0 > 0 || reserve1 > 0) {
            require(reserve0 * amount1 == reserve1 * amount0, "Invalid ratio");
        }

        if (totalShares == 0) {
            share = sqrt(amount0 * amount1);
        } else {
            share = min((amount0 * totalShares) / reserve0, (amount1 * totalShares) / reserve1);
        }

        require(share > 0, "Share = 0");

        shares[msg.sender] += share;
        totalShares += share;

        reserve0 += amount0;
        reserve1 += amount1;
    }

    function removeLiquidity(uint256 share) external returns (uint256 amount0, uint256 amount1) {
        require(shares[msg.sender] >= share, "Not enough shares");

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
        require(tokenIn == token0 || tokenIn == token1, "Invalid tokenIn");
        require(amountIn > 0, "amountIn = 0");

        bool isToken0In = tokenIn == token0;
        (address tokenOut, uint256 reserveIn, uint256 reserveOut) = isToken0In
            ? (token1, reserve0, reserve1)
            : (token0, reserve1, reserve0);

        _safeTransferFrom(tokenIn, msg.sender, address(this), amountIn);

        // 0.3% fee
        uint256 amountInWithFee = (amountIn * 997) / 1000;
        amountOut = (reserveOut * amountInWithFee) / (reserveIn + amountInWithFee);

        require(amountOut > 0, "amountOut = 0");
        _safeTransfer(tokenOut, msg.sender, amountOut);

        // Update reserves
        if (isToken0In) {
            reserve0 += amountIn;
            reserve1 -= amountOut;
        } else {
            reserve1 += amountIn;
            reserve0 -= amountOut;
        }
    }

    // -----------------------
    // Utils
    // -----------------------
    function min(uint256 x, uint256 y) private pure returns (uint256) {
        return x < y ? x : y;
    }

    function sqrt(uint y) private pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}
