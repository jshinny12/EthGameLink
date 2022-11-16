// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

/**
 * 
 * @dev Interface of a Game Metadata standard
 * 
 */

interface IGameMetaData {
    
/** 
 * 
 * @dev Returns the name of the game
 *
 * Note: Game owners are able to add
 * more metadata to the contract if they wish to 
 * store more information regarding the game.
 * 
 */

    function getGameName() external view returns (string memory);
}