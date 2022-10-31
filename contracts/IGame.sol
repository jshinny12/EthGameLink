// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

interface IGame {

    // Events specific for game
    event GameCreated();
    event GameStarted();
    event GameFinished();

    // Events for players
    event PlayerJoined(address indexed addr);
    //event PlayerLeft(address indexed addr); not sure if this is critical

    // functions for game
    function getTotalPlaces external view returns (uint8);
    function getTotalPlayers() external view returns (uint32); // i think games wont have 2^256 ppl
        
    function startGame() external returns (bool);
    function endGame() external returns (bool);

    function getPlayerAtPlace(uint8 place) external view returns (address account);
    function getPlaceAtPlayer(address account) external view returns (uint8 place);
    
    // function getWinners() external view returns (address[] memory); // i think this would me expensive to get an array
    

    // specific functions for players
    function joinGame() external returns (bool); 
    // function leaveGame() external returns (bool); not sure if this is critical
    
    // specific functions for creator
    function setWinner(uint8 place, address player) external returns (bool);
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




