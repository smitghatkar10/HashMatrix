// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title HashMatrix
 * @dev 2D matrix-style hash registry: store and lookup hashes by row/column keys
 * @notice Useful for organizing hashed artifacts in a logical grid (e.g., projects vs. versions)
 */
contract HashMatrix {
    address public owner;

    struct Cell {
        bytes32 value;      // stored hash
        uint256 createdAt;  // timestamp
        bool    exists;
    }

    // rowKey => colKey => Cell
    mapping(bytes32 => mapping(bytes32 => Cell)) public matrix;

    // index of row and column keys for enumeration
    mapping(bytes32 => bytes32[]) public colsOfRow;
    mapping(bytes32 => bool) public colSeenForRow;

    event HashSet(
        bytes32 indexed rowKey,
        bytes32 indexed colKey,
        bytes32 value,
        uint256 timestamp
    );

    event HashCleared(
        bytes32 indexed rowKey,
        bytes32 indexed colKey,
        uint256 timestamp
    );

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Set or update a hash at matrix[rowKey][colKey]
     * @param rowKey Row identifier (e.g., project/group)
     * @param colKey Column identifier (e.g., version/index)
     * @param value Hash value to store
     */
    function setHash(
        bytes32 rowKey,
        bytes32 colKey,
        bytes32 value
    ) external onlyOwner {
        require(rowKey != 0 && colKey != 0, "Invalid keys");
        require(value != 0, "Invalid hash");

        Cell storage c = matrix[rowKey][colKey];

        if (!c.exists) {
            colsOfRow[rowKey].push(colKey);
            c.exists = true;
        }

        c.value = value;
        c.createdAt = block.timestamp;

        emit HashSet(rowKey, colKey, value, block.timestamp);
    }

    /**
     * @dev Clear a hash cell, keeping history off-chain via events
     */
    function clearHash(bytes32 rowKey, bytes32 colKey)
        external
        onlyOwner
    {
        Cell storage c = matrix[rowKey][colKey];
        require(c.exists, "No cell");

        delete matrix[rowKey][colKey];

        emit HashCleared(rowKey, colKey, block.timestamp);
    }

    /**
     * @dev Get a cell's data
     */
    function getCell(bytes32 rowKey, bytes32 colKey)
        external
        view
        returns (bytes32 value, uint256 createdAt, bool exists)
    {
        Cell memory c = matrix[rowKey][colKey];
        return (c.value, c.createdAt, c.exists);
    }

    /**
     * @dev Get all column keys used in a given row
     */
    function getColsOfRow(bytes32 rowKey)
        external
        view
        returns (bytes32[] memory)
    {
        return colsOfRow[rowKey];
    }

    /**
     * @dev Transfer ownership
     */
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Zero address");
        address prev = owner;
        owner = newOwner;
        emit OwnershipTransferred(prev, newOwner);
    }
}
