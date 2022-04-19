// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IERC20 {
    function approve(address, uint256) external;
    function transfer(address, uint256) external returns (bool);
}
