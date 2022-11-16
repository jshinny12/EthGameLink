// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

/**
 * @dev Interface of a Game standard 
 * 
 * Note: The interface is made for composability
 * meaning that it should be possible to implment a wide range
 * of game contracts, with different rules and logic
 * 
 */

interface IGame {

    /**
     * 
     * @dev Emitted when a game is generated
     * 
     */

    event GameCreated();

    /**
     * 
     * @dev Emitted when a game is started
     * 
     */
    event GameBegun();

    /**
     * 
     * @dev Emitted when a game is ended
     * 
     */
    event GameFinished();

    /**
     * 
     * @dev Return the total number of players in the game
     * 
     */
    function getTotalPlayers() external view returns (uint32);
    
    /**
     * 
     * @dev Returns a boolean that dictates if the game hasn't started yet
     * 
     */
    function isPregame() external view returns (bool);

    /**
     * 
     * @dev Returns a boolean that dictates if the game is currently ongoing
     * 
     */
    function isOngoing() external view returns (bool);

    /**
     * 
     * @dev Returns a boolean that dictates if the game has ended
     * 
     */
    function isFinished() external view returns (bool);

   
    /**
     * 
     * @dev Returns the address of the current winner
     * 
     * 
     */
    function getWinner() external view returns (address account);

    /**
     * 
     * @dev Returns a boolean that dictates if the account is a player in the game
     * 
     * @param account The address of the account to check
     */
    function isPlayer(address account) external view returns (bool);
}
