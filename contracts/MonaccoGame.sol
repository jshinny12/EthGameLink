pragma solidity ^0.8.0;

//import ownable properties
import "@openzeppelin/contracts/access/Ownable.sol";
// import counter
import "@openzeppelin/contracts/utils/Counters.sol";
//import IGame
import "./IGame.sol";

contract Race is IGame, Ownable {
    struct Player {
        string name;
        uint coins;
        uint distance;
        bool isPlayer;
    } 

    mapping(address => Player) public players;

    enum State {
        BEFORE,
        STARTED,
        ENDED
    }

    State gameState;
    string raceId;

    address currWinnerAddr;


    constructor(string memory _raceId, address addr1, string memory name1, address addr2, string memory name2, address addr3, string memory name3, uint initCoins) {        
        raceId = _raceId;
        players[addr1] = makePlayer(name1, initCoins);
        players[addr2] = makePlayer(name2, initCoins);
        players[addr3] = makePlayer(name3, initCoins);

        currWinnerAddr = addr1;

        gameState = State(0);

        emit GameCreated();

    }

    function makePlayer(string memory name, uint coins) private returns(Player memory){
        Player memory p;
        p.name = name;
        p.coins = coins;
        p.distance = 0;
        p.isPlayer = true;
        return p;
    }

    modifier gameHasNotBegun() {
        require(gameState == State(0));
        _;
    }
    modifier gameBegun() {
        require(gameState == State(1));
        _;
    }
    
    modifier gameFinished() {
        require(gameState == State(2));
        _;
    }

    function _isPlayer(address account) private view returns (bool) {
        Player memory p = players[account];
        return p.isPlayer;
    }

    function isPlayer(address account) external view returns (bool){
        return _isPlayer(account);
    }


    function updatePlayer(address addr, uint coins, uint distance) public onlyOwner {
        require(_isPlayer(addr));

        Player memory p = players[addr];

        require(coins <= p.coins && distance >= p.distance);

        p.coins = coins;
        p.distance = distance;

        Player memory currWinner = players[currWinnerAddr];

        if(p.distance > currWinner.distance) {
            currWinnerAddr = addr;
        }
    }

    function startGame() public onlyOwner gameHasNotBegun{
        gameState = State(1);
        emit GameStarted();
    }

    function end() public onlyOwner gameBegun{
        gameState = State(1);
        emit GameStarted();
    }

    function hasStart() external view returns (bool){
        return gameState != State(0);
    }

    function hasFinished() external view returns (bool){
        return gameState == State(1);
    }

    // functions for game
    function getTotalPlayers() external view returns (uint32){
        return 3;
    }

    // player specific 
    function getWinner() external view returns (address account) {
        if (gameState == State(2)) {
            return currWinnerAddr;
        } else {
            return address(0);    
        }
    }
}

