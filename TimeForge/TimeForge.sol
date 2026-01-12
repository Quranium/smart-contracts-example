// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TimeForge is ERC721URIStorage, Ownable {
    uint256 public nextTokenId;

    struct Challenge {
        address user;
        uint256 startTime;
        uint256 durationDays;
        uint256 lastCheckIn;
        uint256 checkIns;
        bool completed;
        bool failed;
    }

    mapping(address => Challenge) public challenges;

    constructor() ERC721("TimeForgeNFT", "TFN") {}

    modifier onlyActiveChallenge() {
        require(challenges[msg.sender].user != address(0), "No active challenge");
        require(!challenges[msg.sender].completed, "Challenge already completed");
        require(!challenges[msg.sender].failed, "Challenge failed");
        _;
    }

    function startChallenge(uint256 _durationDays) external {
        require(challenges[msg.sender].user == address(0), "Challenge already started");

        challenges[msg.sender] = Challenge({
            user: msg.sender,
            startTime: block.timestamp,
            durationDays: _durationDays,
            lastCheckIn: block.timestamp,
            checkIns: 0,
            completed: false,
            failed: false
        });
    }

    function checkIn() external onlyActiveChallenge {
        Challenge storage c = challenges[msg.sender];
        require(block.timestamp >= c.lastCheckIn + 23 hours, "Check-in too soon");
        require(block.timestamp <= c.startTime + c.durationDays * 1 days, "Challenge expired");

        c.checkIns += 1;
        c.lastCheckIn = block.timestamp;

        if (c.checkIns >= c.durationDays) {
            c.completed = true;
            _mintNFT(msg.sender);
        }
    }

    function failChallenge() external onlyActiveChallenge {
        Challenge storage c = challenges[msg.sender];
        if (block.timestamp > c.lastCheckIn + 48 hours) {
            c.failed = true;
        }
    }

    function _mintNFT(address to) internal {
        uint256 tokenId = nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, "ipfs://your_generated_metadata"); // Link to badge
    }

    function getChallengeStatus(address user) public view returns (string memory) {
        Challenge memory c = challenges[user];
        if (c.failed) return "Failed";
        if (c.completed) return "Completed";
        return "In Progress";
    }
}
