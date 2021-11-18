// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    // Declare state variable
    uint256 totalWaves;

    // Set up an event to catch it at the frontend.
    event NewWave(address indexed from, uint256 timestamp, string message);

    // A struct is a custom datatype where we can customize what we want to hold inside it
    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }

    constructor() {
        console.log("Successfully deployed the smart contract built by TLC");
    }

    // Declare a variable waves that lets me store an array of structs.
    Wave[] waves;
  

    // From the frontend, user send 🢛 this message
    function wave(string memory _message) public {
      totalWaves += 1;
      console.log("%s has waved!", msg.sender); //msg.sender is the address of the person who called the function

        // push the new message to array for storing.
      waves.push(Wave(msg.sender, _message, block.timestamp));

        // emit this event (created above) to frontend 
      emit NewWave(msg.sender, block.timestamp, _message);
  }

    // This will return the struct array "wave" for frontend display

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
}