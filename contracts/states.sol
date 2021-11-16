pragma solidity >=0.4.20 <0.8.0;

contract States {
  bool state1 = false;
  bool state2 = false;
  bool state3 = false;
  bool state4 = false;

  function f(uint x) public {
    require(x == 6);
    state1 = true;
  }

  function g(uint x) public {
    require(state1);
    require(x == 66);
    state2 = true;
  }

  function h(uint x) public {
    require(state2);
    require(x == 666);
    state3 = true;
  }

  function i() public {
    require(state3);
    state4 = true;
  }

  function reset() public {
    state1 = false;
    state2 = false;
    state3 = false;
    return;
  }
}
