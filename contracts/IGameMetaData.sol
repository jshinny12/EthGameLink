// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

interface IGameMetaData {

    //struct Game {
   //     string gameName;
   //     string[] gameTags;
   // }

    // returns the name of the game, ex matchbox
    function getName() external view returns (string memory);

    //// returns game tags, ex [multiplayer, P2E]
    //function getGameTags() external view returns (string[] memory);

    
}
