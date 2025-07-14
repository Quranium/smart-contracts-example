# LondonCitizenBadge

---

### Contract Name  
**LondonCitizenBadge**

---

### Overview

The **LondonCitizenBadge** smart contract is a blockchain-based digital identity system for London citizens. This contract enables the issuance and management of digital badges that verify citizen identity, borough affiliation, and role within the London ecosystem.

The system supports badge issuance with citizen details (name, borough, role), badge revocation for administrative purposes, and verification of active badge status. Built with secure access controls and comprehensive event logging for transparency.

Perfect for smart city initiatives, digital identity verification, civic engagement platforms, or educational blockchain projects demonstrating identity management systems.

---

### Prerequisites

- MetaMask or compatible Web3 wallet
- ETH or testnet tokens (for gas fees)
- Remix IDE or similar development environment
- Basic understanding of smart contract interactions

---

### Contract Functions

#### issueBadge

```solidity
issueBadge(address user, string memory name, string memory borough, string memory role) external onlyAdmin hasNoBadge(user)
```
- **Purpose:** Issues a new citizen badge to a user
- **Access:** Admin only
- **Parameters:** 
  - `user` - recipient address
  - `name` - citizen's full name
  - `borough` - London borough (e.g., Camden, Hackney, Westminster)
  - `role` - citizen role (e.g., Citizen, Resident, Worker)
- **Requirement:** User must not already have a badge

#### revokeBadge

```solidity
revokeBadge(address user) external onlyAdmin hasBadge(user)
```
- **Purpose:** Revokes an existing citizen badge
- **Access:** Admin only
- **Parameters:** `user` - address of the badge holder
- **Requirement:** User must have an existing badge

#### hasActiveBadge

```solidity
hasActiveBadge(address user) external view returns (bool)
```
- **Purpose:** Checks if a user has an active badge
- **Access:** Public read-only
- **Parameters:** `user` - address to check
- **Returns:** Boolean indicating active badge status

#### getBadgeInfo

```solidity
getBadgeInfo(address user) external view returns (Badge memory)
```
- **Purpose:** Returns complete badge information for a user
- **Access:** Public read-only
- **Parameters:** `user` - address of the badge holder
- **Returns:** Badge struct containing all badge details

---

### Access Control

This contract implements role-based access control:

- **Admin Functions**: `issueBadge`, `revokeBadge`
- **Public Functions**: `hasActiveBadge`, `getBadgeInfo`

> The admin is set to the contract deployer and cannot be changed.

---

### Contract State

#### Constants
- `admin`: Contract administrator address
- `totalBadges`: Total number of badges issued

#### Data Structures
```solidity
struct Badge {
    string name;        // Citizen's full name
    string borough;     // London borough
    string role;        // Citizen role
    uint256 issuedAt;   // Creation timestamp
    bool isActive;      // Badge status
}
```

#### London Boroughs
The contract supports all 32 London boroughs including:
- **Inner London**: Camden, Hackney, Hammersmith and Fulham, Islington, Kensington and Chelsea, Lambeth, Lewisham, Southwark, Tower Hamlets, Wandsworth, Westminster
- **Outer London**: Barking and Dagenham, Barnet, Bexley, Brent, Bromley, Croydon, Ealing, Enfield, Greenwich, Harrow, Havering, Hillingdon, Hounslow, Kingston upon Thames, Merton, Newham, Redbridge, Richmond upon Thames, Sutton, Waltham Forest

#### Role Types
Common roles include:
- **Citizen**: Full London citizen
- **Resident**: London resident
- **Worker**: London worker/employee
- **Student**: London student
- **Visitor**: Temporary visitor

---

### Events

- `BadgeIssued`: Emitted when a new badge is created
- `BadgeRevoked`: Emitted when a badge is revoked

---

### Deployment & Testing

#### Step 1: Setup
- Open [remix.ethereum.org](https://remix.ethereum.org)
- Create folder: `LondonCitizenBadge/`
- Add `LondonCitizenBadge.sol` and paste the contract code

#### Step 2: Compile
- Go to Solidity Compiler
- Select compiler version `^0.8.20`
- Compile the contract

#### Step 3: Deploy

##### Ethereum Testnet (Sepolia/Goerli)
- Go to **Deploy & Run Transactions**
- Choose **Injected Provider - MetaMask**
- Connect to testnet
- Deploy contract (no constructor arguments)

##### Local Testing (JavaScript VM)
- Choose **JavaScript VM**
- Deploy contract directly

#### Step 4: Testing Workflow

1. **As Admin:**
   ```solidity
   // Issue a badge
   issueBadge(userAddress, "John Smith", "Camden", "Citizen");
   
   // Check total badges issued
   totalBadges(); // Returns current count
   ```

2. **As Anyone:**
   ```solidity
   // Check if user has active badge
   hasActiveBadge(userAddress); // Returns true/false
   
   // Get complete badge information
   getBadgeInfo(userAddress);
   ```

3. **Admin Controls:**
   ```solidity
   // Revoke a badge
   revokeBadge(userAddress);
   
   // Verify badge is inactive
   hasActiveBadge(userAddress); // Returns false
   ```

---

### Example Usage

```solidity
// Deploy contract (admin = deployer)
LondonCitizenBadge badgeSystem = new LondonCitizenBadge();

// Issue badge to London citizen
badgeSystem.issueBadge(
    0x123...,
    "Alice Johnson",
    "Westminster",
    "Resident"
);

// Verify badge status
bool isActive = badgeSystem.hasActiveBadge(0x123...);

// Get badge details
Badge memory badge = badgeSystem.getBadgeInfo(0x123...);
console.log("Name:", badge.name);
console.log("Borough:", badge.borough);
console.log("Role:", badge.role);
```

---

### Use Cases

#### Smart City Applications
- **Public Services**: Access to borough-specific services
- **Voting Systems**: Verify citizenship for local elections
- **Transport**: London resident discounts and access
- **Healthcare**: NHS service verification

#### Civic Engagement
- **Community Forums**: Verified citizen discussions
- **Local Events**: Borough-specific event access
- **Governance**: Citizen participation in local decisions
- **Emergency Services**: Rapid identity verification

#### Business Integration
- **Local Businesses**: Resident discounts and offers
- **Employment**: Work authorization verification
- **Housing**: Resident status for housing applications
- **Education**: Student verification for local schools

---

### Security Considerations

- **Single Badge Limitation**: Each address can only have one badge
- **Admin Controls**: Only admin can issue/revoke badges
- **Immutable Records**: Badge issuance timestamp is permanent
- **Status Management**: Badges can be deactivated but not deleted
- **Data Privacy**: Personal information stored on-chain is public

---

### Integration Examples

#### Web3 Frontend Integration
```javascript
// Check if user has active badge
const hasActiveBadge = await contract.hasActiveBadge(userAddress);

// Get badge information
const badge = await contract.getBadgeInfo(userAddress);
if (badge.isActive) {
    console.log(`Welcome ${badge.name} from ${badge.borough}!`);
}
```

#### Event Listening
```javascript
// Listen for new badge issuances
contract.on("BadgeIssued", (to, name, borough, role) => {
    console.log(`New badge issued to ${name} in ${borough} as ${role}`);
});
```

---

### License

This project is licensed under the MIT License.  
See `SPDX-License-Identifier: MIT` in the Solidity file.

---

### Support

For help, improvements, or bug reports:
- Remix IDE Docs: https://remix-ide.readthedocs.io
- Solidity Documentation: https://docs.soliditylang.org
- London Borough Information: https://www.london.gov.uk


