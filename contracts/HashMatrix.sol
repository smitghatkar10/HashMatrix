Struct to store hash data and metadata
    struct HashEntry {
        bytes32 dataHash;
        address owner;
        string metadataURI;
        uint256 timestamp;
    }

    Event emitted when a new hash is added
    event HashAdded(uint256 indexed row, uint256 indexed column, bytes32 dataHash, address indexed owner, string metadataURI);

    End
End
End
// 
// 
End
// 
