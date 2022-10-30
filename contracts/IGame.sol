// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

interface IGame {

    // structs
    struct Player {
        uint256 id;
        address addr;
        uint256 amount;
    }
    enum PlayState { STARTPENDING, ACTIVE, PAUSED, FINISHED }

    // Events specific for game
    event GameCreated(uint256 fee, bool status);
    event GameStarted(uint256 fee, bool status);
    event GameFinished(uint256 fee, bool status);
    event GamePaused(uint256 fee, bool status);
    event GameUnpaused(uint256 fee, bool status);

    // Events for players
    event PlayerJoined(uint256 indexed id, address indexed addr);
    event PlayerLeft(uint256 indexed id, address indexed addr);

    // functions for game
    function startGame() external returns (bool);
    function getPlayState() external returns (PlayState);
    function getTotalPlayers() external view returns (uint256);
    function getWinners() external view returns (address[] memory);

    // player specific 
    function getPlayerId(address addr) external view returns (uint256);
    function getPlayer(uint256 id) external view returns (Player memory);

    // specific functions for players
    function joinGame() external payable returns (bool);
    function leaveGame() external returns (bool);
}



// would have a mapping of address -> players

    // example modifiers for when we implement games: 

    // modifier for onlyOwner
    // modifier onlyOwner() {
    //     require(msg.sender == owner, "Only owner can call this function.");
    //     _;
    // }

    // modifier for game started 
    // modifier gameStarted() {
    //     require(gameStarted, "Game has not started yet.");
    //     _;
    // }

    // modifier for game ended
    // modifier gameEnded() {
    //     require(gameEnded, "Game has not ended yet.");
    //     _;
    // }

    // modifier for is player
    // modifier isPlayer() {
    //     require(players[msg.sender].addr != address(0), "You are not a player.");
    //     _;
    // }

    // modifier for is not player
    // modifier isNotPlayer() {
    //     require(players[msg.sender].addr == address(0), "You are already a player.");
    //     _;
    // }




