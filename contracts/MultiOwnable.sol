// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract MultiOwnable {
    event OwnerAdded(address indexed newOwner, address indexed invitedBy);

    mapping(address => bool) owners;
    uint160 public pendingOwner;

    constructor(address secondOwner) {
        owners[msg.sender] = true;
        owners[secondOwner] = true;
    }

    receive() external payable {}

    function withdraw() public {
        require(owners[msg.sender], "Only owner can withdraw");
        payable(msg.sender).transfer(address(this).balance);
    }

    function addOwner(address newOwner) public {
        require(owners[msg.sender], "Only owner can propose new owner");
        pendingOwner = uint160(newOwner) ^ uint160(address(msg.sender));
    }

    function acceptInvitation() public {
        address invitedBy = address(uint160(msg.sender) ^ pendingOwner);
        require(owners[invitedBy], "Can only be invited by owner");

        owners[msg.sender] = true;
        emit OwnerAdded(msg.sender, invitedBy);
    }
}