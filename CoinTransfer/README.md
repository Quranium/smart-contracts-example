# SimpleCoinTransfer

## Overview

The **SimpleCoinTransfer** smart contract enables users to deposit Ether into the contract and transfer it to other addresses using an internal balance mapping.  
It maintains account balances off-chain within the contract, allowing secure and traceable Ether transfers between users.

This contract uses **Solidity v0.8.20** and follows basic best practices. No external libraries are used, but it is designed to be lightweight and easy to test.

*They are designed to be deployed and tested in the **QRemix IDE** using the JavaScript VM or a testnet like Quranium testnet, Sepolia etc.*

## Prerequisites

To deploy and test the contracts, you need:

- **MetaMask or QSafe**: Browser extension for testnet deployments (optional).
- **Test ETH or QRN**: Required for testnet deployments (e.g., from a Sepolia faucet like [sepoliafaucet.com](https://sepoliafaucet.com/), Quranium [faucet.quranium.org](https://faucet.quranium.org/)).
- **QRemix IDE**: Access at [https://www.qremix.org/](https://www.qremix.org/)
- **Basic Solidity Knowledge**: Understanding of smart contract deployment and Remix IDE.

## Contract Details

### Functions

- `receive() external payable`:  
  Accepts incoming Ether transfers and updates the sender’s internal balance. Emits a `CoinReceived` event.

- `sendCoin(address payable to, uint256 amount) external`:  
  Sends Ether to another address from the sender’s internal balance.  
  - Reverts if the sender has insufficient balance.  
  - Emits `CoinSent` event on success.

- `getContractBalance() external view returns (uint256)`:  
  Returns the total Ether held by the contract.

- `myBalance() external view returns (uint256)`:  
  Returns the caller's internal balance maintained in the contract.

### Events

- `CoinReceived(address from, uint256 amount)`: Emitted when Ether is deposited.
- `CoinSent(address from, address to, uint256 amount)`: Emitted when a transfer occurs.

## Deployment and Testing in QRemix IDE (optional)

1. Open [QRemix IDE](https://www.qremix.org/).
2. Paste the smart contract code into a new Solidity file (e.g., `SimpleCoinTransfer.sol`).
3. Click the **Compile** tab and compile the contract using Solidity `0.8.20`.
4. Go to **Deploy & Run Transactions**.
5. Choose **JavaScript VM** for local testing or **Injected Provider - MetaMask** for testnet deployment.
6. Click **Deploy**.
7. After deployment:
   - Use the **value (in ETH)** field and click on the contract to send Ether (calls `receive()`).
   - Use `sendCoin(to, amount)` to transfer to another address.
   - Call `myBalance()` to check your internal balance.
   - Call `getContractBalance()` to see the total Ether stored in the contract.

## License

This project is licensed under the MIT License.  
See the `SPDX-License-Identifier: MIT` in the contract file.

## Support

For issues or feature requests:

- Check the QRemix IDE documentation: [https://docs.qremix.org](https://docs.qremix.org)
- Consult OpenZeppelin’s documentation: [https://docs.openzeppelin.com](https://docs.openzeppelin.com)
