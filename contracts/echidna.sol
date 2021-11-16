pragma solidity >=0.4.20 <0.8.0;

import "./states.sol";

contract TEST is States {
  function echidna_state4() public returns (bool) {
    return (!state4);
  }

  function echidna_state3() public returns (bool) {
    return (!state3);
  }

  function echidna_state2() public returns (bool) {
    return (!state2);
  }

  function echidna_state1() public returns (bool) {
    return (!state1);
  }
}
