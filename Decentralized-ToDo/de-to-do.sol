// SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;

/// @title DecentralizedTodoList - On-chain to-do manager
/// @notice Users can create and complete tasks on-chain
/// @dev Stores user-specific task lists in mappings
contract DecentralizedTodoList {
    struct Task {
        string description;
        bool completed;
    }

    mapping(address => Task[]) private tasks;

    event TaskCreated(address indexed user, uint256 taskId, string description);
    event TaskCompleted(address indexed user, uint256 taskId);

    /// @notice Add a new task to sender's list
    /// @param description Description of the task
    function createTask(string calldata description) external {
        tasks[msg.sender].push(Task(description, false));
        emit TaskCreated(msg.sender, tasks[msg.sender].length - 1, description);
    }

    /// @notice Mark a task as completed
    /// @param taskId Index of the task to mark complete
    function completeTask(uint256 taskId) external {
        require(taskId < tasks[msg.sender].length, "Invalid task ID");
        require(!tasks[msg.sender][taskId].completed, "Already completed");

        tasks[msg.sender][taskId].completed = true;
        emit TaskCompleted(msg.sender, taskId);
    }

    /// @notice Get all tasks of sender
    /// @return Array of Task structs
    function getMyTasks() external view returns (Task[] memory) {
        return tasks[msg.sender];
    }
}
