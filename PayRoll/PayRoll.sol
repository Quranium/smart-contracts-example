// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Payroll - A basic contract to assign and pay salaries by a manager
contract Payroll {
    address public manager;
    mapping(address => uint) public salaries;

    /// @dev Restricts function execution to the manager only
    modifier onlyManager() {
        require(msg.sender == manager, "Only manager");
        _;
    }

    /// @notice Initializes the manager of the contract
    /// @param _manager Address to be set as manager
    function setManager(address _manager) external {
        require(manager == address(0), "Manager already set");
        manager = _manager;
    }

    /// @notice Assigns a salary to an employee
    /// @param employee Address of the employee
    /// @param amount Salary amount in wei
    function assignSalary(address employee, uint amount) external onlyManager {
        salaries[employee] = amount;
    }

    /// @notice Pays the assigned salary to the specified employee
    /// @param employee Address of the employee to pay
    function pay(address employee) external onlyManager {
        uint salary = salaries[employee];
        require(address(this).balance >= salary, "Insufficient funds");
        payable(employee).transfer(salary);
    }

    /// @notice Allows the contract to receive ETH for salary payouts
    receive() external payable {}
}
