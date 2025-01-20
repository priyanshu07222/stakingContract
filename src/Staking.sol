// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {console} from "forge-std/console.sol";

interface IOrcaCoin {
    function mint(address to, uint256 amount) external;
}

contract Staking {
    mapping(address => uint256) public tokenStaked;
    mapping(address => uint256) public unclaimedRewards;
    mapping(address => uint256) public lastUpdateTime;

    IOrcaCoin public orcaTokenAddress;

    uint256 public constant REWARD_PER_SEC_PER_ETH = 1;

    event StakedAmount(address indexed, uint256);

    constructor(IOrcaCoin _tokenAddress) {
        orcaTokenAddress = _tokenAddress;
    }

    function _updateUnclaimedRewards() internal {
        uint256 currentTimestamp = block.timestamp;
        unclaimedRewards[msg.sender] +=
            ((currentTimestamp - lastUpdateTime[msg.sender]) * tokenStaked[msg.sender] * REWARD_PER_SEC_PER_ETH);
        lastUpdateTime[msg.sender] = currentTimestamp;
    }

    function stake(uint256 _amount) public payable {
        require(msg.value > 0);
        require(_amount == msg.value);
        if (lastUpdateTime[msg.sender] == 0) {
            lastUpdateTime[msg.sender] = block.timestamp;
            tokenStaked[msg.sender] += _amount;
        } else {
            _updateUnclaimedRewards();
            tokenStaked[msg.sender] += _amount;
        }
    }

    function unstake(uint256 _amount) public {
        require(tokenStaked[msg.sender] >= _amount);
        _updateUnclaimedRewards();
        payable(msg.sender).transfer(_amount);
        tokenStaked[msg.sender] -= _amount;
    }

    function claimRewards() public {
        _updateUnclaimedRewards();
        orcaTokenAddress.mint(msg.sender, unclaimedRewards[msg.sender]);
        unclaimedRewards[msg.sender] = 0;
        lastUpdateTime[msg.sender] = block.timestamp;
    }

    function getRewards() public view returns (uint256) {
        uint256 timeDiff = block.timestamp - lastUpdateTime[msg.sender];
        return (unclaimedRewards[msg.sender] + ((timeDiff) * REWARD_PER_SEC_PER_ETH * tokenStaked[msg.sender]));
    }

    function getTokenStaked() public view returns (uint256) {
        return tokenStaked[msg.sender];
    }
}
