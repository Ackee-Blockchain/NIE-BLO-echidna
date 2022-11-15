// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/*
This contract can accept Ether donations together with messages (in the form of up to 32 bytes of data).
The contract accepts a list of commands. There are currently two implemented commands:
- ACCEPT_ETHER: Accepts the Ether donation and stores the message in the donations mapping.
- WITHDRAW_ETHER: Withdraws the Ether from the contract. Can only be executed by the owner of the contract.

Messages in a single donation are concatenated together. For example, if a donation is made with two messages
of length 10 and 20 bytes, the donations mapping will contain a 30-byte message.

Try to exploit the contract to steal Ether from the contract.
*/
contract Executor {
    enum CommandKind {
        ACCEPT_ETHER,
        WITHDRAW_ETHER
    }

    struct Command {
        CommandKind kind;
        bytes message;
        uint bufferIndex;
    }

    mapping(address => bytes) public donations;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function execute(Command[] memory commands) public payable {
        uint totalLength = 0;
        for (uint i = 0; i < commands.length; i++) {
            require(commands[i].message.length <= 32, "Message too long");
            require(msg.sender == owner || commands[i].kind != CommandKind.WITHDRAW_ETHER, "Only owner can withdraw");
            totalLength += commands[i].message.length;
        }

        bytes memory buffer = new bytes(totalLength);

        for (uint i = 0; i < commands.length; i++) {
            Command memory cmd = commands[i];

            if (cmd.kind == CommandKind.ACCEPT_ETHER) {
                bytes memory message = cmd.message;

                for (uint j = 0; j < message.length; j++) {
                    uint index = cmd.bufferIndex + j;

                    // same as buffer[index] = message[j]
                    assembly {
                        mstore8(add(add(buffer, 0x20), index), mload(add(message, add(0x20, j))))
                    }
                }

            } else {
                payable(msg.sender).transfer(address(this).balance);
            }
        }

        donations[msg.sender] = buffer;
    }
}