// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ReputationSystem {
    mapping(address => uint256) public reputation;
    mapping(address => bool) public moderators;

    event ReputationUpdated(address user, uint256 score);

    constructor() {
        moderators[msg.sender] = true;
    }

    function setModerator(address _mod, bool _status) external {
        require(moderators[msg.sender], "Not authorized");
        moderators[_mod] = _status;
    }

    function giveReputation(address _user, uint256 _score) external {
        require(moderators[msg.sender], "Only mods");
        reputation[_user] += _score;
        emit ReputationUpdated(_user, reputation[_user]);
    }

    function reduceReputation(address _user, uint256 _score) external {
        require(moderators[msg.sender], "Only mods");
        require(reputation[_user] >= _score, "Not enough rep");
        reputation[_user] -= _score;
        emit ReputationUpdated(_user, reputation[_user]);
    }
}
