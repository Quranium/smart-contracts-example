// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BatchAirdrop {
    address public owner;
    IERC20 public token;
    bytes32 public merkleRoot;
    mapping(address => bool) public claimed;

    event Airdropped(address indexed to, uint256 amount);
    event Claimed(address indexed who, uint256 amount);
    event Withdrawn(address indexed to, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    constructor(address _token, bytes32 _merkleRoot) {
        require(_token != address(0), "Token zero");
        owner = msg.sender;
        token = IERC20(_token);
        merkleRoot = _merkleRoot;
    }

    function setMerkleRoot(bytes32 _r) external onlyOwner { merkleRoot = _r; }

    function batchAirdrop(address[] calldata to, uint256[] calldata v) external onlyOwner {
        require(to.length == v.length, "len");
        for (uint256 i = 0; i < to.length; i++) {
            if (v[i] == 0) continue;
            _safeTransfer(to[i], v[i]);
            emit Airdropped(to[i], v[i]);
        }
    }

    function claim(uint256 amount, bytes32[] calldata proof) external {
        require(merkleRoot != bytes32(0), "no root");
        require(!claimed[msg.sender], "claimed");
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender, amount));
        require(_verifyProof(proof, merkleRoot, leaf), "bad proof");
        claimed[msg.sender] = true;
        _safeTransfer(msg.sender, amount);
        emit Claimed(msg.sender, amount);
    }

    function withdraw(address to, uint256 amount) external onlyOwner {
        _safeTransfer(to, amount);
        emit Withdrawn(to, amount);
    }

    function _safeTransfer(address to, uint256 value) internal {
        (bool ok, bytes memory ret) = address(token).call(abi.encodeWithSelector(token.transfer.selector, to, value));
        require(ok && (ret.length == 0 || abi.decode(ret, (bool))), "tfail");
    }

    function _verifyProof(bytes32[] calldata proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
        bytes32 h = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 p = proof[i];
            h = h <= p ? keccak256(abi.encodePacked(h, p)) : keccak256(abi.encodePacked(p, h));
        }
        return h == root;
    }
}

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
}
