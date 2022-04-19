// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "ds-test/test.sol";
import "../src/UniswapV3.sol";

interface Vm {
    function store(
        address,
        bytes32,
        bytes32
    ) external;
}

contract UniswapV3Test is DSTest {
    Vm vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    UniswapV3 uniswap;

    address constant wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    function setUp() public {
        uniswap = new UniswapV3();
    }

    function testFlashLoan() public {
        address[] memory assets = new address[](1);
        assets[0] = wethAddress;

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 1 ether;

        // Premium 0.003%
        uint256 premium = 1 ether - (997 / 1000) * 1 ether;

        for (uint256 i; i < 10; i++) {
            vm.store(
                wethAddress,
                keccak256(abi.encode(address(uniswap), uint256(3))),
                bytes32(premium)
            );

            uniswap.go(1 ether);
        }
    }
}
