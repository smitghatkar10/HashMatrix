Struct to store hash data and metadata
    struct HashEntry {
        bytes32 dataHash;
        address owner;
        string metadataURI;
        uint256 timestamp;
    }

    Event emitted when a new hash is added
    event HashAdded(uint256 indexed row, uint256 indexed column, bytes32 dataHash, address indexed owner, string metadataURI);

    // Event emitted when a hash entry is updated
    event HashUpdated(uint256 indexed row, uint256 indexed column, bytes32 newDataHash, address indexed owner, string newMetadataURI);

    /**
     * @dev Add a new hash entry at specified position.
     * Reverts if an entry already exists at that position.
     */
    function addHash(uint256 row, uint256 column, bytes32 dataHash, string calldata metadataURI) external {
        require(matrix[row][column].owner == address(0), "Entry already exists");

        matrix[row][column] = HashEntry({
            dataHash: dataHash,
            owner: msg.sender,
            metadataURI: metadataURI,
            timestamp: block.timestamp
        });

        emit HashAdded(row, column, dataHash, msg.sender, metadataURI);
    }

    /**
     * @dev Update existing hash entry's data and metadata.
     * Only original owner can update.
     */
    function updateHash(uint256 row, uint256 column, bytes32 newDataHash, string calldata newMetadataURI) external {
        HashEntry storage entry = matrix[row][column];
        require(entry.owner == msg.sender, "Only owner can update");
        require(entry.owner != address(0), "Entry does not exist");

        entry.dataHash = newDataHash;
        entry.metadataURI = newMetadataURI;
        entry.timestamp = block.timestamp;

        emit HashUpdated(row, column, newDataHash, msg.sender, newMetadataURI);
    }

    /**
     * @dev Retrieve hash entry data
     */
    function getHashEntry(uint256 row, uint256 column) external view returns (
        bytes32 dataHash,
        address owner,
        string memory metadataURI,
        uint256 timestamp
    ) {
        HashEntry storage entry = matrix[row][column];
        require(entry.owner != address(0), "Entry does not exist");

        return (entry.dataHash, entry.owner, entry.metadataURI, entry.timestamp);
    }

    /**
     * @dev Verify if a specific hash matches stored data at position
     */
    function verifyHash(uint256 row, uint256 column, bytes32 dataHash) external view returns (bool) {
        HashEntry storage entry = matrix[row][column];
        return (entry.owner != address(0) && entry.dataHash == dataHash);
    }
}
// 
End
// 
