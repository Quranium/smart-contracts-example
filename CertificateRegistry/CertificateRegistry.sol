// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CertificateRegistry {
    address public admin;

    struct Certificate {
        string studentName;
        string courseName;
        uint256 issueDate;
        bool isValid;
    }

    mapping(bytes32 => Certificate) private certificates; // certId (hash) => certificate
    mapping(address => bytes32[]) private studentCertificates; // student addr => list of their certIds

    event CertificateIssued(address indexed student, bytes32 certId, string courseName);
    event CertificateRevoked(bytes32 certId);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin allowed");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function issueCertificate(
        address _student,
        string memory _studentName,
        string memory _courseName
    ) external onlyAdmin returns (bytes32) {
        bytes32 certId = keccak256(abi.encodePacked(_student, _studentName, _courseName, block.timestamp));

        certificates[certId] = Certificate({
            studentName: _studentName,
            courseName: _courseName,
            issueDate: block.timestamp,
            isValid: true
        });

        studentCertificates[_student].push(certId);

        emit CertificateIssued(_student, certId, _courseName);
        return certId;
    }

    function revokeCertificate(bytes32 _certId) external onlyAdmin {
        require(certificates[_certId].isValid, "Certificate already revoked or does not exist");
        certificates[_certId].isValid = false;

        emit CertificateRevoked(_certId);
    }

    function getCertificate(bytes32 _certId) external view returns (
        string memory studentName,
        string memory courseName,
        uint256 issueDate,
        bool isValid
    ) {
        Certificate memory cert = certificates[_certId];
        require(bytes(cert.studentName).length > 0, "Certificate not found");

        return (cert.studentName, cert.courseName, cert.issueDate, cert.isValid);
    }

    function getStudentCertificates(address _student) external view returns (bytes32[] memory) {
        return studentCertificates[_student];
    }

    function verifyCertificate(bytes32 _certId) external view returns (bool) {
        return certificates[_certId].isValid;
    }
}
