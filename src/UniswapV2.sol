// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "./interfaces.sol";

interface IUniswapPair {
    function swap(
        uint256,
        uint256,
        address,
        bytes calldata
    ) external;
}

contract UniswapV2 {
    address immutable owner;

    // WETH-USDC
    address constant pairAddress = 0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc;
    address constant wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    IUniswapPair constant pair = IUniswapPair(pairAddress);
    IERC20 constant weth = IERC20(wethAddress);

    constructor() {
        owner = msg.sender;
    }

    function go(uint256 amount) public {
        if (msg.sender != owner) revert();

        // WETH is token1
        pair.swap(0, amount, address(this), "0x00");
    }

    function uniswapV2Call(
        address sender,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data
    ) public {
        if (msg.sender != pairAddress) revert();
        if (sender != address(this)) revert();

        weth.transfer(msg.sender, (amount1 * 1000) / 997 + 1);
    }
}
