// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

abstract contract DebuggingUtils {
    bool debugging = false;
    address private msgSender;

    modifier withDebug(bool _debugging, address _debugAddress) {
        debugging = _debugging;
        msgSender = _debugAddress;
        msg.sender;
        _;
    }
    
    modifier setSender() {
        msgSender = msg.sender;
        _;
    }

    modifier valSender() {
        require(msg.sender == msgSender, "msg.sender is not msgSender so you can't get msgSender");
        _;
    }

    // Only found use case in debugging
    function getMsgSender() public view valSender() returns (address) {
        return msgSender;
   }
}