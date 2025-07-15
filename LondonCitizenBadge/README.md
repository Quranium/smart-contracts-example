# LondonCitizenBadge

## Overview

The **LondonCitizenBadge** contract is a digital identity and verification system for issuing non-transferable citizen badges to residents, workers, or visitors in London boroughs.  
Each badge includes metadata such as name, borough, and role. Admins can issue and revoke badges, while users can check badge status or retrieve badge information.

This contract is lightweight, easy to deploy, and useful for government-backed identity programs, smart city projects, or gated digital services.

*They are designed to be deployed and tested in the **QRemix IDE** using the JavaScript VM or a testnet like Quranium testnet, Sepolia etc.*

## Prerequisites

To deploy and test the contracts, you need:

- **MetaMask or QSafe**: Browser extension for testnet deployments (optional).
- **Test ETH or QRN**: Required for testnet deployments (e.g., from a Sepolia faucet like [sepoliafaucet.com](https://sepoliafaucet.com/), Quranium [faucet.quranium.org](https://faucet.quranium.org/)).
- **QRemix IDE**: Access at [https://www.qremix.org/](https://www.qremix.org/)
- **Basic Solidity Knowledge**: Understanding of smart contract roles, modifiers, structs, and mappings.

## Contract Details

### Structs

- `Badge`:
  - `name`: Citizen's name.
  - `borough`: e.g., Camden, Hackney, Westminster.
  - `role`: e.g., Citizen, Resident, Worker.
  - `issuedAt`: Timestamp of issuance.
  - `isActive`: Indicates whether the badge is currently active.

### State Variables

- `admin`: Address with permission to issue/revoke badges.
- `totalBadges`: Counter to track the total number of badges issued.
- `badges`: Mapping from user address to their badge data.

### Functions

- `constructor()`:  
  Sets the deployer as the admin.

- `issueBadge(address user, string name, string borough, string role)`:  
  Admin-only function to issue a badge to a user. Prevents reissuing to the same address.

- `revokeBadge(address user)`:  
  Admin-only function to deactivate a badge previously issued.

- `hasActiveBadge(address user)`:  
  View function to check whether a user's badge is still active.

- `getBadgeInfo(address user)`:  
  Returns full badge details for a given address.

### Modifiers

- `onlyAdmin`: Restricts functions to the admin address.
- `hasNoBadge`: Ensures a badge hasn't already been issued to the address.
- `hasBadge`: Ensures a badge exists for the address.

### Events

- `BadgeIssued`: Emitted when a badge is successfully issued.
- `BadgeRevoked`: Emitted when a badge is revoked by the admin.

## Deployment and Testing in QRemix IDE (optional)

1. Open [QRemix IDE](https://www.qremix.org/).
2. Paste the smart contract into a new file (e.g., `LondonCitizenBadge.sol`).
3. Compile using Solidity version `0.8.20`.
4. Go to **Deploy & Run Transactions**.
5. Choose the environment (e.g., **JavaScript VM** or **Injected Provider**).
6. Deploy the contract.

### Example Flow

1. **Issue a Badge**  
   As admin, call `issueBadge(user, name, borough, role)`.

2. **Check Active Badge**  
   Use `hasActiveBadge(user)` to check if a badge is valid.

3. **Revoke a Badge**  
   As admin, call `revokeBadge(user)` to deactivate a badge.

4. **View Badge Info**  
   Call `getBadgeInfo(user)` to see full metadata.

## License

This project is licensed under the MIT License.  
See the `SPDX-License-Identifier: MIT` in the contract file.

## Support

For issues or feature requests:

- Check the QRemix IDE documentation: [https://docs.qremix.org](https://docs.qremix.org)
- Consult OpenZeppelin’s documentation: [https://docs.openzeppelin.com](https://docs.openzeppelin.com)
