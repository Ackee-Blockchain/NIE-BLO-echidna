pragma solidity >=0.4.20 <0.8.0;

import "./overflow.sol";

contract TEST is Overflow {
    function checkBalance() public {
        assert(actualBalance >= lastBalance);
    }
}
