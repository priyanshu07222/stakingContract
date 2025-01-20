// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {Test} from "forge-std/Test.sol";
import {OrcaCoin} from "src/OrcaCoin.sol";
import {Staking, IOrcaCoin} from "src/Staking.sol";

contract StakingContractTest is Test {
    OrcaCoin orcaCoin;
    Staking staking;

    function setUp() public {
        orcaCoin = new OrcaCoin(address(this));
        staking = new Staking(IOrcaCoin(address(orcaCoin)));
        orcaCoin.updateStakingContract(address(staking));
        vm.deal(address(this), 10 ether);
    }

    function testFailStake() public {
        staking.stake{value: 0 ether}(0);
    }

    function testFailStakeIfValueAndAmountDiffer() public {
        staking.stake{value: 1 ether}(2e18);
    }

    function testStake() public {
        staking.stake{value: 1 ether}(1e18);
        assertEq(staking.getTokenStaked(), 1e18);
    }

    function testUnStake() public {
        staking.stake{value: 5 ether}(5e18);
        assertEq(staking.getTokenStaked(), 5 ether);

        staking.unstake(2 ether);
        assertEq(staking.getTokenStaked(), 3 ether);
    }

    function testClaimReward() public {
        staking.stake{value: 5 ether}(5e18);

        vm.warp(block.timestamp + 7);
        assertEq(staking.getRewards(), 35e18);

        staking.claimRewards();
        assertEq(staking.getRewards(), 0);
    }

    function testGetRewards() public {
        staking.stake{value: 5 ether}(5e18);

        vm.warp(block.timestamp + 7);
        assertEq(staking.getRewards(), 35e18);

        staking.stake{value: 2 ether}(2e18);

        vm.warp(block.timestamp + 3);
        assertEq(staking.getRewards(), 56e18);
    }

    fallback() external payable {}

    receive() external payable {}
}
