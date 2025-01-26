// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {Script} from "forge-std/Script.sol";
import {Staking} from "src/Staking.sol";
import {IOrcaCoin} from "src/Staking.sol";

contract DeployStaking is Script {
    address OrcaCoinAddress = 0x2985F4f4C7667978f0B63ff5691c49B4409e9278;

    function run() external {
        vm.startBroadcast();
        new Staking(IOrcaCoin(OrcaCoinAddress));
        vm.stopBroadcast();
    }
}
