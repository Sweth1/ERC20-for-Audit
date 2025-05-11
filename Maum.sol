// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyToken {
    
    // Token parameters - Modify these to your own token's values
    string public name = "Your Token Name"; // CHANGE to your token name
    string public symbol = "SYM"; // CHANGE to your token symbol
    uint8 public decimals = 18; // CHANGE if you want a different number of decimals
    uint256 public totalSupply = 1000000 * 10 ** uint256(decimals); // CHANGE total supply, e.g., 1 million tokens
    address public owner;
    
    // Mapping for balances and allowances
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Burn(address indexed account, uint256 amount);

    // Modifier to restrict access to the contract's owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }
    
    // Constructor: set initial supply and assign to the deployer's address
    constructor() {
        owner = msg.sender;  // The deployer is the owner
        balanceOf[msg.sender] = totalSupply;  // Give all tokens to the owner
    }

    // Transfer Function (standard ERC-20)
    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(recipient != address(0), "Cannot transfer to the zero address");
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");

        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    // transferFrom Function (allowance mechanism)
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        require(sender != address(0), "From address is zero address");
        require(recipient != address(0), "To address is zero address");
        require(balanceOf[sender] >= amount, "Insufficient balance");
        require(allowance[sender][msg.sender] >= amount, "Allowance exceeded");

        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        allowance[sender][msg.sender] -= amount;

        emit Transfer(sender, recipient, amount);
        return true;
    }

    // Approve Function (allowance mechanism)


    // Ownership control functions
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is the zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    // Burn Function (optional)
    function burn(uint256 amount) public onlyOwner {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance to burn");

        totalSupply -= amount;
        balanceOf[msg.sender] -= amount;
        emit Burn(msg.sender, amount);
    }

    // Minting Function (optional)
    function mint(address account, uint256 amount) public onlyOwner {
        require(account != address(0), "Cannot mint to the zero address");

        totalSupply += amount;
        balanceOf[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    // Pausing functionality (can be extended)
    bool public paused = false;

    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    function pause() public onlyOwner {
        paused = true;
    }

    function unpause() public onlyOwner {
        paused = false;
    }

    // Transfer function with pausing functionality
    function transferWithPause(address recipient, uint256 amount) public whenNotPaused returns (bool) {
        return transfer(recipient, amount);
    }

    function transferFromWithPause(address sender, address recipient, uint256 amount) public whenNotPaused returns (bool) {
        return transferFrom(sender, recipient, amount);
    }
}
