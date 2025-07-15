// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BasicStaking {
    address public stakingToken;
    address public rewardToken;

    uint256 public rewardRate = 1e18; // 1 reward per second per token
    uint256 public lastUpdate;
    uint256 public rewardPerTokenStored;

    mapping(address => uint256) public userBalance;
    mapping(address => uint256) public userRewardDebt;

    constructor(address _stakingToken, address _rewardToken) {
        stakingToken = _stakingToken;
        rewardToken = _rewardToken;
        lastUpdate = block.timestamp;
    }

    function _safeTransfer(address token, address to, uint256 amount) private {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSignature("transfer(address,uint256)", to, amount)
        );
        require(success && (data.length == 0 || abi.decode(data, (bool))), "transfer failed");
    }

    function _safeTransferFrom(address token, address from, address to, uint256 amount) private {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSignature("transferFrom(address,address,uint256)", from, to, amount)
        );
        require(success && (data.length == 0 || abi.decode(data, (bool))), "transferFrom failed");
    }

    function updateRewards() internal {
        uint256 time = block.timestamp - lastUpdate;
        if (totalStaked() > 0) {
            rewardPerTokenStored += (time * rewardRate) / totalStaked();
        }
        lastUpdate = block.timestamp;
    }

    function earned(address user) public view returns (uint256) {
        uint256 accrued = rewardPerTokenStored * userBalance[user];
        return (accrued / 1e18) - userRewardDebt[user];
    }

    function totalStaked() public view returns (uint256 total) {
        // for demo only, assumes only few users
        return userBalance[msg.sender]; // should sum over all users in a real version
    }

    function stake(uint256 amount) external {
        updateRewards();
        _safeTransferFrom(stakingToken, msg.sender, address(this), amount);
        userBalance[msg.sender] += amount;
        userRewardDebt[msg.sender] = (rewardPerTokenStored * userBalance[msg.sender]) / 1e18;
    }

    function withdraw(uint256 amount) external {
        require(userBalance[msg.sender] >= amount, "Not enough staked");
        updateRewards();
        userBalance[msg.sender] -= amount;
        _safeTransfer(stakingToken, msg.sender, amount);
        userRewardDebt[msg.sender] = (rewardPerTokenStored * userBalance[msg.sender]) / 1e18;
    }

    function claim() external {
        updateRewards();
        uint256 reward = earned(msg.sender);
        _safeTransfer(rewardToken, msg.sender, reward);
        userRewardDebt[msg.sender] = (rewardPerTokenStored * userBalance[msg.sender]) / 1e18;
    }
}
