// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "hardhat/console.sol";
import "../abstracts/IAMV.sol";
import "../utils/DebuggingUtils.sol";

contract AMV is DebuggingUtils, IAMV {

    address private msgSender;

    constructor() {
        msgSender = msg.sender;
    }

    // Public IPFS hash TODO
    string public publicIPFSHash;
    // Mapping of private IPFS hash to authorized addresses
    mapping(string => AuthorizedAddress[]) private privateIPFSHashesToAddresses;
    mapping(address => IPFSHash[]) private privateIPFSHashesOfAuthorizedAddresses;

    // AuthorizedAddress[] private authorizedAddressesTemp;
    mapping(uint => AuthorizedAddress) private authorizedAddressesTemp;
    uint private authorizedAddressesTempLength;
    string private hashTemp;

    // Function to set private IPFS hash and authorize access
    function setPrivateIPFSHash(string memory _hash, AuthorizedAddress[] memory _authorizedAddresses) virtual override public {
        // Assigh variables outside to be used across function
        for (uint i = 0; i < _authorizedAddresses.length; i++) {
            authorizedAddressesTemp[i].addressVal = _authorizedAddresses[i].addressVal;
            authorizedAddressesTemp[i].contentAccessLvl = _authorizedAddresses[i].contentAccessLvl;
        }
        hashTemp = _hash;
        authorizedAddressesTempLength = _authorizedAddresses.length;

        checkIfAuthorizedAddressAlreadyExists_addAuthorizedAddressForGivenIpfsHash();

        // give all authorized addresses access to ipfs _hash
        for (uint i = 0; i < _authorizedAddresses.length; i++) {
            privateIPFSHashesOfAuthorizedAddresses[_authorizedAddresses[i].addressVal].push(IPFSHash(_hash));
        }
    }

    function getPrivateIPFSHash() public view override returns (IPFSHash[] memory) {
        return privateIPFSHashesOfAuthorizedAddresses[msgSender];
    }

    function getAllPrivilegedAddressesToIPFSHashes(string memory _hash) public view override returns (AuthorizedAddress[] memory) {
        AuthorizedAddress[] memory allPrivateIPFSHashesThatMsgSenderIsPrivilegedToAccess;
        
        // Iterate over all authorized addresses and if address is authorized to_hash then return hash
        for (uint i = 0; i < privateIPFSHashesOfAuthorizedAddresses[msgSender].length; i++) {
            if (keccak256(abi.encodePacked(privateIPFSHashesOfAuthorizedAddresses[msgSender][i].ipfsHash)) ==
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

    function revokeAccess(string memory _hash, address[] memory _users) public override {
        for (uint i = 0; i < privateIPFSHashesToAddresses[_hash].length; i++) {
            for (uint j = 0; j < _users.length; j++) {
                console.log(privateIPFSHashesToAddresses[_hash][i].addressVal);
                console.log(_users[j]);
                console.log(privateIPFSHashesToAddresses[_hash][i].addressVal == _users[j]);
                if (privateIPFSHashesToAddresses[_hash][i].addressVal == _users[j]) {
                    delete privateIPFSHashesToAddresses[_hash][i];
                }
                for (uint a = 0; a < privateIPFSHashesOfAuthorizedAddresses[_users[j]].length; a++) {
                    if (keccak256(abi.encodePacked(privateIPFSHashesOfAuthorizedAddresses[_users[j]][a].ipfsHash)) == 
                        keccak256(abi.encodePacked(_hash))) {
                        delete privateIPFSHashesOfAuthorizedAddresses[_users[j]][a];
                    }
                }
            }
        }
    }
    
    // Function to revoke access to private IPFS hash
    function changeContentAccessLvl(string memory _hash, address _user, ContentAccessLvl contentAccessLvl) public override {
        // TODO: check revoking previleges

        AuthorizedAddress[] memory p2a = privateIPFSHashesToAddresses[_hash];
        // for every authorized address check if == to _user  and if so set new priority level
        for (uint i = 0; i < p2a.length; i++) {
            if (p2a[i].addressVal == _user) {
                for (uint j = 0; j < privateIPFSHashesToAddresses[_hash].length; j++) {
                    if (privateIPFSHashesToAddresses[_hash][j].addressVal == _user) {
                        privateIPFSHashesToAddresses[_hash][j].contentAccessLvl = contentAccessLvl;
                        break;
                    }
                }
            }
        }
    }

    // Function to check if an address is authorized to access a private IPFS hash
    function isAuthorized(string memory _hash, address _user) public view override returns (bool) {
        AuthorizedAddress[] memory authorizedAddresses = privateIPFSHashesToAddresses[_hash];
        for (uint i = 0; i < authorizedAddresses.length; i++) {
            if (authorizedAddresses[i].addressVal == _user) {
                return true;
            }
        }
        return false;
    }

    // Adds a new authorized address to the mapping for the given private IPFS hash.
    function addAuthorizedAddresssForGivenIpfsHash(uint i) private {
        privateIPFSHashesToAddresses[hashTemp].push(AuthorizedAddress(
            authorizedAddressesTemp[i].addressVal, authorizedAddressesTemp[i].contentAccessLvl
        ));
    }

    // prevent duplicate authorizedAddresses
    // This function checks if an authorized address already exists in the mapping.
    // If the address exists with a different priority level, it deletes the existing entry and adds the new one.
    // If the address does not exist, it simply adds the new authorized address.
    function checkIfAuthorizedAddressAlreadyExists_addAuthorizedAddressForGivenIpfsHash() private {
        // prevent duplicate authorizedAddresses - TODO: write documentation for this code
        for (uint i = 0; i < authorizedAddressesTempLength; i++) {
            if (privateIPFSHashesToAddresses[hashTemp].length >= 1) {
                for (uint j = 0; j < privateIPFSHashesToAddresses[hashTemp].length; j++) {
                    if(privateIPFSHashesToAddresses[hashTemp][j].addressVal != authorizedAddressesTemp[i].addressVal &&
                        privateIPFSHashesToAddresses[hashTemp][j].contentAccessLvl != authorizedAddressesTemp[i].contentAccessLvl) {
                        addAuthorizedAddresssForGivenIpfsHash(i);
                    } else if (privateIPFSHashesToAddresses[hashTemp][j].addressVal == authorizedAddressesTemp[i].addressVal &&
                        privateIPFSHashesToAddresses[hashTemp][j].contentAccessLvl != authorizedAddressesTemp[i].contentAccessLvl) {
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