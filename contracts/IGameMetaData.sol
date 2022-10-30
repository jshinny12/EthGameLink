// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.17;
//import ownable from openzeppelin
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


interface IGameMetaData is Ownable {

    struct Game {
        uint256 id;
        address owner;
        bool started;
        bool ended;
        uint256 totalPlayers;
        uint256 totalWinners;
        uint256 totalWinAmount;
    }

    //function for returning game id
    function getGameId() external view returns (uint256);
    // maybe there are multiple number of winners possible in the game
    function getNumberOfWinners() external view returns (uint256);
    // the amount that is allotted into the game
    function getAmountTotal() external view returns (uint256);

    // when the game starts
    function getStartTime() external view returns (uint256);

    // when the game ends
    function getEndTime() external view returns (uint256);

    // if the game is a team vs single player game
    function isTeam() external view returns (bool);

    // if the game has started
    function isGameStarted() external view returns (bool);

    // if the game has ended
    function isGameEnded() external view returns (bool);


    // get the owner of the game
    function getGameOwner() external view returns (address);
    
    //function for returning game info
    function getGameInfo() external view returns (Game memory);

    
}