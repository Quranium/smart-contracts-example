// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Escrow {
    //enum to show the different states of escrow: ranging from not initiated to delivered, completed 
    enum EscrowState {
        NOT_INITIATED,
        AWAITING_DELIVERY,
        DELIVERED,
        COMPLETED,
        REFUNDED,
        CANCELLED
    } 

    address public depositor;
    address public beneficiary;
    address public arbiter;
    uint256 public amount;
    EscrowState private state;

    uint256 public deadline; //the time now plus the time added by the deployer of the contract, or the initiator
    bool public isDeliveryConfirmed;

    modifier onlyDepositor() {
        require(msg.sender == depositor, "Only depositor allowed");
        _;
    }

    modifier onlyBeneficiary() {
        require(msg.sender == beneficiary, "Only beneficiary allowed");
        _;
    }

    modifier onlyArbiterOrDepositor() {
        require(msg.sender == arbiter || msg.sender == depositor, "Not authorized");
        _;
    }

    modifier inState(EscrowState _state) {
        require(state == _state, "Invalid state for this action");
        _;
    }

    event Deposited(address indexed from, uint256 amount); //
    event DeliveryMarked(address indexed by);
    event Released(address indexed to, uint256 amount);
    event Refunded(address indexed to, uint256 amount);
    event Cancelled(address indexed by);
    event DeadlinePassed(address indexed by);

    constructor(address _beneficiary, address _arbiter, uint256 _durationInSeconds) payable {
        require(msg.value > 0, "Must send ETH to escrow");
        depositor = msg.sender;
        beneficiary = _beneficiary;
        arbiter = _arbiter;
        amount = msg.value;
        deadline = block.timestamp + _durationInSeconds;
        state = EscrowState.AWAITING_DELIVERY;

        emit Deposited(depositor, amount);
    }
    //marks as delivered :) 
    function markAsDelivered() external onlyBeneficiary inState(EscrowState.AWAITING_DELIVERY) {
        isDeliveryConfirmed = true;
        state = EscrowState.DELIVERED;
        emit DeliveryMarked(msg.sender);
    }
    //releases the funds to beneficiary 
    function releaseToBeneficiary() external onlyDepositor inState(EscrowState.DELIVERED) {
        state = EscrowState.COMPLETED;
        payable(beneficiary).transfer(amount);
        emit Released(beneficiary, amount);
    }
    //If the beneficiary fails to do the work and refunds it, it returns to the account
    function refundToDepositor() external onlyArbiterOrDepositor inState(EscrowState.AWAITING_DELIVERY) {
        state = EscrowState.REFUNDED;
        payable(depositor).transfer(amount);
        emit Refunded(depositor, amount);
    }
    //Stops the escrow and emits the event
    function cancelEscrow() external onlyDepositor inState(EscrowState.AWAITING_DELIVERY) {
        require(block.timestamp < deadline, "Deadline passed");
        state = EscrowState.CANCELLED;
        payable(depositor).transfer(amount);
        emit Cancelled(msg.sender);
    }
    //uses arbiter a different account or wallet to solve disputes
    function resolveDispute(bool releaseToFreelancer) external {
        require(msg.sender == arbiter, "Only arbiter can resolve");
        require(state == EscrowState.AWAITING_DELIVERY || state == EscrowState.DELIVERED, "Cannot resolve");

        if (releaseToFreelancer) {
            state = EscrowState.COMPLETED;
            payable(beneficiary).transfer(amount);
            emit Released(beneficiary, amount);
        } else {
            state = EscrowState.REFUNDED;
            payable(depositor).transfer(amount);
            emit Refunded(depositor, amount);
        }
    }
    //If the escrow fund is not claimed within three days of finish or deadline after delivery, automatic claim
    function claimAfterDeadline() external onlyDepositor inState(EscrowState.DELIVERED) {
        require(block.timestamp > deadline + 3 days, "Claim period not met");
        // If no one responded for 3 days after delivery
        state = EscrowState.COMPLETED;
        payable(beneficiary).transfer(amount);
        emit DeadlinePassed(msg.sender);
    }
    //Returns the full details of the escrow
    function getEscrowDetails() external view returns (
        address _depositor,
        address _beneficiary,
        address _arbiter,
        uint256 _amount,
        EscrowState _state,
        uint256 _deadline,
        bool _isDeliveryConfirmed
    ) {
        return (depositor, beneficiary, arbiter, amount, state, deadline, isDeliveryConfirmed);
    }
    //Gets the work state 
    function getWorkState() public view returns (string memory) {
        if (state == EscrowState.NOT_INITIATED) return "NOT_INITIATED";
        else if (state == EscrowState.AWAITING_DELIVERY) return "AWAITING_DELIVERY";
        else if (state == EscrowState.DELIVERED) return "DELIVERED";
        else if (state == EscrowState.COMPLETED) return "COMPLETED";
        else if (state == EscrowState.REFUNDED) return "REFUNDED";
        if (state == EscrowState.CANCELLED) return "CANCELLED";
        return "UNKNOWN";
    }

}
