# DecentralizedVideoPlatform

## Overview

The **DecentralizedVideoPlatform** smart contract allows users to upload video metadata (e.g., IPFS links), like or unlike videos, and retrieve video details.  
It simulates a basic YouTube-style social experience on-chain, enabling immutable video tracking and user interactions.

Each video is stored with its uploader, title, IPFS hash (or external link), and total like count.  
This contract is ideal for decentralized content-sharing platforms, NFTs with metadata, or creator-based DAOs.

*They are designed to be deployed and tested in the **QRemix IDE** using the JavaScript VM or a testnet like Quranium testnet, Sepolia etc.*

## Prerequisites

To deploy and test the contracts, you need:

- **MetaMask or QSafe**: Browser extension for testnet deployments (optional).
- **Test ETH or QRN**: Required for testnet deployments (e.g., from a Sepolia faucet like [sepoliafaucet.com](https://sepoliafaucet.com/), Quranium [faucet.quranium.org](https://faucet.quranium.org/)).
- **QRemix IDE**: Access at [https://www.qremix.org/](https://www.qremix.org/)
- **Basic Solidity Knowledge**: Understanding of mappings, structs, and public interactions in smart contracts.

## Contract Details

### Structs

- `Video`:
  - `uploader`: Address that uploaded the video.
  - `title`: Video title.
  - `videoUrl`: IPFS CID or external URL.
  - `likes`: Total number of likes.
  - `likedBy`: Mapping to track if a user liked the video.

### State Variables

- `videoCount`: Tracks the number of videos uploaded.
- `videos`: Maps `videoId` to `Video` struct.

### Functions

- `uploadVideo(string _title, string _videoUrl)`:
  - Allows a user to upload a new video.
  - Requires non-empty title and video URL.
  - Emits `VideoUploaded`.

- `likeVideo(uint256 _videoId)`:
  - Lets a user like a video.
  - Increments `likes` and marks user as liked.
  - Emits `VideoLiked`.

- `unlikeVideo(uint256 _videoId)`:
  - Lets a user unlike a video they previously liked.
  - Decrements `likes`.
  - Emits `VideoUnliked`.

- `getVideo(uint256 _videoId)`:
  - Returns video metadata:
    - `uploader`, `title`, `videoUrl`, `likes`, and whether `msg.sender` has liked the video.

### Events

- `VideoUploaded`: Emitted when a video is uploaded.
- `VideoLiked`: Emitted when a user likes a video.
- `VideoUnliked`: Emitted when a user unlikes a video.

## Deployment and Testing in QRemix IDE (optional)

1. Go to [QRemix IDE](https://www.qremix.org/).
2. Paste the smart contract code into a new file, e.g., `DecentralizedVideoPlatform.sol`.
3. Compile with Solidity version `0.8.20`.
4. In the **Deploy & Run Transactions** tab:
   - Choose environment: **JavaScript VM** or **Injected Provider (MetaMask)**.
   - Click **Deploy**.

### Sample Interaction Flow

1. **Upload a Video**  
   Call `uploadVideo("My First Video", "ipfs://Qm...")`.

2. **Like a Video**  
   Call `likeVideo(0)` to like the video with ID `0`.

3. **Unlike a Video**  
   Call `unlikeVideo(0)` to remove your like from the same video.

4. **Get Video Details**  
   Call `getVideo(0)` to view video metadata including likes and liked status.

## License

This project is licensed under the MIT License.  
See the `SPDX-License-Identifier: MIT` in the contract file.

## Support

For issues or feature requests:

- Check the QRemix IDE documentation: [https://docs.qremix.org](https://docs.qremix.org)
- Consult OpenZeppelin’s documentation: [https://docs.openzeppelin.com](https://docs.openzeppelin.com)
