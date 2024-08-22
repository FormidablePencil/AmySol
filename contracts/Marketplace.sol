// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "hardhat/console.sol";
import "./AMV.sol";

contract Marketplace {
    struct Hash {
        string value;
        // add date
    }

    // AMV amv;

    mapping(string => Hash[]) hashStructs;

    function saveUnderKeywords(Hash memory _hashStruct, string[] memory _keywords) public {
        // todo: check if sender.msg is authorized to make keyword edits
        // require(amv.isAuthorized(_hashStruct.value, msg.sender));
        for (uint i = 0; i < _keywords.length; i++) {
            // make sure there isn't already a hash under the same keyword
            for (uint j = 0; j < hashStructs[_keywords[i]].length; j++) {
                // todo: return message
                // console.log(hashStructs[_keywords[i]][j].value != _hashStruct.value, "Hash already exists under keyword");
                console.log(keccak256(abi.encodePacked(hashStructs[_keywords[i]][j].value)) != keccak256(abi.encodePacked(_hashStruct.value)), "Hash already exists under keyword");
            }
            hashStructs[_keywords[i]].push(_hashStruct);
        }
    }

    function getHashesUnderKeywords(string[] memory _keywords) public view returns (Hash[] memory) {
        Hash[] memory hashes;
        for (uint i = 0; i < _keywords.length; i++) {
            Hash[] memory tempHashes = hashStructs[_keywords[i]];
            hashes = arrayConcat(hashes, tempHashes);
        }
        return hashes;
    }

    function deleteHashesFromKeywords(Hash memory _hashStruct, string[] memory _keywords) public returns (Hash[] memory) {
        for (uint i = 0; i < _keywords.length; i++) {
            for (uint j = 0; j < hashStructs[_keywords[i]].length; j++) {
                if (keccak256(abi.encodePacked(hashStructs[_keywords[i]][j].value)) == keccak256(abi.encodePacked(_hashStruct.value))) {
                    delete hashStructs[_keywords[i]][j];
                }
            }
        }
        return new Hash[](0); // Explicitly return an empty array
    }

    function arrayConcat(Hash[] memory a, Hash[] memory b) internal pure returns (Hash[] memory) {
        uint lenA = a.length;
        uint lenB = b.length;
        Hash[] memory result = new Hash[](lenA + lenB);
        for (uint i = 0; i < lenA; i++) {
            result[i] = a[i];
        }
        for (uint j = 0; j < lenB; j++) {
            result[lenA + j] = b[j];
        }
        return result;
    }
}
