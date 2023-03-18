//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract EIP712 {
    bytes32 private DOMAIN_SEPARATOR;
    
    constructor(string memory name, string memory version) {
        DOMAIN_SEPARATOR="test";
    }

    function _domainSeparator() public view returns (bytes32) {
        return DOMAIN_SEPARATOR;
    }
    
    function _toTypedDataHash(bytes32 structHash) public returns (bytes32) {
        bytes32 digest=keccak256(abi.encode(uint16(0x1901),_domainSeparator(),structHash));
        return digest; // digest 
    }
}