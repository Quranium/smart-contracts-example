// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract OfficeAccessAndAttendance {
    address public owner;

    struct Employee {
        bool isActive;
        string name;
    }

    mapping(address => Employee) public employees;
    mapping(address => mapping(uint256 => bool)) public checkInLog;
    mapping(address => mapping(uint256 => bool)) public checkOutLog;

    event EmployeeAdded(address indexed employee, string name);
    event EmployeeRemoved(address indexed employee);
    event CheckedIn(address indexed employee, uint256 day);
    event CheckedOut(address indexed employee, uint256 day);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    modifier onlyEmployee() {
        require(employees[msg.sender].isActive, "Not an active employee");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addEmployee(address _employee, string memory _name) external onlyOwner {
        employees[_employee] = Employee(true, _name);
        emit EmployeeAdded(_employee, _name);
    }

    function removeEmployee(address _employee) external onlyOwner {
        delete employees[_employee];
        emit EmployeeRemoved(_employee);
    }

    function checkIn() external onlyEmployee {
        uint256 today = block.timestamp / 1 days;
        require(!checkInLog[msg.sender][today], "Already checked in today");

        checkInLog[msg.sender][today] = true;
        emit CheckedIn(msg.sender, today);
    }

    function checkOut() external onlyEmployee {
        uint256 today = block.timestamp / 1 days;
        require(checkInLog[msg.sender][today], "Must check in first");
        require(!checkOutLog[msg.sender][today], "Already checked out today");

        checkOutLog[msg.sender][today] = true;
        emit CheckedOut(msg.sender, today);
    }

    function isCheckedIn(address _employee, uint256 day) external view returns (bool) {
        return checkInLog[_employee][day];
    }

    function isCheckedOut(address _employee, uint256 day) external view returns (bool) {
        return checkOutLog[_employee][day];
    }
}
