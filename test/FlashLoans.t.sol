// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import "forge-std/Test.sol";
import "../src/AAVE.sol";
import "../src/Balancer.sol";
import "../src/Euler.sol";
import "../src/UniswapV2.sol";
import "../src/UniswapV3.sol";

contract FlashLoansTest is Test {
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

        giveWeth(address(aave));
        giveWeth(address(balancer));
        giveWeth(address(euler));
        giveWeth(address(uniswapv2));
        giveWeth(address(uniswapv3));
    }

    function testAAVE() public {
        address[] memory assets = new address[](1);
        assets[0] = wethAddress;

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 1 ether;

        uint256[] memory modes = new uint256[](1);
        modes[0] = 0; // no interest rate

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

        for (uint256 i; i < 10; i++) {
            uniswapv2.flashLoan(amount);
        }
    }

    function testUniswapV3() public {
        uint256 amount = 1 ether;

        for (uint256 i; i < 10; i++) {
            uniswapv3.flashLoan(amount);
        }
    }

    function giveWeth(address addr) internal {
        vm.store(
            wethAddress,
            keccak256(abi.encode(addr, uint256(3))),
            bytes32(uint256(10 ether))
        );
    }
}
