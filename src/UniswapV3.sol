// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import {IERC20} from "./interfaces.sol";

interface IUniswapV3Pool {
    function flash(
        address recipient,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data
    ) external;
}

contract UniswapV3 {
    address immutable owner;

    // WETH-USDC
    address constant pairAddress = 0x8ad599c3A0ff1De082011EFDDc58f1908eb6e6D8;
    address constant wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    IUniswapV3Pool constant pair = IUniswapV3Pool(pairAddress);
    IERC20 constant weth = IERC20(wethAddress);

    constructor() {
        owner = msg.sender;
    }

    function flashLoan(uint256 amount) public {
        if (msg.sender != owner) revert();

        // WETH is token1
        pair.flash(address(this), 0, amount, abi.encodePacked(amount));
    }

    function uniswapV3FlashCallback(
        uint256, /* fee0 */
        uint256 fee1,
        bytes calldata data
    ) public {
        if (msg.sender != pairAddress) revert();

        uint256 amount = abi.decode(data, (uint256));

        weth.transfer(msg.sender, amount + fee1);
    }
}
