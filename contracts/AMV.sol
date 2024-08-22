// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "hardhat/console.sol";

contract Ownable {
    address private owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
}


enum ContentPriorityLevel {
    Admin, Editor, ViewOnly
}

contract AMV is Ownable {

    struct IPFSHash {
        string ipfsHash;
        // todo: add date upon creation
    }

    struct AuthorizedAddress {
        address addressVal;
        ContentPriorityLevel priorityLevel;
    }

    // Public IPFS hash
    string public publicIPFSHash;

    // Mapping of private IPFS hash to authorized addresses
    mapping(string => AuthorizedAddress[]) private privateIPFSHashesToAddresses;
    mapping(address => IPFSHash[]) private authorizedAddressesToGetPrivateIPFSHashes;

    // Function to set public IPFS hash
    function setPublicIPFSHash(string memory _hash) public onlyOwner {
        publicIPFSHash = _hash;
    }

    // Function to set private IPFS hash and authorize access
    // Todo: add ownder's address to the array of items
    function setPrivateIPFSHash(string memory _hash, AuthorizedAddress[] memory _authorizedAddresses) public onlyOwner {
        // ======== Only add msg.sender as authorized address if it doesn't already exist in the payload _authorizedAddresses ========
        bool addOwnerToAuthorizedAddresses = true;
        
        for (uint i = 0; i < _authorizedAddresses.length; i++) {
            if (_authorizedAddresses[i].addressVal == msg.sender) {
                addOwnerToAuthorizedAddresses = false;
            }
        }

        if (addOwnerToAuthorizedAddresses) {
            privateIPFSHashesToAddresses[_hash].push(AuthorizedAddress(msg.sender, ContentPriorityLevel.Admin));
        }
        // ================

        // Create a copy of _authorizedAddresses
        AuthorizedAddress[] memory authorizedAddressesCopy = new AuthorizedAddress[](_authorizedAddresses.length);
        for (uint i = 0; i < _authorizedAddresses.length; i++) {
            authorizedAddressesCopy[i] = _authorizedAddresses[i];
        }

        // prevent duplicate authorizedAddresses - TODO: write documentation for this code
        for (uint i = 0; i < _authorizedAddresses.length; i++) {
            if (privateIPFSHashesToAddresses[_hash].length >= 1) {
                for (uint j = 0; j < privateIPFSHashesToAddresses[_hash].length; j++) {
                    if(privateIPFSHashesToAddresses[_hash][j].addressVal != _authorizedAddresses[i].addressVal &&
                        privateIPFSHashesToAddresses[_hash][j].priorityLevel != _authorizedAddresses[i].priorityLevel) {
                        privateIPFSHashesToAddresses[_hash].push(AuthorizedAddress(_authorizedAddresses[i].addressVal, _authorizedAddresses[i].priorityLevel));
                    } else if (privateIPFSHashesToAddresses[_hash][j].addressVal == _authorizedAddresses[i].addressVal &&
                        privateIPFSHashesToAddresses[_hash][j].priorityLevel != _authorizedAddresses[i].priorityLevel) {
                        delete privateIPFSHashesToAddresses[_hash][i];
                        privateIPFSHashesToAddresses[_hash].push(AuthorizedAddress(_authorizedAddresses[i].addressVal, _authorizedAddresses[i].priorityLevel));
                    }
                }
            } else {
                privateIPFSHashesToAddresses[_hash].push(AuthorizedAddress(_authorizedAddresses[i].addressVal, _authorizedAddresses[i].priorityLevel));
            }
        }

        // Avoid duplicate hash associated to a authorized address
        for (uint i = 0; i < authorizedAddressesToGetPrivateIPFSHashes[msg.sender].length; i++) {
            if (keccak256(abi.encodePacked(authorizedAddressesToGetPrivateIPFSHashes[msg.sender][i].ipfsHash)) == keccak256(abi.encodePacked(_hash))) {
                authorizedAddressesToGetPrivateIPFSHashes[msg.sender].push(IPFSHash(_hash));
            }
        }

        // update authorized addresses for content
        for (uint i = 0; i < _authorizedAddresses.length; i++) {
            authorizedAddressesToGetPrivateIPFSHashes[_authorizedAddresses[i].addressVal].push(IPFSHash(_hash));
        }
    }

    function getPrivateIPFSHash() public onlyOwner view returns (IPFSHash[] memory) {
        return authorizedAddressesToGetPrivateIPFSHashes[msg.sender];
    }


    // // TODO: change how privlege access is done
    function getAllPrivilegedAddressesToIPFSHashes(string memory _hash) public view returns (AuthorizedAddress[] memory) {
        AuthorizedAddress[] memory allPrivateIPFSHashesThatMsgSenderIsPrivilegedToAccess;

        // Iterate over all authorized addresses and if address is authorized to _hash then return hash
        for (uint i = 0; i < authorizedAddressesToGetPrivateIPFSHashes[msg.sender].length; i++) {
            if (keccak256(abi.encodePacked(authorizedAddressesToGetPrivateIPFSHashes[msg.sender][i].ipfsHash)) == keccak256(abi.encodePacked(_hash))) {
                require(privateIPFSHashesToAddresses[_hash].length > 0, "msg.sender is authorized to get all privileged addresses asssociated to ipfs hash but non were found.");
                allPrivateIPFSHashesThatMsgSenderIsPrivilegedToAccess = privateIPFSHashesToAddresses[_hash];
            }
        }
        require(allPrivateIPFSHashesThatMsgSenderIsPrivilegedToAccess.length > 0, "Unauthorized address");

        return allPrivateIPFSHashesThatMsgSenderIsPrivilegedToAccess;
    }
    
    // Function to revoke access to private IPFS hash
    function revokeAccess(string memory _hash, address _user) public onlyOwner {
        AuthorizedAddress[] memory authorizedAddresses = privateIPFSHashesToAddresses[_hash];
        for (uint i = 0; i < authorizedAddresses.length; i++) {
            if (authorizedAddresses[i].addressVal == _user) {
                delete privateIPFSHashesToAddresses[_hash];
                break;
            }
        }
    }

    // Function to check if an address is authorized to access a private IPFS hash
    function isAuthorized(string memory _hash, address _user) public view returns (bool) {
        AuthorizedAddress[] memory authorizedAddresses = privateIPFSHashesToAddresses[_hash];
        for (uint i = 0; i < authorizedAddresses.length; i++) {
            if (authorizedAddresses[i].addressVal == _user) {
                return true;
            }
        }
        return false;
    }
}