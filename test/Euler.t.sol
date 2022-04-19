// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "ds-test/test.sol";
import "../src/Euler.sol";

contract EulerTest is DSTest {
    Euler euler;

    address constant wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    function setUp() public {
        euler = new Euler();
    }

    function testFlashLoan() public {
        for (uint256 i; i < 10; i++) {
            euler.go(1 ether);
        }
    }
}
