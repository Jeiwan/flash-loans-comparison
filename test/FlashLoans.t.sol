// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "ds-test/test.sol";
import "../src/AAVE.sol";
import "../src/Balancer.sol";
import "../src/Euler.sol";
import "../src/UniswapV2.sol";
import "../src/UniswapV3.sol";

interface Vm {
    function store(
        address,
        bytes32,
        bytes32
    ) external;
}

contract FlashLoansTest is DSTest {
    Vm vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    AAVE aave;
    Balancer balancer;
    Euler euler;
    UniswapV2 uniswapv2;
    UniswapV3 uniswapv3;

    address constant wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    function setUp() public {
        aave = new AAVE();
        balancer = new Balancer();
        euler = new Euler();
        uniswapv2 = new UniswapV2();
        uniswapv3 = new UniswapV3();
    }

    function testAAVE() public {
        address[] memory assets = new address[](1);
        assets[0] = wethAddress;

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 1 ether;

        uint256[] memory modes = new uint256[](1);
        modes[0] = 0; // no interest rate

        // Premium 0.09%
        uint256 premium = (1 ether * 9) / uint256(10000);

        vm.store(
            wethAddress,
            keccak256(abi.encode(address(aave), uint256(3))),
            bytes32(premium * 10)
        );

        for (uint256 i; i < 10; i++) {
            aave.flashLoan(assets, amounts, modes);
        }
    }

    function testBalancer() public {
        address[] memory assets = new address[](1);
        assets[0] = wethAddress;

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 1 ether;

        for (uint256 i; i < 10; i++) {
            balancer.flashLoan(assets, amounts);
        }
    }

    function testEulerFinance() public {
        for (uint256 i; i < 10; i++) {
            euler.flashLoan(1 ether);
        }
    }

    function testUniswapV2() public {
        uint256 amount = 1 ether;
        // Premium 0.3009027%
        uint256 premium = (amount * 1000) / uint256(997) + 1 - amount;

        vm.store(
            wethAddress,
            keccak256(abi.encode(address(uniswapv2), uint256(3))),
            bytes32(premium * 10)
        );

        for (uint256 i; i < 10; i++) {
            uniswapv2.flashLoan(amount);
        }
    }

    function testUniswapV3() public {
        uint256 amount = 1 ether;
        // Premium 0.3009027%
        uint256 premium = (amount * 1000) / uint256(997) + 1 - amount;

        vm.store(
            wethAddress,
            keccak256(abi.encode(address(uniswapv3), uint256(3))),
            bytes32(premium * 10)
        );

        for (uint256 i; i < 10; i++) {
            uniswapv3.flashLoan(amount);
        }
    }
}
