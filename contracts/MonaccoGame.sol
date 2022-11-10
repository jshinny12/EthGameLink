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




// contract Race is IGame, Ownable {
//     struct Player {
//         string name;
//         uint coins;
//         uint distance;
//         bool isPlayer;
//     } 

//     mapping(address => Player) public players;

//     enum State {
//         BEFORE,
//         STARTED,
//         DONE
//     }

//     State gameState;
//     string raceId;

//     address currWinnerAddr;


//     constructor(string memory _raceId, address addr1, string memory name1, address addr2, string memory name2, address addr3, string memory name3, uint initCoins) {        
//         raceId = _raceId;
//         players[addr1] = makePlayer(name1, initCoins);
//         players[addr2] = makePlayer(name2, initCoins);
//         players[addr3] = makePlayer(name3, initCoins);

//         currWinnerAddr = addr1;

//         gameState = State(0);

//         emit PlayerJoined(addr1);
//         emit PlayerJoined(addr2);
//         emit PlayerJoined(addr3);
//         emit GameCreated();

//     }

//     function makePlayer(string memory name, uint coins) private returns(Player memory){
//         Player memory p;
//         p.name = name;
//         p.coins = coins;
//         p.distance = 0;
//         p.isPlayer = true;
//         return p;
//     }

//     modifier gameHasNotBegun() {
//         require(gameState == State(0));
//         _;
//     }
//     modifier gameBegun() {
//         require(gameState == State(1));
//         _;
//     }
    
//     modifier gameFinished() {
//         require(gameState == State(2));
//         _;
//     }

//     function _isPlayer(address account) private view returns (bool) {
//         Player memory p = players[account];
//         return p.isPlayer;
//     }

//     function isPlayer(address account) external view returns (bool){
//         return _isPlayer(account);
//     }


//     function updatePlayer(address addr, uint coins, uint distance) public onlyOwner {
//         require(_isPlayer(addr));

//         Player memory p = players[addr];

//         require(coins <= p.coins && distance >= p.distance);

//         p.coins = coins;
//         p.distance = distance;

//         Player memory currWinner = players[currWinnerAddr];

//         if(p.distance > currWinner.distance) {
//             currWinnerAddr = addr;
//         }
//     }

//     function startGame() public onlyOwner gameHasNotBegun{
//         gameState = State(1);
//         emit GameStarted();
//     }

//     function end() public onlyOwner gameBegun{
//         gameState = State(1);
//         emit GameStarted();
//     }

//     function hasStart() external view returns (bool){
//         return gameState != State(0);
//     }

//     function hasFinished() external view returns (bool){
//         return gameState == State(1);
//     }

//     // functions for game
//     function getTotalPlayers() external view returns (uint32){
//         return 3;
//     }

//     // player specific 
//     function getWinner() external view returns (address account) {
//         if (gameState == State(0)) {
//             return currWinnerAddr;
//         } else {
//             return address(0);    
//         }
//     }
// }

