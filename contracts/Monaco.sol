// SPDX-License-Identifier:
pragma solidity ^0.8.0;

//import ownable
import "@openzeppelin/contracts/access/Ownable.sol";

//import monnaccogame
import "./Race.sol";


contract Monaco is Ownable {

    // event for game addition
    event RaceAdded(address indexed raceAddress, uint256 indexed raceId);
    //event for game removed
    event RaceRemoved(address indexed raceAddress, uint256 indexed raceId);
    //event for game
    event RaceUpdated(address indexed raceAddress, uint256 indexed raceId);

    //mapping of game id -> game 
    mapping(uint256 => Race) races;
    // total number of games 
    uint256 totalRaces;

    modifier raceExists(uint256 raceId) {
        require(
            races[raceId].raceAddress != address(0),
            "Game does not exist"
        );
        _;
    }

    //modifier race does not exist ()
    modifier raceDoesNotExist(uint256 raceId) {
        require(
            races[raceId].raceAddress == address(0),
            "Game does not exist"
        );
        _;
    }

    //modifier game has started
    modifier raceOngoing(uint256 raceId) {
        require(
            races[raceId].hasOngoing(),
            "Game has not started yet"
        );
        _;
    }

    //modifier game has started
    modifier raceHasNotStarted(uint256 raceId) {
        require(
            races[raceId].hasNotStart(),
            "Game has not started yet"
        );
        _;
    }

    modifier raceHasEnded(uint256 raceId) {
        require(
            races[raceId].hasFinished(),
            "Game has not started yet"
        );
        _;
    }

    //function for removing games
    function removeRace(uint256 raceId) external onlyOwner gameExists(gameId) {
        //delete game
        delete races[raceId];
        //decrement total games
        totalRaces--;
        //emit event
        emit RaceRemoved(raceAddress, raceId);
    }

    // function for adding games to the game list
    function addRace(
        string memory _raceId,
        address addr1,
        string memory name1,
        address addr2,
        string memory name2,
        address addr3,
        string memory name3,
        uint initCoins
    ) external onlyOwner raceDoesNotExist(_raceId) {
        //create new game
        Race newRace = new Race(
            _raceId,
            addr1,
            name1,
            addr2,
            name2,
            addr3,
            name3,
            initCoins
        );
        //add game to mapping
        races[_raceId] = newRace;
        //increment total games
        totalRaces++;
        //emit event
        emit RaceAdded(raceAddress, _raceId);
    }

    // function for updating game
    function updateRacePlayer(uint256 raceId, uint256 playerAddress, uint256 coins, uint256 distance) public onlyOwner raceExists(raceId) {
        Race memory updatingRace = races[raceId];
        Race.updatePlayer(playerAddress, coins, distance);
    }

}