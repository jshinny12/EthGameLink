// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

//import ownable
import "@openzeppelin/contracts/access/Ownable.sol";

//import monnaccogame
import "./Race.sol";


contract MonacoResults is Ownable {

    // event for game addition
    event RaceAdded(address indexed raceAddress, string indexed raceId);
    //event for game removed
    event RaceRemoved(address indexed raceAddress, string indexed raceId);
    //event for game
    event RaceUpdated(address indexed raceAddress, string indexed raceId);

    //mapping of game id -> game 
    mapping(string => Race) races;
    // total number of games 
    uint256 totalRaces;

    modifier raceExists(string memory _raceId) {
        require(
            address(races[_raceId]) != address(0),
            "Race does not exist"
        );
        _;
    }

    //modifier race does not exist ()
    modifier raceDoesNotExist(string memory _raceId) {
        require(
            address(races[_raceId]) == address(0),
            "Race already exists"
        );
        _;
    }

    //modifier game has started
    modifier raceOngoing(string memory _raceId) {
        require(
            races[_raceId].isOngoing(),
            "Race must be ongoing"
        );
        _;
    }

    //modifier game has started
    modifier raceHasNotStarted(string memory _raceId) {
        require(
            races[_raceId].isPregame(),
            "Race has not started yet"
        );
        _;
    }

    modifier raceHasEnded(string memory _raceId) {
        require(
            races[_raceId].isFinished(),
            "Race has already ended"
        );
        _;
    }

    //function for removing games
    function removeRace(string memory _raceId) external onlyOwner raceExists(_raceId) {
        //delete game
        delete races[_raceId];
        //decrement total games
        totalRaces--;
        //emit event
        emit RaceRemoved(address(races[_raceId]), _raceId);
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
        emit RaceAdded(address(races[_raceId]), _raceId);
    }

    // function for updating game
    function updateRacePlayer(
        string memory _raceId, 
        address playerAddress, 
        uint256 coins, 
        uint256 distance ) public onlyOwner raceExists(_raceId) {
        Race updatingRace = races[_raceId];
        updatingRace.updatePlayer(playerAddress, coins, distance);
    }


    function isPregame(string memory _raceId) external view returns (bool) {
        Race race = races[_raceId];
        return race.isPregame();
    }

    function isOngoing(string memory _raceId) external view returns (bool) {
        Race race = races[_raceId];
        return race.isOngoing();
    }

    function isFinished(string memory _raceId) external view returns (bool) {
        Race race = races[_raceId];
        return race.isFinished();
    }

    // functions for game
    function startGame(string memory _raceId) public onlyOwner {
        Race race = races[_raceId];
        return race.startGame();
    }

    function endGame(string memory _raceId) public onlyOwner {
        Race race = races[_raceId];
        return race.endGame();
    }


    function getRace(string memory _raceId) external view returns (Race) {
        return races[_raceId];
    }

    function getTotalPlayers(string memory _raceId) external view returns (uint32) {
        Race race = races[_raceId];
        return race.getTotalPlayers();
    }

    function isPlayer(string memory _raceId, address _account) external view returns (bool) {
        Race race = races[_raceId];
        return race.isPlayer(_account);
    }

    function getWinner(string memory _raceId) external view returns (address) {
        Race race = races[_raceId];
        return race.getWinner();
    }

    function getPlayerName(string memory _raceId, address _account) external view returns (string memory) {
        Race race = races[_raceId];
        return race.getPlayerName(_account);
    }

    function getPlayerCoins(string memory _raceId, address _account) external view returns (uint256) {
        Race race = races[_raceId];
        return race.getPlayerCoins(_account);
    }


    function getPlayerDistance(string memory _raceId, address _account) external view returns (uint256) {
        Race race = races[_raceId];
        return race.getPlayerDistance(_account);
    }

}