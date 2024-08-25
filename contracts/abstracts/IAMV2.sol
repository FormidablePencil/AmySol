// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "../data/aMVData.sol";

abstract contract IAMV {
    function setPrivateIPFSHash(string memory _hash, AuthorizedAddress[] memory _authorizedAddresses) public virtual;
    function getPrivateIPFSHash() public virtual returns (IPFSHash[] memory);
    function getAllPrivilegedAddressesToIPFSHashes(string memory _hash) public virtual returns (AuthorizedAddress[] memory);
    function revokeAccess(string memory _hash, address[] memory _users) public virtual;
    function changeContentAccessLvl(string memory _hash, address _user, ContentAccessLvl contentAccessLvl) public virtual;
    function isAuthorized(string memory _hash, address _user) public virtual returns (bool);
}