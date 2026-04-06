# VestingWallet Smart Contract

A production-pattern token vesting contract that locks **ERC20 tokens** (or native **QRN/ETH**) for a beneficiary with a configurable **cliff + linear vesting** schedule.

Perfect for: team token grants, investor allocations, employee equity, and any scenario where tokens should unlock gradually over time.

---

## ✨ Features

- ⏳ **Cliff Period** — Zero tokens released before the cliff ends
- 📈 **Linear Vesting** — Tokens unlock proportionally after the cliff, second-by-second
- 🪙 **Dual Asset Support** — Works with any ERC20 token OR native QRN/ETH (`address(0)`)
- 🔁 **Partial Claims** — Beneficiary can call `release()` any number of times
- ❌ **Revocable Schedules** — Owner can cancel a schedule; vested portion stays claimable, unvested goes back to owner
- 🔒 **Non-Revocable Option** — Lock schedules permanently for trustless grants
- 👁️ **Full Visibility** — View vested, released, and releasable amounts at any time

---

## Prerequisites

To deploy and test the contract, you need:

- **QSafe / MetaMask**: Browser wallet extension for testnet deployments.
- **Test QRN or ERC20 tokens**: From [faucet.quranium.org](https://faucet.quranium.org).
- **QRemix IDE**: Access at [qremix.org](https://qremix.org).
- **Basic Solidity Knowledge**: Contract deployment via Remix IDE.

---

## Contract Details

### Roles

| Role | Address | Responsibilities |
|------|---------|-----------------|
| **Owner** | Deployer | Creates & (optionally) revokes schedules, funds the contract |
| **Beneficiary** | Any address | Calls `release()` to claim unlocked tokens |

---

## How It Works

### Vesting Formula

```
Before cliff   → 0 tokens unlocked
After cliff    → totalAmount × (elapsed / vestingDuration)   [linear]
After vesting  → totalAmount (100% unlocked)
```

**Example:**  
- Total: 1,000,000 tokens  
- Start: Day 0 | Cliff: 90 days | Vesting: 365 days  
- At Day 90 → `1,000,000 × 90/365 ≈ 246,575` tokens unlocked  
- At Day 180 → `1,000,000 × 180/365 ≈ 493,150` tokens unlocked  
- At Day 365 → 1,000,000 tokens (100%)

---

## Functions

### Owner Functions

#### `createSchedule()`

```solidity
function createSchedule(
    address beneficiary,
    address token,          // ERC20 address, or address(0) for native QRN
    uint256 totalAmount,
    uint64  startTime,      // Unix timestamp
    uint64  cliffDuration,  // Seconds (e.g. 90 days = 7776000)
    uint64  vestingDuration,// Seconds (e.g. 365 days = 31536000)
    bool    revocable
) external payable
```

> **For ERC20:** Transfer tokens to the contract first, then call `createSchedule` (with `msg.value = 0`).  
> **For native QRN:** Send `totalAmount` as `msg.value` directly.

#### `revoke(address beneficiary, address token)`

Cancels a revocable schedule. Vested tokens stay claimable by the beneficiary; unvested tokens are returned to the owner.

---

### Beneficiary Functions

#### `release(address token)`

Claims all currently releasable tokens. Can be called repeatedly as more tokens vest over time.

---

### View Functions

| Function | Returns |
|----------|---------|
| `releasableAmount(beneficiary, token)` | Tokens claimable right now |
| `vestedAmount(beneficiary, token)` | Total vested so far (including released) |
| `getSchedule(beneficiary, token)` | Full schedule details |
| `cliffEnd(beneficiary, token)` | Timestamp when cliff ends |
| `vestingEnd(beneficiary, token)` | Timestamp when 100% is vested |

---

## Deployment & Testing in QRemix IDE

### Step 1: Setup

1. Open [qremix.org](https://qremix.org)
2. Create a new file and paste the contents of `VestingWallet.sol`

### Step 2: Compile

1. Go to the **Solidity Compiler** tab
2. Select compiler version **0.8.20** or higher
3. Enable **optimization** (200 runs recommended)
4. Click **Compile VestingWallet.sol**

### Step 3: Deploy

#### For Quranium Testnet:

1. Go to **Deploy & Run Transactions** tab
2. Select **Injected Provider** as environment
3. Connect **QSafe** to the Quranium Testnet
4. Deploy `VestingWallet` (no constructor arguments needed)
5. Note the deployed contract address

---

## Testing Walkthrough

### Scenario: Vest 1,000 QRN for a team member over 1 year with 3-month cliff

```
startTime       = current block.timestamp
cliffDuration   = 7776000   (90 days in seconds)
vestingDuration = 31536000  (365 days in seconds)
totalAmount     = 1000000000000000000000  (1000 QRN in wei)
revocable       = true
```

**Step 1 — Deploy** the VestingWallet contract.

**Step 2 — Fund & Create Schedule**  
Call `createSchedule` with your team member's address, `address(0)` as token, and send `1000 QRN` as `msg.value`.

**Step 3 — Check vesting**  
Use `getSchedule` to verify the schedule was created correctly.

**Step 4 — Wait / advance time** (in Remix JS VM, use `evm_increaseTime`).

**Step 5 — Beneficiary calls `release(address(0))`**  
They receive only the linearly vested portion. Nothing before the cliff!

**Step 6 — Owner calls `revoke`** (optional)  
Unvested tokens return to owner; beneficiary's vested share remains claimable.

---

## Security Considerations

- ✅ State updated before token transfers (reentrancy-safe pattern)
- ✅ Uses `call` with value check for native transfers (avoids transfer gas limit issues)
- ✅ One schedule per beneficiary per token (prevents double-scheduling)
- ✅ Cliff enforced strictly at storage level, not just UI
- ⚠️ Not audited — use in production only after independent security review

---

## License

MIT License – Free to use with customization and proper audit.

## Support

For issues or questions:

- QRemix IDE documentation: [https://docs.qremix.org](https://docs.qremix.org/)
- Quranium developer docs: [https://docs.quranium.org](https://docs.quranium.org/)
