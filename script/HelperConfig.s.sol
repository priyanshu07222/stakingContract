// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    uint256 SEPOLIA_CHAIN_ID = 11155111;

    function run() external {
        vm.startBroadcast();
        vm.stopBroadcast();
    }

    function getSepoliaEth() public returns (address) {}
}
