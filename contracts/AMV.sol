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

    // Public IPFS hash TODO
    string public publicIPFSHash;
    // Mapping of private IPFS hash to authorized addresses
    mapping(string => AuthorizedAddress[]) private privateIPFSHashesToAddresses;
    mapping(address => IPFSHash[]) private authorizedAddressesOfPrivateIPFSHashes;

    // AuthorizedAddress[] private authorizedAddressesTemp;
    mapping(uint => AuthorizedAddress) private authorizedAddressesTemp;
    uint private authorizedAddressesTempLength;
    string private hashTemp;

    // Function to set public IPFS hash
    function setPublicIPFSHash(string memory _hash) public onlyOwner {
        publicIPFSHash = _hash;
    }

    // Adds a new authorized address to the mapping for the given private IPFS hash.
    function addAuthorizedAddresssForGivenIpfsHash(uint i) private {
        privateIPFSHashesToAddresses[hashTemp].push(AuthorizedAddress(
            authorizedAddressesTemp[i].addressVal, authorizedAddressesTemp[i].priorityLevel
        ));
    }

    // Function to set private IPFS hash and authorize access
    // Todo: add ownder's address to the array of items
    function setPrivateIPFSHash(string memory _hash, AuthorizedAddress[] memory _authorizedAddresses) public {
        makeMsgSenderAuthorizedAddress();

        // Assigh variables outside to be used across function
        for (uint i = 0; i < _authorizedAddresses.length; i++) {
            authorizedAddressesTemp[i].addressVal = _authorizedAddresses[i].addressVal;
            authorizedAddressesTemp[i].priorityLevel = _authorizedAddresses[i].priorityLevel;
        }
        authorizedAddressesTempLength = _authorizedAddresses.length;
        hashTemp = _hash;

        checkIfAuthorizedAddressAlreadyExists();

        // give all authorized addresses access to ipfs _hash
        for (uint i = 0; i < _authorizedAddresses.length; i++) {
            authorizedAddressesOfPrivateIPFSHashes[_authorizedAddresses[i].addressVal].push(IPFSHash(_hash));
        }
    }

    function getPrivateIPFSHash() public view returns (IPFSHash[] memory) {
        return authorizedAddressesOfPrivateIPFSHashes[msg.sender];
    }


    function getAllPrivilegedAddressesToIPFSHashes(string memory _hash) public view returns (AuthorizedAddress[] memory) {
        AuthorizedAddress[] memory allPrivateIPFSHashesThatMsgSenderIsPrivilegedToAccess;
        
        // Iterate over all authorized addresses and if address is authorized to_hash then return hash
        for (uint i = 0; i < authorizedAddressesOfPrivateIPFSHashes[msg.sender].length; i++) {
            if (keccak256(abi.encodePacked(authorizedAddressesOfPrivateIPFSHashes[msg.sender][i].ipfsHash)) ==
                keccak256(abi.encodePacked(_hash))) {
                require(
                    privateIPFSHashesToAddresses[_hash].length > 0,
                     "msg.sender is authorized to get all privileged addresses asssociated to ipfs hash but non were found."
                );
                allPrivateIPFSHashesThatMsgSenderIsPrivilegedToAccess = privateIPFSHashesToAddresses[_hash];
            }
        }
        require(allPrivateIPFSHashesThatMsgSenderIsPrivilegedToAccess.length > 0, "Unauthorized address");

        return allPrivateIPFSHashesThatMsgSenderIsPrivilegedToAccess;
    }
    
    // Function to revoke access to private IPFS hash
    function revokeAccess(string memory _hash, address _user) public onlyOwner {
        // TODO: check revoking previleges

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

    // Only add msg.sender as authorized address if it doesn't already exist in the payload _authorizedAddresses
    function makeMsgSenderAuthorizedAddress() private {

        bool addOwnerToAuthorizedAddresses = true;
        
        for (uint i = 0; i < authorizedAddressesTempLength; i++) {
            if (authorizedAddressesTemp[i].addressVal == msg.sender) {
                addOwnerToAuthorizedAddresses = false;
            }
        }

        if (addOwnerToAuthorizedAddresses) {
            privateIPFSHashesToAddresses[hashTemp].push(AuthorizedAddress(msg.sender, ContentPriorityLevel.Admin));
        }
    }

    // prevent duplicate authorizedAddresses
    // This function checks if an authorized address already exists in the mapping.
    // If the address exists with a different priority level, it deletes the existing entry and adds the new one.
    // If the address does not exist, it simply adds the new authorized address.
    function checkIfAuthorizedAddressAlreadyExists() private {
        // prevent duplicate authorizedAddresses - TODO: write documentation for this code
        for (uint i = 0; i < authorizedAddressesTempLength; i++) {
            if (privateIPFSHashesToAddresses[hashTemp].length >= 1) {
                for (uint j = 0; j < privateIPFSHashesToAddresses[hashTemp].length; j++) {
                    if(privateIPFSHashesToAddresses[hashTemp][j].addressVal != authorizedAddressesTemp[i].addressVal &&
                        privateIPFSHashesToAddresses[hashTemp][j].priorityLevel != authorizedAddressesTemp[i].priorityLevel) {
                        addAuthorizedAddresssForGivenIpfsHash(i);
                    } else if (privateIPFSHashesToAddresses[hashTemp][j].addressVal == authorizedAddressesTemp[i].addressVal &&
                        privateIPFSHashesToAddresses[hashTemp][j].priorityLevel != authorizedAddressesTemp[i].priorityLevel) {
                        delete privateIPFSHashesToAddresses[hashTemp][i];
                        addAuthorizedAddresssForGivenIpfsHash(i);
                    }
                }
            } else {
                addAuthorizedAddresssForGivenIpfsHash(i);
            }
        }
    }
}