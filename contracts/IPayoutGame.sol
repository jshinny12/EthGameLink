// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/access/Ownable.sol";
// import "./IGame.sol";

// /**
//  * 
//  * @dev Interface of a Game standard that allows for payout functionalities
//  * 
//  * Note: Implement the players using ID and keep a data structure 
//  * that maps ID to the player
//  * 
//  * Implementation: Reccomend using Ownable to set owner of the game
//  * 
//  */

// interface IPayoutGame is IGame {

//     /**
//      * 
//      * @dev Emitted when a player withdraws from the game
//      * 
//      * @param playerAddr The address of the player and their playerID
//      * 
//      */

//     event PlayerWithdraw(uint256 indexed id, address indexed addr);

//     /**
//      * 
//      * @dev Emitted when the Owner withdraws from the game
//      * 
//      * @param playerAddr The address of the Owner
//      * 
//      */

//     event OwnerWithdraw(address indexed addr);

//     /**
//      * 
//      * @dev Return the address of the game's owner
//      * 
//      */

//     function getGameOwner() external view returns (address);

//     /**
//      * 
//      * @dev Return the total amount of withdrawble balance
//      * 
//      */

//     function getWithdrawBalance() external view returns (uint256);

//     /**
//      * 
//      * @dev Allows a player to withdraw their winnings from the contract
//      * 
//      * Return boolean that indicates whether the player has withdrawn
//      * 
//      * {EMITS} - PlayerWithdraw
//      * 
//      */

//     function withdraw() external returns (bool);

//     /**
//      * 
//      * @dev Allows the owner to withdraw their winnings from the contract
//      * 
//      * Return boolean that indicates whether the owner has withdrawn
//      * 
//      * {EMITS} - OwnerWithdraw
//      * 
//      * Note: This function is a specific withdraw for the owner. 
//      * Implmeentation should enforce so that owner can 
//      * withdraw in any given edge cases and they can override it if need be.
//      */
     
//     function ownerWithdraw() external returns (bool);
    
// }