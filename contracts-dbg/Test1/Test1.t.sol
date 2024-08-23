// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../../contracts/Lock.sol";
import "../../contracts/domains/AMVDomain.sol";
import "hardhat/console.sol";

contract UsersAddresses {
    address public owner = 0xcd3B766CCDd6AE721141F452C550Ca635964ce71;
    address public user1 = 0xCD3b766CcDd6AE721141F452C550Ca635964CE72;
    address public user2 = 0xCD3b766CcDD6aE721141f452c550cA635964cE73;
    address public user3 = 0xCd3b766cCDD6ae721141F452C550ca635964cE74;
}

contract TestUtil is UsersAddresses {
    string public hashVal = "QmZULkVbpcv5j7n2keV2B92z2u1P3h9K9Fo91Y7s5zXw1";
    string public hashVal2 = "QmbWqxBEKC3P8tqsKc98xmWNzrzDtRLMiMPL8wBuTGsMnR";

    // function hashVal() public pure returns (string memory) {
    //     string memory hashVal2 = "QmbWqxBEKC3P8tqsKc98xmWNzrzDtRLMiMPL8wBuTGsMnR";
    //     return hashVal2;
    // }

    // UsersAddresses public ua = new UsersAddresses();
}

contract DbgEntry is TestUtil {
    event EvmPrint(string);
    event EvmPrint(address);
    event EvmSpoofOriginOpcode(address addr);

    AMV amv;
    AuthorizedAddress[] public authorizedAddreses;
    TestUtil testUtil = new TestUtil();
    // UsersAddresses ua = testUtil.ua();
    // string public hashVal;

    constructor() {
        // authorizedAddreses = [
        authorizedAddreses.push(AuthorizedAddress(owner, ContentAccessLvl.Admin));
        authorizedAddreses.push(AuthorizedAddress(user2, ContentAccessLvl.Editor));
        //     AMV.AuthorizedAddress(user2, ContentAccessLvl.Editor)
        // ];

        // Here you can either deploy your contracts via `new`, eg:
        //  Counter counter = new Counter();
        //  counter.increment();

        // or interact with an existing deployment by specifying a `fork` url in `dbg.project.json`
        // eg:
        //  ICounter counter = ICounter(0x12345678.....)
        //  counter.increment(); 
        //
        // If you have correct symbols (`artifacts`) for the deployed contract, you can step-into calls.

        // assert(condition);

        emit EvmPrint("DbgEntry return");
 
        setPrivateIPFSHash_shouldReturnThePrivateIPFSHashesForTheGivenAuthorizedAddress();
    }

    function expectToEqual(bool boolean) public pure {
        require(boolean, "Not equal values");
    }

    function expectToEqualAbiEncodePacked(string memory first, string memory second) public pure {
        require(keccak256(abi.encodePacked(first)) == keccak256(abi.encodePacked(second)), "Not equal values");
    }

    function compareAuthorizedAddreses(AuthorizedAddress[] memory p0) private view {
        expectToEqual(p0.length == authorizedAddreses.length);

        for (uint i = 0; i < p0.length; i++) {
            expectToEqual(p0[i].addressVal == authorizedAddreses[i].addressVal);
            expectToEqual(p0[i].contentAccessLvl == authorizedAddreses[i].contentAccessLvl);
        }
    }

    modifier beforeEach() {
        authorizedAddreses[0] = AuthorizedAddress(owner, ContentAccessLvl.Admin);
        authorizedAddreses[1] = AuthorizedAddress(user2, ContentAccessLvl.Editor);
        amv = new AMV();
        _;
    }    

    function extractStringFromBytes32(string memory input) public pure returns (string memory) {
        return string(input);
    }


    function setPrivateIPFSHash_shouldReturnThePrivateIPFSHashesForTheGivenAuthorizedAddress() public beforeEach() {
        amv.setPrivateIPFSHash(hashVal, authorizedAddreses);
        amv.setPrivateIPFSHash(hashVal2, authorizedAddreses);

        IPFSHash[] memory aa = amv.getPrivateIPFSHash();
        expectToEqualAbiEncodePacked(aa[0].ipfsHash, hashVal);
        expectToEqualAbiEncodePacked(aa[1].ipfsHash, hashVal2);
    }
}