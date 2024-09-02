// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/TokenBank.sol";

contract TankBankTest is Test {
    TokenBankChallenge public tokenBankChallenge;
    TokenBankAttacker public tokenBankAttacker;
    address player = address(1234);

    function setUp() public {}

    function testExploit() public {
        tokenBankChallenge = new TokenBankChallenge(player);
        tokenBankAttacker = new TokenBankAttacker(address(tokenBankChallenge));

        vm.startPrank(player); // transfer tokens from player to tokenBankAttacker
        tokenBankChallenge.withdraw(tokenBankChallenge.balanceOf(player));
        tokenBankChallenge.token().transfer(address(tokenBankAttacker), tokenBankChallenge.token().balanceOf(player));
        vm.stopPrank();

        // Deposit tokens to the bank
        tokenBankAttacker.deposit();

        tokenBankAttacker.exploit();

        // Put your solution here

        _checkSolved();
    }

    function _checkSolved() internal {
        assertTrue(tokenBankChallenge.isComplete(), "Challenge Incomplete");
    }
}
