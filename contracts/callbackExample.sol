// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;


// contract Oracle {
//     struct Request {
//         bytes data;
//         function(uint) external callback;
//     }
//     Request[] private requests;
//     event NewRequest(uint);

//     function query(bytes memory data, function(uint) external callback) public {
//         requests.push(Request(data, callback));
//         emit NewRequest(requests.length - 1);
//     }

//     function reply(uint requestID, uint response) public {
//         // Check that the reply comes from a trusted source
//         requests[requestID].callback(response);
//     }
// }

// contract OracleUser {
//     Oracle constant private ORACLE_CONST = Oracle(0x1234567); // known contract
//     uint private exchangeRate;

//     function buySomething() public {
//         ORACLE_CONST.query("USD", this.oracleResponse);
//     }

//     function oracleResponse(uint response) public {
//         require(msg.sender == address(ORACLE_CONST), "Only oracle can call this.");
//     }
// }