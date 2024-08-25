// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

enum ContentAccessLvl {
    Admin, Editor, ViewOnly
}

struct AuthorizedAddress {
    address addressVal;
    ContentAccessLvl contentAccessLvl;
}

struct IPFSHash {
    string ipfsHash;
    // todo: add date upon creation
}
