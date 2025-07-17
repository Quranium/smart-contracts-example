// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Decentralized Video Platform
/// @notice Allows users to upload videos and interact via likes
contract DecentralizedVideoPlatform {
    struct Video {
        address uploader;
        string title;
        string videoUrl; // IPFS CID or external link
        uint256 likes;
        mapping(address => bool) likedBy;
    }

    uint256 public videoCount;
    mapping(uint256 => Video) private videos;

    event VideoUploaded(uint256 indexed videoId, address indexed uploader, string title, string videoUrl);
    event VideoLiked(uint256 indexed videoId, address indexed liker);
    event VideoUnliked(uint256 indexed videoId, address indexed unliker);

    /// @notice Upload a new video
    /// @param _title Title of the video
    /// @param _videoUrl IPFS hash or external link
    function uploadVideo(string memory _title, string memory _videoUrl) external {
        require(bytes(_title).length > 0, "Title is required");
        require(bytes(_videoUrl).length > 0, "Video URL is required");

        Video storage v = videos[videoCount];
        v.uploader = msg.sender;
        v.title = _title;
        v.videoUrl = _videoUrl;

        emit VideoUploaded(videoCount, msg.sender, _title, _videoUrl);
        videoCount++;
    }

    /// @notice Like a video
    /// @param _videoId ID of the video
    function likeVideo(uint256 _videoId) external {
        require(_videoId < videoCount, "Invalid video ID");
        Video storage v = videos[_videoId];
        require(!v.likedBy[msg.sender], "You already liked this video");

        v.likes++;
        v.likedBy[msg.sender] = true;

        emit VideoLiked(_videoId, msg.sender);
    }

    /// @notice Unlike a video
    /// @param _videoId ID of the video
    function unlikeVideo(uint256 _videoId) external {
        require(_videoId < videoCount, "Invalid video ID");
        Video storage v = videos[_videoId];
        require(v.likedBy[msg.sender], "You haven't liked this video");

        v.likes--;
        v.likedBy[msg.sender] = false;

        emit VideoUnliked(_videoId, msg.sender);
    }

    /// @notice Get video metadata
    /// @param _videoId ID of the video
    function getVideo(uint256 _videoId) external view returns (
        address uploader,
        string memory title,
        string memory videoUrl,
        uint256 likes,
        bool liked
    ) {
        require(_videoId < videoCount, "Invalid video ID");
        Video storage v = videos[_videoId];

        return (
            v.uploader,
            v.title,
            v.videoUrl,
            v.likes,
            v.likedBy[msg.sender]
        );
    }
}
