// SPDX-License-Identifier:
pragma solidity ^0.8.0;

//import ownable
import "@openzeppelin/contracts/access/Ownable.sol";

//import monnaccogame
import "./Race.sol";


contract MonacoResults is Ownable {

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
            address(races[raceId]) != address(0),
            "Race does not exist"
        );
        _;
    }

    //modifier race does not exist ()
    modifier raceDoesNotExist(uint256 raceId) {
        require(
            address(races[raceId]) == address(0),
            "Race already exists"
        );
        _;
    }

    //modifier game has started
    modifier raceOngoing(uint256 raceId) {
        require(
            races[raceId].isOngoing(),
            "Race must be ongoing"
        );
        _;
    }

    //modifier game has started
    modifier raceHasNotStarted(uint256 raceId) {
        require(
            races[raceId].isStartPending(),
            "Race has not started yet"
        );
        _;
    }

    modifier raceHasEnded(uint256 raceId) {
        require(
            races[raceId].isFinished(),
            "Race has already ended"
        );
        _;
    }

    //function for removing games
    function removeRace(uint256 _raceId) external onlyOwner raceExists(_raceId) {
        //delete game
        delete races[_raceId];
        //decrement total games
        totalRaces--;
        //emit event
        emit RaceRemoved(address(races[_raceId]), _raceId);
    }

    // function for adding games to the game list
    function addRace(
        uint256 _raceId,
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
        emit RaceAdded(address(races[_raceId]), _raceId);
    }

    // function for updating game
    function updateRacePlayer(uint256 raceId, address playerAddress, uint256 coins, uint256 distance) public onlyOwner raceExists(raceId) {
        Race updatingRace = races[raceId];
        updatingRace.updatePlayer(playerAddress, coins, distance);
    }

}