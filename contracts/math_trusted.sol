pragma solidity >=0.4.20 <0.8.0;

contract MathTrusted {
  /*
   * By @Saurfang (https://ethereum.stackexchange.com/questions/8086/logarithm-math-operation-in-solidity)
   * 
   * Claimed as a "trusted" only for educational purposes
   */
  function log2Trusted(uint _x) public returns(uint) {
    require(_x > 0);

    uint x = _x;
    uint y = (((x & (x - 1)) == 0) ? 0 : 1);
    uint j = 128;
    uint k = 0;

    k = (((x & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000) == 0) ? 0 : j);
    y += k;
    x >>= k;
    j >>= 1;

    k = (((x & 0xFFFFFFFFFFFFFFFF0000000000000000) == 0) ? 0 : j);
    y += k;
    x >>= k;
    j >>= 1;

    k = (((x & 0xFFFFFFFF00000000) == 0) ? 0 : j);
    y += k;
    x >>= k;
    j >>= 1;

    k = (((x & 0x00000000FFFF0000) == 0) ? 0 : j);
    y += k;
    x >>= k;
    j >>= 1;

    k = (((x & 0x000000000000FF00) == 0) ? 0 : j);
    y += k;
    x >>= k;
    j >>= 1;

    k = (((x & 0x00000000000000F0) == 0) ? 0 : j);
    y += k;
    x >>= k;
    j >>= 1;

    k = (((x & 0x000000000000000C) == 0) ? 0 : j);
    y += k;
    x >>= k;
    j >>= 1;

    k = (((x & 0x0000000000000002) == 0) ? 0 : j);
    y += k;
    x >>= k;
    j >>= 1;

    return y;
  }
}
