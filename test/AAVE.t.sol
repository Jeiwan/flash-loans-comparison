// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "ds-test/test.sol";
import "../src/AAVE.sol";

interface Vm {
    function store(
        address,
        bytes32,
        bytes32
    ) external;
}

contract ContractTest is DSTest {
    Vm vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    AAVE aave;

    address constant wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    function setUp() public {
        aave = new AAVE();
    }

    function testFlashLoan() public {
        address[] memory assets = new address[](1);
        assets[0] = wethAddress;

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 1 ether;

        uint256[] memory modes = new uint256[](1);
        modes[0] = 0; // no interest rate

        // Premium 0.9%
        vm.store(
            wethAddress,
            keccak256(abi.encode(address(aave), uint256(3))),
            bytes32(uint256(0.009 ether))
        );

        for (uint256 i; i < 10; i++) {
            aave.go(assets, amounts, modes);
        }
    }
}
