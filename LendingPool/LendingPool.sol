// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleLendingPool {
    address public token;
    uint256 public collateralRatio = 150; // 150% collateral

    mapping(address => uint256) public collateralETH;
    mapping(address => uint256) public debt;

    constructor(address _token) {
        token = _token;
    }

    receive() external payable {}

    function _safeTransfer(address _token, address to, uint256 amount) private {
        (bool success, bytes memory data) = _token.call(
            abi.encodeWithSignature("transfer(address,uint256)", to, amount)
        );
        require(success && (data.length == 0 || abi.decode(data, (bool))), "Transfer failed");
    }

    function _safeTransferFrom(address _token, address from, address to, uint256 amount) private {
        (bool success, bytes memory data) = _token.call(
            abi.encodeWithSignature("transferFrom(address,address,uint256)", from, to, amount)
        );
        require(success && (data.length == 0 || abi.decode(data, (bool))), "TransferFrom failed");
    }

    function depositCollateral() external payable {
        require(msg.value > 0, "Zero ETH");
        collateralETH[msg.sender] += msg.value;
    }

    function borrow(uint256 amount) external {
        require(amount > 0, "Zero borrow");

        uint256 ethValue = collateralETH[msg.sender];
        uint256 maxBorrow = (ethValue * 100) / collateralRatio;

        require(debt[msg.sender] + amount <= maxBorrow, "Overborrow");

        debt[msg.sender] += amount;
        _safeTransfer(token, msg.sender, amount);
    }

    function repay(uint256 amount) external {
        _safeTransferFrom(token, msg.sender, address(this), amount);
        debt[msg.sender] -= amount;
    }

    function withdrawCollateral(uint256 amount) external {
        require(collateralETH[msg.sender] >= amount, "Too much");

        // Ensure health factor is good
        uint256 newCollateral = collateralETH[msg.sender] - amount;
        uint256 maxBorrow = (newCollateral * 100) / collateralRatio;
        require(debt[msg.sender] <= maxBorrow, "Would become undercollateralized");

        collateralETH[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }
}
