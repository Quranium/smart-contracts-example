// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title SimpleLottery - A minimal lottery contract for 3 players with timeout and refund
/// @notice Players join by paying 0.01 ether. When 3 players join, a random winner is chosen.
/// @dev Randomness uses blockhash, which is insecure for production. Owner can trigger refunds if timeout passes.
contract SimpleLottery {
    address payable[3] public players; // Fixed array to store player addresses
    uint public playerCount = 0; // Number of players currently entered
    uint public constant ENTRY_FEE = 0.01 ether; // Entry fee for the lottery
    bool public winnerSelected = false; // Flag to indicate if a winner was chosen
    address public winner; // Address of the winner
    address public owner; // Contract owner (deployer)
    uint public timeoutBlock;  // Block number after which refund is allowed

    /// @notice Restricts access to only the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    /// @notice Emitted when a new player joins the lottery
    /// @param player Address of the player that joined
    event PlayerJoined(address indexed player);

    /// @notice Emitted when a winner is selected
    /// @param winner Address of the winner
    event WinnerSelected(address indexed winner);

    /// @notice Emitted when a refund is issued to players
    event RefundIssued();

    /// @notice Initializes the lottery contract with a timeout block
    /// @param _timeoutBlock The block number after which refund can be triggered
    constructor(uint _timeoutBlock) {
        owner = msg.sender;
        timeoutBlock = _timeoutBlock;
    }

    /// @notice Enter the lottery by paying exactly 0.01 ether
    /// @dev Reverts if already joined, if fee is wrong, or if lottery is full
    function enter() external payable {
        require(!winnerSelected, "Game finished");
        require(playerCount < 3, "Lottery full");
        require(msg.value == ENTRY_FEE, "Deposit exact fee");

        // Prevent duplicate entries
        for (uint i = 0; i < playerCount; i++) {
            require(players[i] != msg.sender, "Already joined");
        }

        // Add new player
        players[playerCount] = payable(msg.sender);
        playerCount++;

        emit PlayerJoined(msg.sender);

        // If 3 players have joined, pick a winner
        if (playerCount == 3) {
            _pickWinner();
        }
    }

    /// @notice Picks a random winner once 3 players have entered
    /// @dev Uses blockhash for pseudo-randomness (not secure for real money)
    function _pickWinner() internal {
        require(playerCount == 3, "Not enough players");

        // Pick random index (0, 1, or 2)
        uint randomIndex = uint(blockhash(block.number - 1)) % 3;
        winner = players[randomIndex];
        winnerSelected = true;

        emit WinnerSelected(winner);

        _payout();
    }

    /// @notice Transfers the entire contract balance to the winner
    function _payout() internal {
        payable(winner).transfer(address(this).balance);
    }

    /// @notice Refunds players if the lottery did not finish before the timeout
    /// @dev Only the owner can call this, after `timeoutBlock`
    function refund() external onlyOwner {
        require(!winnerSelected, "Winner already selected");
        require(block.number >= timeoutBlock, "Timeout not reached yet");

        // Refund all entered players
        for (uint i = 0; i < playerCount; i++) {
            players[i].transfer(ENTRY_FEE);
        }
        playerCount = 0;

        emit RefundIssued();
    }
}
