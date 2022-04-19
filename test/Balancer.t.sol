// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "ds-test/test.sol";
import "../src/Balancer.sol";

contract BalancerTest is DSTest {
    Balancer balancer;

    address constant wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    function setUp() public {
        balancer = new Balancer();
    }

    function testFlashLoan() public {
        address[] memory assets = new address[](1);
        assets[0] = wethAddress;

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 1 ether;

        for (uint256 i; i < 10; i++) {
            balancer.go(assets, amounts);
        }
    }
}
