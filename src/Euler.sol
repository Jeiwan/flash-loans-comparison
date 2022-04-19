// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "./interfaces.sol";

interface IEulerExec {
    function deferLiquidityCheck(address account, bytes memory data) external;
}

interface IEulerDToken {
    function borrow(uint256 subAccountId, uint256 amount) external;

    function repay(uint256 subAccountId, uint256 amount) external;
}

contract Euler {
    address immutable owner;

    address constant eulerAddress = 0x27182842E098f60e3D576794A5bFFb0777E025d3;
    address constant wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address constant execAddress = 0x59828FdF7ee634AaaD3f58B19fDBa3b03E2D9d80;
    // WETH DToken
    address constant dTokenAddress = 0x62e28f054efc24b26A794F5C1249B6349454352C;

    IEulerExec constant exec = IEulerExec(execAddress);
    IEulerDToken constant dToken = IEulerDToken(dTokenAddress);
    IERC20 constant weth = IERC20(wethAddress);

    constructor() {
        owner = msg.sender;
    }

    function flashLoan(uint256 amount) public {
        if (msg.sender != owner) revert();

        exec.deferLiquidityCheck(address(this), abi.encodePacked(amount));
    }

    function onDeferredLiquidityCheck(bytes calldata encodedData) public {
        if (msg.sender != eulerAddress) revert();

        uint256 amount = abi.decode(encodedData, (uint256));
        dToken.borrow(0, amount);

        weth.approve(eulerAddress, amount);
        dToken.repay(0, amount);
    }
}
