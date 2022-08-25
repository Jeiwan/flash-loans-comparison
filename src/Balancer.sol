// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import {IERC20} from "./interfaces.sol";

interface IBalancer {
    function flashLoan(
        address recipient,
        address[] memory tokens,
        uint256[] memory amounts,
        bytes memory userData
    ) external;
}

contract Balancer {
    address immutable owner;

    address constant balancerAddress =
        0xBA12222222228d8Ba445958a75a0704d566BF2C8;

    IBalancer constant balancer = IBalancer(balancerAddress);

    constructor() {
        owner = msg.sender;
    }

    function flashLoan(address[] calldata tokens, uint256[] calldata amounts)
        public
    {
        if (msg.sender != owner) revert();

        balancer.flashLoan(address(this), tokens, amounts, "");
    }

    function receiveFlashLoan(
        IERC20[] calldata tokens,
        uint256[] calldata amounts,
        uint256[] calldata feeAmounts,
        bytes calldata userData
    ) public payable {
        if (msg.sender != balancerAddress) revert();

        tokens[0].transfer(balancerAddress, amounts[0]);
    }
}
