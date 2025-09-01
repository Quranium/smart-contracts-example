// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

/// @notice Standard ERC20 interface
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}

/// @notice DEX Contract
contract DEX {
    address public token;
    mapping(address => uint256) public liquidity;
    uint256 public totalLiquidity;

    constructor(address _token) {
        token = _token;
    }

    function getTokensInContract() public view returns (uint256) {
        return IERC20(token).balanceOf(address(this));
    }

    function addLiquidity(uint256 _amount) public payable returns (uint256) {
        uint256 liquidityMinted;
        uint256 ethReserve = address(this).balance - msg.value;
        uint256 tokenReserve = getTokensInContract();

        if (tokenReserve == 0) {
            // First liquidity provider
            IERC20(token).transferFrom(msg.sender, address(this), _amount);
            liquidityMinted = address(this).balance;
            liquidity[msg.sender] = liquidityMinted;
            totalLiquidity = liquidityMinted;
        } else {
            uint256 requiredTokenAmount = (msg.value * tokenReserve) / ethReserve;
            require(_amount >= requiredTokenAmount, "Insufficient token amount");
            IERC20(token).transferFrom(msg.sender, address(this), requiredTokenAmount);
            liquidityMinted = (msg.value * totalLiquidity) / ethReserve;
            liquidity[msg.sender] += liquidityMinted;
            totalLiquidity += liquidityMinted;
        }

        return liquidityMinted;
    }

    function removeLiquidity(uint256 _amount) public returns (uint256, uint256) {
        require(_amount > 0, "Amount must be > 0");
        require(liquidity[msg.sender] >= _amount, "Insufficient liquidity");

        uint256 ethAmount = (address(this).balance * _amount) / totalLiquidity;
        uint256 tokenAmount = (getTokensInContract() * _amount) / totalLiquidity;

        liquidity[msg.sender] -= _amount;
        totalLiquidity -= _amount;

        payable(msg.sender).transfer(ethAmount);
        IERC20(token).transfer(msg.sender, tokenAmount);

        return (ethAmount, tokenAmount);
    }

    function getAmountOfTokens(
        uint256 inputAmount,
        uint256 inputReserve,
        uint256 outputReserve
    ) public pure returns (uint256) {
        require(inputReserve > 0 && outputReserve > 0, "Invalid reserves");
        uint256 inputAmountWithFee = inputAmount * 99 / 100; // 1% fee
        uint256 numerator = inputAmountWithFee * outputReserve;
        uint256 denominator = inputReserve * 100 + inputAmountWithFee;
        return numerator / denominator;
    }

    function swapEthToToken() public payable {
        uint256 tokenReserve = getTokensInContract();
        uint256 tokensBought = getAmountOfTokens(
            msg.value,
            address(this).balance - msg.value,
            tokenReserve
        );
        IERC20(token).transfer(msg.sender, tokensBought);
    }

    function swapTokenToEth(uint256 _tokensSold) public {
        uint256 tokenReserve = getTokensInContract();
        uint256 ethBought = getAmountOfTokens(
            _tokensSold,
            tokenReserve,
            address(this).balance
        );
        IERC20(token).transferFrom(msg.sender, address(this), _tokensSold);
        payable(msg.sender).transfer(ethBought);
    }

    receive() external payable {}
}
