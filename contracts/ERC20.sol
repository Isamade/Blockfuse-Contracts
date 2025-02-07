// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract ERC20 {
    mapping(address account => uint256) public balances;

    mapping(address account => mapping(address spender => uint256)) public allowances;

    uint256 public totalSupply;
    uint256 public decimals;

    string public name;
    string public symbol;

    address public owner;

    event Transfer(address indexed from, address indexed to, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "You aren't the owner");
        _;
    }

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        owner = msg.sender;
    }

    function transfer(address to, uint256 value) public {
        if (balances[msg.sender] < value) {
            revert("Transfer amount exceeds balance");
        }
        balances[msg.sender] -= value;
        balances[to] += value;
        emit Transfer(msg.sender, to, value);
    }

    function mint(address account, uint256 value) external onlyOwner {
        totalSupply += value;
        balances[account] += value;
    }

    function approve(address spender, uint256 value) public {
        allowances[msg.sender][spender] = value;
    }

    function transferFrom(address from, address to, uint256 value) public {
        if (balances[from] < value) {
            revert("Transfer amount exceeds balance");
        }
        if (allowances[from][msg.sender] < value) {
            revert("Transfer amount exceeds allowance");
        }
        balances[from] -= value;
        balances[to] += value;
        allowances[from][msg.sender] -= value;
        emit Transfer(from, to, value);
    }

    function increaseAllowance(address spender, uint256 addedValue) public {
        allowances[msg.sender][spender] += addedValue;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public {
        if (allowances[msg.sender][spender] < subtractedValue) {
            revert("Decreased allowance below zero");
        }
        allowances[msg.sender][spender] -= subtractedValue;
    }

    function burn(uint256 value) public onlyOwner {
        if (totalSupply < value) {
            revert("Burn amount exceeds supply");
        }
        else if (balances[msg.sender] < value) {
            revert("Burn amount exceeds balance");
        }
        balances[msg.sender] -= value;
        totalSupply -= value;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}