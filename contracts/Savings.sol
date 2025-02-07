// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
import { IERC20 } from "./ERC20.sol";

contract Savings {
    IERC20 public erc20;
    mapping(address => uint256) public unlockDate;

    constructor (address _erc20) {
        erc20 = IERC20(_erc20);
    }

    function deposit(uint256 amount) external {
        unlockDate[msg.sender] = block.timestamp + 2 minutes;
        erc20.transfer(address(this), amount);
        erc20.approve(msg.sender, amount);
    }

    function withdraw(uint256 amount) external {
        require(block.timestamp >= unlockDate[msg.sender], "You can't withdraw yet");
        erc20.transferFrom(address(this), msg.sender, amount);
        unlockDate[msg.sender] = 0;
    }
}