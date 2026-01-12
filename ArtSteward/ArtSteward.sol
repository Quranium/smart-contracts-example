// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ArtSteward {
    address public currentOwner;
    string public artist;
    string public title;
    uint public yearCreated;

    struct EventLog {
        uint256 timestamp;
        string eventType; // e.g., "Sale", "Exhibition: Louvre 2023", "Restoration"
        address from;
        address to;
        string detailsURI; // IPFS hash linking to documents, photos, etc.
        address verifiedBy; // Address of a trusted verifier
    }

    EventLog[] public provenance;
    mapping(address => bool) public isVerifier;

    event NewEventLogged(
        uint256 indexed logIndex,
        string eventType,
        address verifiedBy
    );

    modifier onlyVerifier() {
        require(isVerifier[msg.sender], "Not an authorized verifier");
        _;
    }

    constructor(
        address _initialOwner,
        string memory _artist,
        string memory _title,
        uint _year,
        address[] memory _verifiers
    ) {
        currentOwner = _initialOwner;
        artist = _artist;
        title = _title;
        yearCreated = _year;

        for (uint i = 0; i < _verifiers.length; i++) {
            isVerifier[_verifiers[i]] = true;
        }
        // Log the creation event
        provenance.push(
            EventLog(
                block.timestamp,
                "Creation",
                address(0),
                _initialOwner,
                "",
                address(0)
            )
        );
    }

    function logEvent(
        string memory _eventType,
        address _newOwner,
        string memory _detailsURI
    ) external onlyVerifier {
        require(_newOwner != address(0), "Invalid new owner");

        address oldOwner = currentOwner;
        currentOwner = _newOwner;

        provenance.push(
            EventLog(
                block.timestamp,
                _eventType,
                oldOwner,
                _newOwner,
                _detailsURI,
                msg.sender // The verifier calling this function
            )
        );

        emit NewEventLogged(provenance.length - 1, _eventType, msg.sender);
    }

    function getProvenanceHistoryCount() public view returns (uint) {
        return provenance.length;
    }
}
