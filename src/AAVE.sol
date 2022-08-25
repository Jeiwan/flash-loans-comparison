// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import {IERC20} from "./interfaces.sol";

interface IAAVELendingPool {
    function flashLoan(
        address receiver,
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata modes,
        address onBehalfOf,
        bytes calldata params,
        uint16 referralCode
    ) external;
}

contract AAVE {
    address immutable owner;

    address constant lendingPoolAddress =
        0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9;

    IAAVELendingPool constant lendingPool =
        IAAVELendingPool(lendingPoolAddress);

    constructor() {
        owner = msg.sender;
    }

    function flashLoan(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata modes
    ) public {
        if (msg.sender != owner) revert();

        lendingPool.flashLoan(
            address(this),
            assets,
            amounts,
            modes,
            address(this),
            "",
            0
        );
    }

    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata /* params */
    ) external returns (bool) {
        if (msg.sender != lendingPoolAddress) revert();
        if (initiator != address(this)) revert();

        IERC20(assets[0]).approve(lendingPoolAddress, amounts[0] + premiums[0]);
        return true;
    }
}
