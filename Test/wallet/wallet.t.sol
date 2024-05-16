// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/wallet.sol";


contract WalletTest is Test {
    Wallet public w;

    // Everything I need to start my test
    function setUp() public {
        w = new Wallet();
    }

    function testDeposit() public {
        w.deposit(100);
    }

    function testWithdraw() public {
    w.withdraw(50);
    console.log(address(this).balance);
        
    }

    function testInsert () public{
    vm.startPrank();
    }
    
}