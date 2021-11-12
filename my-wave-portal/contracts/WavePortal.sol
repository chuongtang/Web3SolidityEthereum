// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    // Declare state variable
    uint256 totalWaves;

    constructor() {
        console.log("Successfully deployed the smart contract built by TLC");
    }
  
    function wave() public {
      totalWaves += 1;
      console.log("%s has waved!", msg.sender); //msg.sender is the address of the person who called the function
  }
    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
}