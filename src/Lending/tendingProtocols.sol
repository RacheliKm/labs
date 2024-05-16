// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20; 
import "@hack/Lending/mathematics.sol";
import "@openzeppelin/ERC20/ERC20.sol";
contract LendingProtocol is ERC20 ,mathematics {

     address owner;
     mapping (address => uint) public lenders;
     ERC20 DAI;
     ERC20 bond;
     uint maxLTV = 80;
     uint collateralValue = 0;

    constructor(address tokenAddress) ERC20("bond", "BND"){
        DAI = ERC20(tokenAddress);
    }

    modifier validAmount(uint amount) {
     require(amount > 0, "unvalid amount");
     _;
    }
    function lendingDAI(uint amount) public validAmount(amount) {
        DAI.transferFrom(msg.sender, address(this), amount);
        lenders[msg.sender] = amount;
        collateralValue += amount;
        //calculate the amounts of bonds he reserve
        _mint(msg.sender, amount);
        
    
    }

    function receiveLendingDAI(uint amount) external validAmount(amount) {
       require(lenders[msg.sender] >= amount, "you did not lend enough DAI");
       require(bond.balanceOf(msg.sender) >= amount, "you do not have enough bond tokens");
       _burn(msg.sender, amount);
       DAI.transfer(msg.sender, amount);
       lenders[msg.sender] -= amount;
    
    }
    function borrow(uint borrowedValue) external validAmount(borrowedValue) payable{
        
        require(msg.sender.balance >= msg.value, "you do not have enugh ETH for the colletral");

        uint borrowLimit = percentage((collateralValue - borrowedValue), maxLTV);
        require(borrowedValue<= borrowLimit, "you have a limited borrow ");
        
    }

     
}