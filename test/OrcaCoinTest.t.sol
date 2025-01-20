// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {Test} from "forge-std/Test.sol";
import {OrcaCoin} from "src/OrcaCoin.sol";

contract OrcaCoinTest is Test {
    OrcaCoin orcaCoin;
    // address stakingContract = 0x95222290DD7278Aa3Ddd389Cc1E1d165CC4BAfe5;

    function setUp() public {
        orcaCoin = new OrcaCoin(address(this));
    }

    function testStakingContractAddress() public view {
        assert(orcaCoin.stakingContract() == address(this));
    }

    function testIsTotalSupplyOfOrcaCoinZero() public view {
        assertEq(orcaCoin.totalSupply(), 0);
    }

    function testFailMint() public {
        vm.startPrank(0x95222290DD7278Aa3Ddd389Cc1E1d165CC4BAfe5);
        orcaCoin.mint(0x95222290DD7278Aa3Ddd389Cc1E1d165CC4BAfe5, 10 ether);
    }

    function testMint() public {
        orcaCoin.mint(0x95222290DD7278Aa3Ddd389Cc1E1d165CC4BAfe5, 10 ether);
        assertEq(orcaCoin.balanceOf(0x95222290DD7278Aa3Ddd389Cc1E1d165CC4BAfe5), 10 ether);
    }

    function testFailOnlyOwnerCanCallUpdateStakingContract(uint256 num) public {
        require(address(uint160(num)) != address(this));
        vm.startPrank(address(uint160(num)));
        orcaCoin.updateStakingContract(0x2bf916f8169Ed2a77324d3E168284FC252aE4087);
    }

    function testUpdateStakingContractAddress() public {
        vm.prank(address(this));
        orcaCoin.updateStakingContract(0x2bf916f8169Ed2a77324d3E168284FC252aE4087);
        vm.startPrank(0x2bf916f8169Ed2a77324d3E168284FC252aE4087);
        orcaCoin.mint(0x2bf916f8169Ed2a77324d3E168284FC252aE4087, 100 ether);
        assertEq(orcaCoin.balanceOf(0x2bf916f8169Ed2a77324d3E168284FC252aE4087), 100 ether);
    }
}
