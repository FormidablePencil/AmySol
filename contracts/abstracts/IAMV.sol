
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

// =============================================================================
// This is a generated file by /codegen. Don't make edits to this file directly.
// This generate code comes from /codegen/codegen.rs
// =============================================================================

import '../data/AMVData.sol';
        
abstract contract IAMV  {

    function setPrivateIPFSHash(
        string memory _hash, AuthorizedAddress[] memory _authorizedAddresses
    )  virtual public;
    function getPrivateIPFSHash(
        string memory _hash, AuthorizedAddress[] memory _authorizedAddresses
    ) public virtual  returns ( IPFSHash[] memory);
    function getAllPrivilegedAddressesToIPFSHashes(
        string memory _hash
    ) virtual public  returns ( AuthorizedAddress[] memory);
    function revokeAccess(
        string memory _hash, address[] memory _users
    ) public virtual ;
    function changeContentAccessLvl(
        string memory _hash, ContentAccessLvl  _contentAccess
    ) virtual  public;
    function isAuthorized(
        string memory _hash, address  _user
    ) public virtual  returns ( bool );
}