// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function transfer(address to, uint256 value) external returns (bool);
}

contract DonationTracker {
    struct Campaign {
        address owner;
        string title;
        address goalToken; // address(0) means ETH
        uint256 goalAmount;
        uint256 deadline; // 0 = no deadline
        bool exists;
    }

    Campaign[] public campaigns;

    // donations[campaignId][token][donor] = amount
    mapping(uint256 => mapping(address => mapping(address => uint256))) public donations;
    // totalRaised[campaignId][token]
    mapping(uint256 => mapping(address => uint256)) public totalRaised;
    // withdrawn amounts by owner per campaign/token
    mapping(uint256 => mapping(address => uint256)) public withdrawn;

    event CampaignCreated(uint256 indexed id, address indexed owner, string title, address goalToken, uint256 goalAmount, uint256 deadline);
    event Donated(uint256 indexed id, address indexed donor, address token, uint256 amount);
    event Withdrawn(uint256 indexed id, address indexed owner, address token, uint256 amount);
    event Refunded(uint256 indexed id, address indexed donor, address token, uint256 amount);

    // create a campaign; goalToken == address(0) means ETH goal
    function createCampaign(string calldata title, address goalToken, uint256 goalAmount, uint256 deadline) external returns (uint256) {
        Campaign memory c = Campaign({owner: msg.sender, title: title, goalToken: goalToken, goalAmount: goalAmount, deadline: deadline, exists: true});
        campaigns.push(c);
        uint256 id = campaigns.length - 1;
        emit CampaignCreated(id, msg.sender, title, goalToken, goalAmount, deadline);
        return id;
    }

    // Donate ETH to campaign
    function donateETH(uint256 id) external payable {
        require(id < campaigns.length && campaigns[id].exists, "no campaign");
        require(msg.value > 0, "zero");
        donations[id][address(0)][msg.sender] += msg.value;
        totalRaised[id][address(0)] += msg.value;
        emit Donated(id, msg.sender, address(0), msg.value);
    }

    // Donate ERC20 to campaign (buyer must approve first)
    function donateERC20(uint256 id, address token, uint256 amount) external {
        require(id < campaigns.length && campaigns[id].exists, "no campaign");
        require(token != address(0), "token zero");
        require(amount > 0, "zero");
        bool ok = IERC20(token).transferFrom(msg.sender, address(this), amount);
        require(ok, "transfer failed");
        donations[id][token][msg.sender] += amount;
        totalRaised[id][token] += amount;
        emit Donated(id, msg.sender, token, amount);
    }

    // Owner withdraws funds for a given token (address(0) = ETH)
    function withdraw(uint256 id, address token, uint256 amount) external {
        require(id < campaigns.length && campaigns[id].exists, "no campaign");
        Campaign storage c = campaigns[id];
        require(msg.sender == c.owner, "only owner");
        require(amount > 0, "zero");
        // campaign success check
        require(_isWithdrawAllowed(id, token), "withdraw not allowed");
        uint256 available = totalRaised[id][token] - withdrawn[id][token];
        require(amount <= available, "insufficient");
        withdrawn[id][token] += amount;
        if (token == address(0)) {
            payable(msg.sender).transfer(amount);
        } else {
            bool ok = IERC20(token).transfer(msg.sender, amount);
            require(ok, "token transfer failed");
        }
        emit Withdrawn(id, msg.sender, token, amount);
    }

    // Donor refunds their donation (only if campaign failed: goal set, deadline passed, goal not met)
    function refund(uint256 id, address token) external {
        require(id < campaigns.length && campaigns[id].exists, "no campaign");
        Campaign storage c = campaigns[id];
        require(c.goalAmount > 0 && c.deadline > 0, "no refundable campaign");
        require(block.timestamp > c.deadline, "deadline not passed");
        // check goal failure
        uint256 raisedForGoal = totalRaised[id][c.goalToken];
        require(raisedForGoal < c.goalAmount, "goal met");
        uint256 amt = donations[id][token][msg.sender];
        require(amt > 0, "no donation");
        donations[id][token][msg.sender] = 0;
        totalRaised[id][token] -= amt;
        if (token == address(0)) {
            payable(msg.sender).transfer(amt);
        } else {
            bool ok = IERC20(token).transfer(msg.sender, amt);
            require(ok, "token transfer failed");
        }
        emit Refunded(id, msg.sender, token, amt);
    }

    // View helpers
    function campaignCount() external view returns (uint256) { return campaigns.length; }

    function getCampaign(uint256 id) external view returns (address owner, string memory title, address goalToken, uint256 goalAmount, uint256 deadline) {
        require(id < campaigns.length && campaigns[id].exists, "no campaign");
        Campaign storage c = campaigns[id];
        return (c.owner, c.title, c.goalToken, c.goalAmount, c.deadline);
    }

    function donatedAmount(uint256 id, address token, address donor) external view returns (uint256) {
        return donations[id][token][donor];
    }

    // Internal: whether owner can withdraw token for campaign
    function _isWithdrawAllowed(uint256 id, address token) internal view returns (bool) {
        Campaign storage c = campaigns[id];
        // if no goal set, owner can withdraw anytime
        if (c.goalAmount == 0) return true;
        // if goal exists, success when totalRaised for goalToken >= goalAmount
        if (totalRaised[id][c.goalToken] >= c.goalAmount) return true;
        // otherwise not allowed (deadline alone doesn't allow withdraw)
        return false;
    }
}
