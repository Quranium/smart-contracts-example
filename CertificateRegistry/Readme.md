# CertificateRegistry

## Contract Name
**CertificateRegistry**

---

## Overview

The `CertificateRegistry` contract allows an admin (e.g., a university or certifying authority) to issue verifiable digital certificates to students. Each certificate includes the student’s name, course name, issue date, and a validity flag. Certificates are identified by a unique ID and can be verified or revoked at any time.

It is ideal for issuing digital diplomas, course completions, and other academic or professional credentials and is designed to be deployed and tested in the QRemix IDE using the JavaScript VM or a testnet.

---

## Prerequisites

- MetaMask or QSafe (for testnet deployment)
- Testnet ETH or QRN
- Access to QRemix IDE
- Basic knowledge of Solidity and smart contract workflow

---

## Contract Functions

### Constructor

```solidity
constructor()
```
- **Purpose:** Sets the deployer as the admin
- **Access:** Called on deployment

---

### issueCertificate

```solidity
issueCertificate(address _student, string _studentName, string _courseName) → bytes32
```
- **Purpose:** Issues a certificate to a student with metadata
- **Access:** Only callable by admin
- **Returns:** Unique certificate ID (`bytes32`)

---

### revokeCertificate

```solidity
revokeCertificate(bytes32 _certId)
```
- **Purpose:** Marks a certificate as revoked and invalid
- **Access:** Only callable by admin
- **Condition:** Certificate must exist and be valid

---

### getCertificate

```solidity
getCertificate(bytes32 _certId)
```
- **Purpose:** Fetches certificate metadata for a given ID
- **Returns:** `studentName`, `courseName`, `issueDate`, `isValid`

---

### getStudentCertificates

```solidity
getStudentCertificates(address _student) → bytes32[]
```
- **Purpose:** Returns a list of all certificate IDs for a given student

---

### verifyCertificate

```solidity
verifyCertificate(bytes32 _certId) → bool
```
- **Purpose:** Verifies if a certificate is valid or revoked

---

## Access Control

- **Admin (Deployer):** Issues and revokes certificates
- **Students/Users:** Can view and verify their certificates

Only the admin can issue and manage certificates. Students can only read/view their data.

---

## Deployment & Testing on QRemix

### Step 1: Setup
- Open [qremix.org](https://qremix.org)
- Create folder: `CertificateRegistry/`
- Add `CertificateRegistry.sol` and paste the contract code

### Step 2: Compile
- Go to Solidity Compiler
- Select version `0.8.20`
- Compile the contract

### Step 3: Deploy

#### Quranium Testnet
- Go to Deploy & Run Transactions
- Select Injected Provider - MetaMask
- Connect to Quranium testnet
- Deploy with no constructor arguments

#### JavaScript VM
- Choose JavaScript VM
- Deploy directly with the default admin

### Step 4: Testing
- Call `issueCertificate()` with sample student address, name, and course
- Use `getCertificate(certId)` to fetch details
- Use `verifyCertificate(certId)` to check if it’s valid
- Call `revokeCertificate(certId)` to revoke
- Re-verify using `verifyCertificate()` again

---

## License

This project is licensed under the MIT License.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

## Support

For issues or feature requests, refer to:
QRemix IDE Documentation : https://docs.qremix.org