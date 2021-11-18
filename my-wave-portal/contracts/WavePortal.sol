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


    /* ⇩ send 0.0001 ETH to people waving at me  ⇩ */
    uint256 prizeAmount = 0.0001 ether;
    require(
        prizeAmount <= address(this).balance, //⇐ the balance of the contract itself.
        "Trying to withdraw more money than the contract has."
    );
    (bool success, ) = (msg.sender).call{value: prizeAmount}("");// this is where money got sent
    
    // If Txn NOT success,  send below message 🢛
    require(success, "Failed to withdraw money from contract.");
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