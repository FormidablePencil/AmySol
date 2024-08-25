
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

// =============================================================================
// This is a generated file by /codegen. Don't make edits to this file directly.
// This generate code comes from /codegen/codegen.rs
// =============================================================================

import '../managers/AMVManager.sol';
        
contract AMVDomain is IAMV, DebuggingUtils {

    AMV amv = new AMV();
        
    function setPrivateIPFSHash(
        string memory _hash, AuthorizedAddress[] memory _authorizedAddresses
    ) public override setSender()  {
        return amv.setPrivateIPFSHash(_hash, _authorizedAddresses);
    }

    function setPrivateIPFSHash(
        string memory _hash, AuthorizedAddress[] memory _authorizedAddresses, bool _debugging, address _debugAddress
    ) public  withDebug(_debugging, _debugAddress)  {
        return amv.setPrivateIPFSHash(_hash, _authorizedAddresses);
    }
    function getPrivateIPFSHash(
        string memory _hash, AuthorizedAddress[] memory _authorizedAddresses
    ) override setSender() public  returns ( IPFSHash[] memory) {
        return amv.getPrivateIPFSHash(_hash, _authorizedAddresses);
    }

    function getPrivateIPFSHash(
        string memory _hash, AuthorizedAddress[] memory _authorizedAddresses, bool _debugging, address _debugAddress
    ) public  withDebug(_debugging, _debugAddress)  returns ( IPFSHash[] memory) {
        return amv.getPrivateIPFSHash(_hash, _authorizedAddresses);
    }
    function getAllPrivilegedAddressesToIPFSHashes(string memory _hash) setSender() public override  returns ( AuthorizedAddress[] memory) {
        return amv.getAllPrivilegedAddressesToIPFSHashes(_hash);
    }

    function getAllPrivilegedAddressesToIPFSHashes(
        string memory _hash, bool _debugging, address _debugAddress
    )  public withDebug(_debugging, _debugAddress)  returns ( AuthorizedAddress[] memory) {
        return amv.getAllPrivilegedAddressesToIPFSHashes(_hash);
    }
    function revokeAccess(
        string memory _hash, address[] memory _users
    ) override setSender() public  {
        return amv.revokeAccess(_hash, _users);
    }

    function revokeAccess(
        string memory _hash, address[] memory _users, bool _debugging, address _debugAddress
    )  public withDebug(_debugging, _debugAddress)  {
        return amv.revokeAccess(_hash, _users);
    }
    function changeContentAccessLvl(
        string memory _hash, ContentAccessLvl  _contentAccess
    ) setSender() override public  {
        return amv.changeContentAccessLvl(_hash, _contentAccess);
    }

    function changeContentAccessLvl(
        string memory _hash, ContentAccessLvl  _contentAccess, bool _debugging, address _debugAddress
    ) public  withDebug(_debugging, _debugAddress)  {
        return amv.changeContentAccessLvl(_hash, _contentAccess);
    }
    function isAuthorized(
        string memory _hash, address  _user
    ) setSender() public override  returns ( bool ) {
        return amv.isAuthorized(_hash, _user);
    }

    function isAuthorized(
        string memory _hash, address  _user, bool _debugging, address _debugAddress
    ) public  withDebug(_debugging, _debugAddress)  returns ( bool ) {
        return amv.isAuthorized(_hash, _user);
    }
}