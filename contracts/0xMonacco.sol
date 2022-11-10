// SPDX-License-Identifier:
pragma solidity ^0.8.0;

//import ownable
import "@openzeppelin/contracts/access/Ownable.sol";
// import counter
import "@openzeppelin/contracts/utils/Counters.sol";

contract 0xMonacco is Ownable {
    
    using Counters for Counters.Counter;
    Counters.Counter private _gameIds;

    // event for game addition
    event GameAdded(address indexed gameAddress, uint256 indexed gameId);
    //event for game removed
    event GameRemoved(address indexed gameAddress, uint256 indexed gameId);
    //event for game
    event GameUpdated(address indexed gameAddress, uint256 indexed gameId);

    // struct for game

    struct Game {
        address gameAddress;
        bool hasStarted;
        bool hasEnded;
        address[] players;
        address winner;
        uint256 totalAmount;
    }

    modifier gameExists(uint256 gameId) {
        require(
            games[gameId].gameAddress != address(0),
            "Game does not exist"
        );
        _;
    }

    //modifier game does not exist
    modifier gameDoesNotExist(uint256 gameId) {
        require(
            games[gameId].gameAddress == address(0),
            "Game already exists"
        );
        _;
    }

    //modifier game has started
    modifier gameHasStarted(uint256 gameId) {
        require(
            games[gameId].hasStarted == true,
            "Game has not started yet"
        );
        _;
    }

    //modifier game has not started yet
    modifier gameHasNotStarted(uint256 gameId) {
        require(
            games[gameId].hasStarted == false,
            "Game has already started"
        );
        _;
    }

    //modifier game has ended
    modifier gameHasEnded(uint256 gameId) {
        require(
            games[gameId].hasEnded == true,
            "Game has not ended yet"
        );
        _;
    }

    //modifier game has not ended yet
    modifier gameHasNotEnded(uint256 gameId) {
        require(
            games[gameId].hasEnded == false,
            "Game has already ended"
        );
        _;
    }

    //mapping of game id -> game 
    mapping(uint256 => Game) games;
    // total number of games 
    uint256 totalGames;

    //function for adding games
    function addGame(address gameAddress) external onlyOwner gameDoesNotExist(_gameIds.current(), gameAddress, 
    player1, player2, player3, totalAmount) {
        //increment game id
        _gameIds.increment();
        //get current game id
        uint256 gameId = _gameIds.current();
        // create an array of three players 
        address[] memory players = new address[](3);
        //add players in the params to the array
        players[0] = player1;
        players[1] = player2;
        players[2] = player3;
        games[gameId] = Game(gameAddress, false, false, players, null, totalAmount);
        //increment total games
        totalGames++;
        //emit event
        emit GameAdded(gameAddress, gameId);
    }

    //function for removing games
    function removeGame(uint256 gameId) external onlyOwner gameExists(gameId) {
        //delete game
        delete games[gameId];
        //decrement total games
        totalGames--;
        //emit event
        emit GameRemoved(gameAddress, gameId);
    }

    function setWinner(uint256 gameId, address player) onlyOwner {
        racecontract.setwinnera.()
    }




}