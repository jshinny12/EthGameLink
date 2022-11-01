// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

interface IGame {
    // Events specific for game
    event GameCreated(uint256 fee, bool status);
    event GameStarted(uint256 fee, bool status);
    event GameFinished(uint256 fee, bool status);

    // Events for players
    event PlayerJoined(uint256 indexed id, address indexed addr);

    // functions for game
    function startGame() external returns (bool);
    function getTotalPlaces() external view returns (uint32);
    function getTotalPlayers() external view returns (uint32);
    function hasStart() external view returns (bool);
    function hasFinished() external view returns (bool);

    // player specific 
    function getPlayerAtPlace(uint32 place) external view returns (address account);
    function getPlaceAtPlayer(address account) external view returns (uint32 place);

    // specific functions for players
    function joinGame() external payable returns (bool);
}
