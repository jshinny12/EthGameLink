// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

interface IGame {
    // Events specific for game
    event GameCreated();
    event GameStarted();
    event GameFinished();

    // Events for players
    event PlayerJoined(address indexed addr);

    // functions for game
    function getTotalPlayers() external view returns (uint32);
    function hasStart() external view returns (bool);
    function hasFinished() external view returns (bool);

    // player specific 
    function getWinner() external view returns (address account);
    function isPlayer(address account) external view returns (bool);
    function joinGame() external payable returns (bool);
}
