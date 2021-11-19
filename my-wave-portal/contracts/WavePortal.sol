// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    // Declare state variable
    uint256 totalWaves;

    uint256 private seed; // use this to help generate a random number

    // Set up an event to catch it at the frontend.
    event NewWave(address indexed from, uint256 timestamp, string message);

    // A struct is a custom datatype where we can customize what we want to hold inside it
    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }

    // Declare a variable waves that lets me store an array of structs.
    Wave[] waves;

     /*
     * This is an address => uint mapping, meaning I can associate an address with a number!
     * In this case, I'll be storing the address with the last time the user waved at us.
     */
    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("Successfully deployed the PAYABLE smart contract built by TLC");
        
        //Set initial seed. "Block" 🢛 is given by SOlidity. Combined them for a random #
        seed = (block.timestamp + block.difficulty) % 100;
        console.log("First seed generated #:", seed);
        /* timestamp: Unix timestamp that the block is being processed.
           difficulty: how hard the block will be mined  .
           % 100: number is brought down to a range between 0 - 100  
        */
    }
        
    // From the frontend, user send 🢛 this message
    function wave(string memory _message) public {

        /* Require current timestamp >=15-minutes last timestamp*/
        require(
            lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
            "Please wait 30 seconds to send another message"
        );

        /* Update the current timestamp we have for the user*/
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s has waved!", msg.sender); //msg.sender is the address of the person who called the function
        console.log("%s is the message", _message);
        // push the new message to array for storing.
        waves.push(Wave(msg.sender, _message, block.timestamp));

        // Generate a new seed for the next user that sends a wave
        seed = (block.difficulty + block.timestamp + seed) % 100;

        // Give a 50% chance that the user wins the prize.
        if (seed <= 50) {
            console.log("%s won!", msg.sender);
            console.log("Random # genereated: ", seed);

            /* ⇩ send 0.0001 ETH to people waving at me  ⇩ */
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,//⇐ the balance of the contract itself.
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");// this is where money got sent
            
            // If Txn NOT success,  send below message 🢛
            require(success, "Failed to withdraw money from contract.");
        }

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