// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract MoneyRepeller { 

    function getBalance() public view returns(uint) { 
    return address(this).balance; 
    } 
    
} 
