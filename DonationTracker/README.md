```markdown
# DonationTracker

## Contract Name
DonationTracker

## Overview
`DonationTracker` lets anyone create donation campaigns and accept donations in ETH or any ERC20 token. Campaigns can have optional goals and deadlines. If a campaign sets a goal and the deadline passes without meeting it, donors can claim refunds. If the goal is met (or no goal is set), the campaign owner can withdraw funds.

This README follows the repository style and assumes usage via QRemix/Remix.

## Prerequisites
- MetaMask / QSafe for testnet (optional for JavaScript VM)
- Test ETH
- (Optional) ERC20 token for ERC20 donations
- QRemix / Remix IDE

## Contract Details

### Key Functions

#### createCampaign(string title, address goalToken, uint256 goalAmount, uint256 deadline)
- **Purpose**: Create a campaign. `goalToken` == `address(0)` means ETH goal. `deadline` is a unix timestamp (0 = no deadline).

#### donateETH(uint256 id) payable
- **Purpose**: Donate ETH to campaign `id`. Sends `msg.value` as donation.

#### donateERC20(uint256 id, address token, uint256 amount)
- **Purpose**: Donate ERC20 token to campaign `id`. Donor must `approve` the contract first.

#### withdraw(uint256 id, address token, uint256 amount)
- **Purpose**: Campaign owner withdraws funds for a given token (ETH if `token==address(0)`). Withdrawals are allowed if no goal is set or the campaign reached its goal.

#### refund(uint256 id, address token)
- **Purpose**: Donor reclaims their donation if the campaign had a goal, the deadline passed, and the goal was not met.

### Events
- `CampaignCreated(id, owner, title, goalToken, goalAmount, deadline)`
- `Donated(id, donor, token, amount)`
- `Withdrawn(id, owner, token, amount)`
- `Refunded(id, donor, token, amount)`

### Security & Notes
- Uses pull-based withdrawals for both owners and donors (refunds) to avoid reentrancy.
- For large donor lists, rely on emitted `Donated` events for off-chain indexing rather than reading on-chain arrays.

## Deployment & Testing (QRemix / Remix)

### Setup
1. Open QRemix or Remix.
2. Create `DonationTracker/` folder and add `DonationTracker.sol`.

### Compilation
1. Select Solidity compiler 0.8.x and compile.

### Example Flow (ETH)
1. Call `createCampaign("Help Project", address(0), 0, 0)` to create a simple campaign with no goal.
2. From another account call `donateETH(id)` sending `msg.value`.
3. Campaign owner calls `withdraw(id, address(0), amount)` to collect funds.

### Example Flow (ERC20)
1. Deploy or use an ERC20 token and mint/allocate tokens to donor accounts.
2. Donor approves `DonationTracker` for `amount` on the ERC20 contract.
3. Donor calls `donateERC20(id, tokenAddress, amount)` to donate.
4. Owner withdraws via `withdraw(id, tokenAddress, amount)` once the goal is met.

### Refund Flow
1. Create a campaign with goal: `createCampaign("Goal","0x..token..", 1000, deadlineTimestamp)`
2. Donors contribute before the deadline.
3. If after `deadline` the totalRaised for the campaign's goal token is less than `goalAmount`, donors can call `refund(id, token)` to reclaim their donation.

## License
MIT (see SPDX header in contract)

``` 