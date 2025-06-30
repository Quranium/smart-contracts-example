// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Payroll {
    address public manager;
    mapping(address => uint) public salaries;

    modifier onlyManager() {
        require(msg.sender == manager, "Only manager");
        _;
    }

    function setManager(address _manager) external {
        require(manager == address(0), "Manager already set");
        manager = _manager;
    }

    function assignSalary(address employee, uint amount) external onlyManager {
        salaries[employee] = amount;
    }

    function pay(address employee) external onlyManager {
        uint salary = salaries[employee];
        require(address(this).balance >= salary, "Insufficient funds");
        payable(employee).transfer(salary);
    }

    receive() external payable {}
}
