pragma solidity ^0.8.0;

contract FixedRewardStaking {
    // State variables
    mapping(address => uint256) private _stakedBalances;
    mapping(address => uint256) private _stakeTimestamps;
    mapping(address => uint256) private _pendingRewards;

    // Constants
    uint256 public constant LOCK_DURATION = 5 days;
    uint256 public constant BASE_REWARD_RATE = 500; // 5% in basis points
    uint256 public constant EARLY_PENALTY = 3000; // 30% penalty in basis points

    // Payable function: Stake ETH
    function stake() external payable {
        require(msg.value > 0, "Minimum 1 wei");

        // Calculate reward for existing stake
        if (_stakedBalances[msg.sender] > 0) {
            _pendingRewards[msg.sender] += _calculateNewReward(msg.sender); // FIXED: changed to _calculateNewReward
        }

        // Update stake and reset timer
        _stakedBalances[msg.sender] += msg.value;
        _stakeTimestamps[msg.sender] = block.timestamp;
    }

    // Nonpayable function: Withdraw with penalty/reward
    function withdraw() external {
        require(_stakedBalances[msg.sender] > 0, "No stake");

        uint256 amount = _stakedBalances[msg.sender];
        uint256 reward = getCurrentReward(msg.sender);
        uint256 totalToSend = amount + reward;

        // Check contract balance before proceeding
        require(
            address(this).balance >= totalToSend,
            "Insufficient contract funds"
        );

        // Reset state before transfer
        _stakedBalances[msg.sender] = 0;
        _stakeTimestamps[msg.sender] = 0;
        _pendingRewards[msg.sender] = 0;

        // Send funds
        payable(msg.sender).transfer(totalToSend);
    }

    // View function: Current withdrawable reward
    function getCurrentReward(address user) public view returns (uint256) {
        if (_stakedBalances[user] == 0) return 0;

        uint256 base = _pendingRewards[user] + _calculateNewReward(user);
        uint256 stakedTime = block.timestamp - _stakeTimestamps[user];

        // Apply penalty if withdrawing early
        if (stakedTime < LOCK_DURATION) {
            uint256 penalty = (base * EARLY_PENALTY) / 10000;
            return base - penalty;
        }
        return base;
    }

    // View function: Get withdrawable amount (principal + reward)
    function getWithdrawableAmount(address user) public view returns (uint256) {
        return _stakedBalances[user] + getCurrentReward(user);
    }

    // View function: Get remaining lock time
    function getRemainingLockTime(address user) public view returns (uint256) {
        if (_stakedBalances[user] == 0) return 0;

        uint256 endTime = _stakeTimestamps[user] + LOCK_DURATION;
        return block.timestamp >= endTime ? 0 : endTime - block.timestamp;
    }

    // Internal helper: Calculate new rewards since last action
    function _calculateNewReward(address user) private view returns (uint256) {
        uint256 lastActionTime = _stakeTimestamps[user];
        uint256 rewardDuration = block.timestamp - lastActionTime;

        return
            (_stakedBalances[user] * BASE_REWARD_RATE * rewardDuration) /
            (LOCK_DURATION * 10000);
    }

    // Fallback function to receive ETH
    receive() external payable {}
}
