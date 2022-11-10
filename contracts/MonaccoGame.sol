pragma solidity ^0.8.0;

//import ownable properties
import "@openzeppelin/contracts/access/Ownable.sol";
// import counter
import "@openzeppelin/contracts/utils/Counters.sol";
//import IGame
import "./IGame.sol";

contract MonaccoGame is IGame, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _playerIds;
    
    event GameCreated();
    event GameStarted();
    event GameFinished();
    event PlayerJoined(address indexed addr);
    
    struct Player {
        uint256 id;
        uint256 amount;
        uint256 score;
        bool joined;
    }

    address currentWinner; // address of the current winner
    uint256 currentWinnerId; // id of the current winner
    uint start; 
    uint end; 
    Player[] memory players; 
    bool hasStarted;
    bool hasFinished;

   //constructor for game
    constructor(address player1, address player2, address player3, uint256 amount) {
        currentWinner = 0; 
        currentWinnerId = 0;
        start = 0;
        end = 0;
        hasStarted = false;
        hasFinished = false;
        players = new Player[](3);
        // use addplayer function to join the players
        addPlayer(player1, amount);
        addPlayer(player2, amount);
        addPlayer(player3, amount);
        emit GameCreated();
    }

    // modifier for player exists
    modifier playerExists(address account) {
        require(isPlayer(account), "Player does not exist");
        _;
    }

    // modifier for player does not exist
    modifier playerDoesNotExist(address account) {
        require(!isPlayer(account), "Player already exists");
        _;
    }

    //modifier for game ongoing
    modifier gameOngoing() {
        require(hasStarted == true && hasFinished == false, "Game is not ongoing");
        _;
    }


    //modifier for game not ongoing
    modifier gameNotOngoing() {
        require(hasStarted == false || hasFinished == true, "Game is ongoing");
        _;
    }

    //implment all IGame functions
    function getTotalPlayers() external view returns (uint32) onlyOwner {
        return players.length;
    }

    function hasStart() external view returns (bool) onlyOwner {
        return hasStarted;
    }

    function hasFinished() external view returns (bool) onlyOwner {
        return hasFinished;
    }

    // function for starting time 
    function startGame() external onlyOwner gameNotOngoing {
        start = block.timestamp;
        hasStarted = true;
        emit GameStarted();
    }

    // function for ending time
    function endGame() external onlyOwner gameOngoing {
        end = block.timestamp;
        hasFinished = true;
        emit GameFinished();
    }

    function isPlayer(address account) external view returns (bool) onlyOwner {
        return players[account] != 0;
    }

    function joinGame() external payable returns (bool) onlyOwner {
        return false;
    }

    //set winners
    function setWinner(address account, uint256 id) internal onlyOwner playerExists {
        currentWinner = account;
        currentWinnerId = id;
    }

    function getWinner() external view returns (address account) onlyOwner playerExists {
        return currentWinner;
    }

    //function for getting player
    function getPlayer(address account) internal view returns (Player memory) onlyOwner playerExists {
        return players[account];
    }

    //function for getting player id
    function getPlayerId(address account) internal view returns (uint256) onlyOwner playerExists {
        return getPlayer(account).id;
    }

    //function for getting player amount
    function getPlayerAmount(address account) internal view returns (uint256) onlyOwner playerExists {
        return getPlayer(account).amount;
    }

    //function for getting player score
    function getPlayerScore(address account) internal view returns (uint256) onlyOwner playerExists {
        return getPlayer(account).score;
    }


    //function for updating player score
    function updatePlayerScore(address account, uint256 score) internal onlyOwner playerExists {
        players[account].score = score;
    }

    //function for updating player amount
    function updatePlayerAmount(address account, uint256 amount) internal onlyOwner playerExists {
        players[account].amount = amount;
    }

    // INTERNAL FUNCTIONS
    //function for adding a player to the game
    function addPlayer(address account, uint256 amount) internal onlyOwner playerDoesNotExist {
        players[account] = Player({
            id: _playerIds.current(),
            amount: amount,
            score: 0,
            joined: true
        });
        _playerIds.increment();
        emit PlayerJoined(account);
    }

}
