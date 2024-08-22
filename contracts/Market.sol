// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract Market {
    address owner;
    bool public isReserved;
    string itemName;
    uint256 public balance;
    // uint256 reservationTime;

    constructor() {
        // rent, house for sale or even just an item
        owner = msg.sender;
        isReserved = false;
        balance = 0;
        // reservationTime = 0;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier notReserved {
        require(!isReserved, "Item is already reserved");
        _;
    }

    // modifier onlyAfterReservationTime {
    //     require(block.timestamp > reservationTime, "Not yet reached the reservation time");
    //     _;
    // }

    function reserve(string memory _itemName) public notReserved payable {
        // require(_rentAmount > 0, "Rent amount must be greater than 0");
        // require(_reservationTime > block.timestamp, "Reservation time must be in the future");
        require(owner == msg.sender, "Only owner can reserve an item");
        require(isReserved == false);
        isReserved = true;
        itemName = _itemName;
        // require(msg.value >= rentAmount, "Insufficient funds to rent");
        // payable(owner).transfer(msg.value);
        balance += msg.value;
        // reservationTime = _reservationTime;
    }

    function cancelReservation() public onlyOwner {
        require(isReserved, "Item is not reserved");
        isReserved = false;
        // reservationTime = 0;
        // Refund the Ether to the user
        payable(msg.sender).transfer(balance);
        balance -= balance;
    }
}