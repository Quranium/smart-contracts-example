// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title VestingWallet
 * @notice Locks ERC20 tokens (or native QRN/ETH) for a beneficiary with:
 *         - A cliff period  : no tokens can be claimed before this time
 *         - Linear vesting  : tokens unlock gradually from cliff end → vesting end
 *
 * Use-cases: team token allocation, investor vesting, employee grants.
 *
 * Owner (deployer / project) creates a schedule per beneficiary.
 * Beneficiary can call `release()` at any time after the cliff to claim
 * whatever has vested so far.
 */
interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract VestingWallet {
    // ─────────────────────────────────────────────────────────────────────────
    // Data structures
    // ─────────────────────────────────────────────────────────────────────────

    struct Schedule {
        uint256 totalAmount;      // Total tokens/QRN to vest
        uint256 released;         // Amount already claimed
        uint64  startTime;        // When vesting begins (unix timestamp)
        uint64  cliffDuration;    // Seconds from start before ANY tokens unlock
        uint64  vestingDuration;  // Total seconds of the vesting period (cliff included)
        bool    revocable;        // Can the owner cancel this schedule?
        bool    revoked;          // Has it been revoked?
    }

    // ─────────────────────────────────────────────────────────────────────────
    // State
    // ─────────────────────────────────────────────────────────────────────────

    address public owner;

    /// @dev beneficiary => token => Schedule
    ///      token == address(0) means native QRN/ETH
    mapping(address => mapping(address => Schedule)) private _schedules;

    // ─────────────────────────────────────────────────────────────────────────
    // Events
    // ─────────────────────────────────────────────────────────────────────────

    event ScheduleCreated(
        address indexed beneficiary,
        address indexed token,
        uint256 totalAmount,
        uint64  startTime,
        uint64  cliffDuration,
        uint64  vestingDuration,
        bool    revocable
    );

    event TokensReleased(
        address indexed beneficiary,
        address indexed token,
        uint256 amount
    );

    event ScheduleRevoked(
        address indexed beneficiary,
        address indexed token,
        uint256 unreleasedReturned
    );

    // ─────────────────────────────────────────────────────────────────────────
    // Modifiers
    // ─────────────────────────────────────────────────────────────────────────

    modifier onlyOwner() {
        require(msg.sender == owner, "VestingWallet: not owner");
        _;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Constructor
    // ─────────────────────────────────────────────────────────────────────────

    constructor() {
        owner = msg.sender;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Owner functions
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * @notice Create a vesting schedule for an ERC20 token.
     * @dev    The owner must have transferred `totalAmount` tokens to this
     *         contract before (or in the same tx via a wrapper) calling this.
     *
     * @param beneficiary     Address that will receive the unlocked tokens.
     * @param token           ERC20 token address. Use address(0) for native QRN.
     * @param totalAmount     Total tokens locked for this beneficiary.
     * @param startTime       Unix timestamp when vesting starts (can be future).
     * @param cliffDuration   Seconds after `startTime` before cliff ends.
     * @param vestingDuration Total seconds of the entire vesting window (>= cliff).
     * @param revocable       Whether the owner can cancel this schedule.
     */
    function createSchedule(
        address beneficiary,
        address token,
        uint256 totalAmount,
        uint64  startTime,
        uint64  cliffDuration,
        uint64  vestingDuration,
        bool    revocable
    ) external payable onlyOwner {
        require(beneficiary != address(0),        "VestingWallet: zero address");
        require(totalAmount > 0,                  "VestingWallet: zero amount");
        require(vestingDuration > 0,              "VestingWallet: zero duration");
        require(vestingDuration >= cliffDuration, "VestingWallet: cliff > vesting");
        require(
            _schedules[beneficiary][token].totalAmount == 0,
            "VestingWallet: schedule exists"
        );

        if (token == address(0)) {
            // Native QRN/ETH – must be sent with the call
            require(msg.value == totalAmount, "VestingWallet: wrong ETH amount");
        } else {
            require(msg.value == 0, "VestingWallet: ETH not needed");
            // Tokens must already be in this contract's balance.
            // (Owner calls token.transfer(address(this), amount) first, then this.)
            require(
                IERC20(token).balanceOf(address(this)) >= totalAmount,
                "VestingWallet: insufficient token balance"
            );
        }

        _schedules[beneficiary][token] = Schedule({
            totalAmount:     totalAmount,
            released:        0,
            startTime:       startTime,
            cliffDuration:   cliffDuration,
            vestingDuration: vestingDuration,
            revocable:       revocable,
            revoked:         false
        });

        emit ScheduleCreated(
            beneficiary, token, totalAmount,
            startTime, cliffDuration, vestingDuration, revocable
        );
    }

    /**
     * @notice Revoke a vesting schedule (owner only, and only if revocable).
     *         Already-vested tokens remain claimable by the beneficiary.
     *         Un-vested tokens are returned to the owner.
     */
    function revoke(address beneficiary, address token) external onlyOwner {
        Schedule storage s = _schedules[beneficiary][token];
        require(s.totalAmount > 0,    "VestingWallet: no schedule");
        require(s.revocable,          "VestingWallet: not revocable");
        require(!s.revoked,           "VestingWallet: already revoked");

        uint256 vested    = _vestedAmount(s);
        uint256 claimable = vested - s.released;
        uint256 refund    = s.totalAmount - vested;

        s.revoked = true;
        // Keep `s.totalAmount` = vested so beneficiary can still claim their share.
        s.totalAmount = vested;

        // Return un-vested portion to owner
        if (refund > 0) {
            _sendTokens(token, owner, refund);
        }

        emit ScheduleRevoked(beneficiary, token, refund);

        // Auto-release beneficiary's claimable portion
        if (claimable > 0) {
            s.released += claimable;
            _sendTokens(token, beneficiary, claimable);
            emit TokensReleased(beneficiary, token, claimable);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Beneficiary functions
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * @notice Claim all currently unlocked tokens from a schedule.
     * @param token ERC20 token address, or address(0) for native QRN.
     */
    function release(address token) external {
        Schedule storage s = _schedules[msg.sender][token];
        require(s.totalAmount > 0, "VestingWallet: no schedule");
        require(!s.revoked || _vestedAmount(s) > s.released, "VestingWallet: revoked");

        uint256 releasable = releasableAmount(msg.sender, token);
        require(releasable > 0, "VestingWallet: nothing to release");

        s.released += releasable;
        _sendTokens(token, msg.sender, releasable);

        emit TokensReleased(msg.sender, token, releasable);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // View functions
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * @notice Returns the amount a beneficiary can claim right now.
     */
    function releasableAmount(address beneficiary, address token)
        public view returns (uint256)
    {
        Schedule storage s = _schedules[beneficiary][token];
        if (s.totalAmount == 0) return 0;
        return _vestedAmount(s) - s.released;
    }

    /**
     * @notice Returns total tokens vested so far (including already released).
     */
    function vestedAmount(address beneficiary, address token)
        public view returns (uint256)
    {
        return _vestedAmount(_schedules[beneficiary][token]);
    }

    /**
     * @notice Returns the full schedule details for a beneficiary + token.
     */
    function getSchedule(address beneficiary, address token)
        external view
        returns (
            uint256 totalAmount,
            uint256 released,
            uint64  startTime,
            uint64  cliffDuration,
            uint64  vestingDuration,
            bool    revocable,
            bool    revoked,
            uint256 releasable,
            uint256 vested
        )
    {
        Schedule storage s = _schedules[beneficiary][token];
        return (
            s.totalAmount,
            s.released,
            s.startTime,
            s.cliffDuration,
            s.vestingDuration,
            s.revocable,
            s.revoked,
            releasableAmount(beneficiary, token),
            vestedAmount(beneficiary, token)
        );
    }

    /**
     * @notice When will the cliff end for a given schedule?
     */
    function cliffEnd(address beneficiary, address token)
        external view returns (uint64)
    {
        Schedule storage s = _schedules[beneficiary][token];
        return s.startTime + s.cliffDuration;
    }

    /**
     * @notice When will vesting fully complete?
     */
    function vestingEnd(address beneficiary, address token)
        external view returns (uint64)
    {
        Schedule storage s = _schedules[beneficiary][token];
        return s.startTime + s.vestingDuration;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Internal helpers
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * @dev Core linear vesting formula with cliff check.
     *
     *          0                              if now < cliff
     *          totalAmount                    if now >= vesting end
     *          totalAmount * elapsed / total  otherwise (linear)
     */
    function _vestedAmount(Schedule storage s) private view returns (uint256) {
        uint256 now_ = block.timestamp;
        uint256 cliff = uint256(s.startTime) + uint256(s.cliffDuration);

        if (now_ < cliff) {
            return 0;
        }

        uint256 end = uint256(s.startTime) + uint256(s.vestingDuration);
        if (now_ >= end) {
            return s.totalAmount;
        }

        // Linear: proportion of vesting duration elapsed since start
        uint256 elapsed = now_ - uint256(s.startTime);
        return (s.totalAmount * elapsed) / uint256(s.vestingDuration);
    }

    function _sendTokens(address token, address to, uint256 amount) private {
        if (token == address(0)) {
            (bool ok, ) = payable(to).call{value: amount}("");
            require(ok, "VestingWallet: native transfer failed");
        } else {
            require(
                IERC20(token).transfer(to, amount),
                "VestingWallet: token transfer failed"
            );
        }
    }

    // Accept plain QRN/ETH deposits (for native vesting schedules)
    receive() external payable {}
}
