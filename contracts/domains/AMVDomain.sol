
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

// =============================================================================
// This is a generated file by /codegen. Don't make edits to this file directly.
// This code generated comes from /codegen/codegen.rs
// =============================================================================

import '../managers/AMVManager.sol';
                
contract AMVDomain is DebuggingUtils, IAMV {
    function setPrivateIPFSHash(" \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash" \"AuthorizedAddressArr[] "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _authorizedAddresses, bool _debugging, address _debugAddress)   "\"\\\" \\\\\\\"Override\\\\\\\"\\\"\""  "\"\\\" \\\\\\\"Public\\\\\\\"\\\"\"" withDebug(_debugging, _debugAddress)  {
            return amv.setPrivateIPFSHash(, " \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash, " \"AuthorizedAddressArr[] "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _authorizedAddresses)
        }
function setPrivateIPFSHash(" \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash" \"AuthorizedAddressArr[] "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _authorizedAddresses, bool _debugging, address _debugAddress)   "\"\\\" \\\\\\\"Public\\\\\\\"\\\"\"" withDebug(_debugging, _debugAddress)  {
            return amv.setPrivateIPFSHash(, " \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash, " \"AuthorizedAddressArr[] "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _authorizedAddresses)
        }function getPrivateIPFSHash(" \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash" \"AuthorizedAddressArr[] "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _authorizedAddresses, bool _debugging, address _debugAddress)   "\"\\\" \\\\\\\"Public\\\\\\\"\\\"\""  "\"\\\" \\\\\\\"Override\\\\\\\"\\\"\"" withDebug(_debugging, _debugAddress)  returns ( " \"IPFSHashArr[] ) {
            return amv.getPrivateIPFSHash(, " \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash, " \"AuthorizedAddressArr[] "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _authorizedAddresses)
        }
function getPrivateIPFSHash(" \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash" \"AuthorizedAddressArr[] "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _authorizedAddresses, bool _debugging, address _debugAddress)   "\"\\\" \\\\\\\"Public\\\\\\\"\\\"\"" withDebug(_debugging, _debugAddress)  returns ( " \"IPFSHashArr[] ) {
            return amv.getPrivateIPFSHash(, " \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash, " \"AuthorizedAddressArr[] "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _authorizedAddresses)
        }function getAllPrivilegedAddressesToIPFSHashes(" \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash, bool _debugging, address _debugAddress)   "\"\\\" \\\\\\\"Public\\\\\\\"\\\"\""  "\"\\\" \\\\\\\"Override\\\\\\\"\\\"\"" withDebug(_debugging, _debugAddress)  returns ( " \"AuthorizedAddressArr[] ) {
            return amv.getAllPrivilegedAddressesToIPFSHashes(, " \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash)
        }
function getAllPrivilegedAddressesToIPFSHashes(" \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash, bool _debugging, address _debugAddress)   "\"\\\" \\\\\\\"Public\\\\\\\"\\\"\"" withDebug(_debugging, _debugAddress)  returns ( " \"AuthorizedAddressArr[] ) {
            return amv.getAllPrivilegedAddressesToIPFSHashes(, " \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash)
        }function revokeAccess(" \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash" \"AddressArr[] "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _users, bool _debugging, address _debugAddress)   "\"\\\" \\\\\\\"Public\\\\\\\"\\\"\""  "\"\\\" \\\\\\\"Override\\\\\\\"\\\"\"" withDebug(_debugging, _debugAddress)  {
            return amv.revokeAccess(, " \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash, " \"AddressArr[] "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _users)
        }
function revokeAccess(" \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash" \"AddressArr[] "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _users, bool _debugging, address _debugAddress)   "\"\\\" \\\\\\\"Public\\\\\\\"\\\"\"" withDebug(_debugging, _debugAddress)  {
            return amv.revokeAccess(, " \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash, " \"AddressArr[] "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _users)
        }function changeContentAccessLvl(" \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash" \"ContentAccessLvl\"" "" _contentAccess, bool _debugging, address _debugAddress)   "\"\\\" \\\\\\\"Public\\\\\\\"\\\"\""  "\"\\\" \\\\\\\"Override\\\\\\\"\\\"\"" withDebug(_debugging, _debugAddress)  {
            return amv.changeContentAccessLvl(, " \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash, " \"ContentAccessLvl\"" "" _contentAccess)
        }
function changeContentAccessLvl(" \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash" \"ContentAccessLvl\"" "" _contentAccess, bool _debugging, address _debugAddress)   "\"\\\" \\\\\\\"Public\\\\\\\"\\\"\"" withDebug(_debugging, _debugAddress)  {
            return amv.changeContentAccessLvl(, " \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash, " \"ContentAccessLvl\"" "" _contentAccess)
        }function isAuthorized(" \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash" \"Address\"" "" _user, bool _debugging, address _debugAddress)   "\"\\\" \\\\\\\"Override\\\\\\\"\\\"\""  "\"\\\" \\\\\\\"Public\\\\\\\"\\\"\"" withDebug(_debugging, _debugAddress)  returns ( " \"Bool\"" ) {
            return amv.isAuthorized(, " \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash, " \"Address\"" "" _user)
        }
function isAuthorized(" \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash" \"Address\"" "" _user, bool _debugging, address _debugAddress)   "\"\\\" \\\\\\\"Public\\\\\\\"\\\"\"" withDebug(_debugging, _debugAddress)  returns ( " \"Bool\"" ) {
            return amv.isAuthorized(, " \"String\"" "\" \\\"\\\\\\\"\\\\\\\\\\\\\\\" \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Memory\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\"" _hash, " \"Address\"" "" _user)
        }
}