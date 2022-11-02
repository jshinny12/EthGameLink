// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

interface IGame {
    // Events specific for game
    event GameCreated(bool status);
    event GameStarted(bool status);
    event GameFinished(bool status);

    // Events for players
    event PlayerJoined(address indexed addr);

    // functions for game
    function startGame() external returns (bool);
    function getTotalPlaces() external view returns (uint32);
    function getTotalPlayers() external view returns (uint32);
    function hasStart() external view returns (bool);
    function hasFinished() external view returns (bool);

    // player specific 
    function getPlayerAtPlace(uint32 place) external view returns (address account);
    function getPlaceAtPlayer(address account) external view returns (uint32 place);
    function isPlayer(address account) external view returns (bool);

    // specific functions for players
    function joinGame() external payable returns (bool);
}
