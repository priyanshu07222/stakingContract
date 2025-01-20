// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract OrcaCoin is ERC20, Ownable {
    address public stakingContract;

    constructor(address _stakingContract) ERC20("Orca", "ORC") Ownable(msg.sender) {
        stakingContract = _stakingContract;
    }

    function mint(address mintAdd, uint256 value) public {
        require(msg.sender == stakingContract);
        _mint(mintAdd, value);
    }

    function updateStakingContract(address _stakingContract) public onlyOwner {
        stakingContract = _stakingContract;
    }
}
