// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Grade {
    mapping (string => uint) public grades;
    mapping (string => address) public addresses;

    function setGrade(string memory softtechId, uint grade) public payable { 
        require(msg.value == 0.001 ether);
        grades[softtechId] = grade;
        addresses[softtechId] = msg.sender;
    }
}
