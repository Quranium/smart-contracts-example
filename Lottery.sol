// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleLottery {
    address public manager;
    address payable[] public participants;
    bool public isActive;
    uint256 public ticketPrice;
    uint256 public drawBlock;
    
    constructor(uint256 _ticketPrice) {
        manager = msg.sender;
        ticketPrice = _ticketPrice;
        isActive = true;
    }
    
    modifier onlyManager() {
        require(msg.sender == manager, "Only manager can call this");
        _;
    }
    
    receive() external payable {
        enterLottery();
    }
    
    function enterLottery() public payable {
        require(isActive, "Lottery is closed");
        require(msg.value == ticketPrice, "Incorrect ETH amount");
        participants.push(payable(msg.sender));
    }
    
    function drawWinner() public onlyManager {
        require(isActive, "Lottery already closed");
        require(participants.length >= 3, "Need at least 3 participants");
        
        // Set future block for randomness
        drawBlock = block.number + 5;
        isActive = false;
    }
    
    function completeDraw() public onlyManager {
        require(!isActive, "Must initiate draw first");
        require(block.number > drawBlock, "Too early to complete");
        require(participants.length > 0, "No participants");
        
        // Generate pseudo-random number using future block data
        uint256 seed = uint256(
            keccak256(
                abi.encodePacked(
                    blockhash(drawBlock),
                    block.timestamp
                )
            )
        );
        uint256 winnerIndex = seed % participants.length;
        address payable winner = participants[winnerIndex];
        
        // Distribute prize
        uint256 prize = address(this).balance;
        (bool success, ) = winner.call{value: prize}("");
        require(success, "Transfer failed");
        
        // Reset lottery
        participants = new address payable[](0);
        isActive = true;
    }
    
    function getParticipantsCount() public view returns (uint) {
        return participants.length;
    }
    
    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }
}
