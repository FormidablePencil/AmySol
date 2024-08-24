// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "../managers/AMVManager.sol";

contract AMVDomain is IAMV, DebuggingUtils {
    AMV amv = new AMV();

    function setPrivateIPFSHash(
        string memory _hash,
        AuthorizedAddress[] memory _authorizedAddresses
    ) public override setSender() {
        amv.setPrivateIPFSHash(_hash, _authorizedAddresses);
    }
    function setPrivateIPFSHash(
        string memory _hash,
        AuthorizedAddress[] memory _authorizedAddresses,
        bool debug, address debugAddress
    ) public withDebug(debug, debugAddress) {
        amv.setPrivateIPFSHash(_hash, _authorizedAddresses);
    }

    function getPrivateIPFSHash() public override setSender() returns (IPFSHash[] memory) {
        return amv.getPrivateIPFSHash();
    }
    function getPrivateIPFSHash(
        bool _debugging, address _debugAddress
    ) public withDebug(_debugging, _debugAddress) returns (IPFSHash[] memory) {
        return amv.getPrivateIPFSHash();
    }

    function getAllPrivilegedAddressesToIPFSHashes(
        string memory _hash
    ) public override setSender() returns (AuthorizedAddress[] memory) {
        return amv.getAllPrivilegedAddressesToIPFSHashes(_hash);
    }
    function getAllPrivilegedAddressesToIPFSHashes(
        string memory _hash, bool _debugging, address _debugAddress
    ) public withDebug(_debugging, _debugAddress) returns (AuthorizedAddress[] memory) {
        return amv.getAllPrivilegedAddressesToIPFSHashes(_hash);
    }

    function revokeAccess(
        string memory _hash, address[] memory _users
    ) public override setSender() {
        amv.revokeAccess(_hash, _users);
    }
    function revokeAccess(
        string memory _hash, address[] memory _users, bool _debugging, address _debugAddress
    ) public withDebug(_debugging, _debugAddress) {
        amv.revokeAccess(_hash, _users);
    }

    function changeContentAccessLvl(
        string memory _hash, address _user, ContentAccessLvl contentAccessLvl
    ) public override setSender() {
        amv.changeContentAccessLvl(_hash, _user, contentAccessLvl);
    }
    function changeContentAccessLvl(
        string memory _hash, address _user, ContentAccessLvl contentAccessLvl, bool _debugging, address _debugAddress
    ) public withDebug(_debugging, _debugAddress) {
        amv.changeContentAccessLvl(_hash, _user, contentAccessLvl);
    }

    function isAuthorized(
        string memory _hash, address _user
    ) public override setSender() returns (bool) {
        return amv.isAuthorized(_hash, _user);
    }
    function isAuthorized(
        string memory _hash, address _user, bool _debugging, address _debugAddress
    ) public withDebug(_debugging, _debugAddress) returns (bool) {
        return amv.isAuthorized(_hash, _user);
    }
}