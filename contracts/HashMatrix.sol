// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title HashMatrix
 * @dev A decentralized data verification system using matrix-based hash storage
 */
contract HashMatrix {
    struct MatrixCell {
        bytes32 dataHash;
        uint256 timestamp;
        address contributor;
        bool verified;
    }
    
    mapping(uint256 => mapping(uint256 => MatrixCell)) public matrix;
    mapping(address => uint256) public contributionCount;
    
    uint256 public constant TOTAL_ROWS = 100;
    uint256 public constant TOTAL_COLUMNS = 100;
    
    event CellCreated(uint256 indexed row, uint256 indexed col, bytes32 dataHash, address contributor);
    event CellVerified(uint256 indexed row, uint256 indexed col, address verifier);
    
    function storeHash(uint256 row, uint256 col, string memory data) external {
        require(row < TOTAL_ROWS && col < TOTAL_COLUMNS, "Invalid matrix position");
        require(matrix[row][col].dataHash == bytes32(0), "Cell already occupied");
        
        bytes32 dataHash = keccak256(abi.encodePacked(data));
        
        matrix[row][col] = MatrixCell({
            dataHash: dataHash,
            timestamp: block.timestamp,
            contributor: msg.sender,
            verified: false
        });
        
        contributionCount[msg.sender]++;
        emit CellCreated(row, col, dataHash, msg.sender);
    }
    
    function verifyCell(uint256 row, uint256 col) external {
        require(matrix[row][col].dataHash != bytes32(0), "Cell is empty");
        require(!matrix[row][col].verified, "Already verified");
        require(matrix[row][col].contributor != msg.sender, "Cannot verify own cell");
        
        matrix[row][col].verified = true;
        emit CellVerified(row, col, msg.sender);
    }
    
    function getCell(uint256 row, uint256 col) external view returns (MatrixCell memory) {
        return matrix[row][col];
    }
    
    function verifyCellData(uint256 row, uint256 col, string memory data) external view returns (bool) {
        bytes32 dataHash = keccak256(abi.encodePacked(data));
        return matrix[row][col].dataHash == dataHash;
    }
    
    function getTotalContributions() external view returns (uint256) {
        return contributionCount[msg.sender];
    }
}
// 
update
// 
