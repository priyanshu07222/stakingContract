// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {Script} from "forge-std/Script.sol";
import {OrcaCoin} from "src/OrcaCoin.sol";

contract DeployOrca is Script {
    function run() external {
        vm.startBroadcast();
        new OrcaCoin(address(this));
        vm.stopBroadcast();
    }
}
