
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

// =============================================================================
// This is a generated file by /codegen. Don't make edits to this file directly.
// This code generated comes from /codegen/codegen.rs
// =============================================================================


abstract contract IAMV  {
    
    function setPrivateIPFSHash(
    " \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash" \"AuthorizedAddressArr[] "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _authorizedAddresses, bool _debugging, address _debugAddress
    ) withDebug(_debugging, _debugAddress);
    
    function getPrivateIPFSHash(
    " \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash" \"AuthorizedAddressArr[] "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _authorizedAddresses, bool _debugging, address _debugAddress
    ) withDebug(_debugging, _debugAddress) returns ( " \"IPFSHashArr[] );
    
    function getAllPrivilegedAddressesToIPFSHashes(
    " \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash, bool _debugging, address _debugAddress
    ) withDebug(_debugging, _debugAddress) returns ( " \"AuthorizedAddressArr[] );
    
    function revokeAccess(
    " \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash" \"AddressArr[] "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _users, bool _debugging, address _debugAddress
    ) withDebug(_debugging, _debugAddress);
    
    function changeContentAccessLvl(
    " \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash" \"ContentAccessLvl\"" "" _contentAccess, bool _debugging, address _debugAddress
    ) withDebug(_debugging, _debugAddress);
    
    function isAuthorized(
    " \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash" \"Address\"" "" _user, bool _debugging, address _debugAddress
    ) withDebug(_debugging, _debugAddress) returns ( " \"Bool\"" );
    
}