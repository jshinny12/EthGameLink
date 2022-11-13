// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

interface IGame {
    // Events specific for game
    event GameCreated();
    event GameBegun();
    event GameFinished();

    // functions for game
    function getTotalPlayers() external view returns (uint32);
    
    function isStartPending() external view returns (bool);
    function isOngoing() external view returns (bool);
    function isFinished() external view returns (bool);

    // player specific 
    function getWinner() external view returns (address account);
    function isPlayer(address account) external view returns (bool);
}
