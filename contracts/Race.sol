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
        ONGOING,
        ENDED
    }

    State gameState;
    string raceId;
    address currWinnerAddr;

    event GameCreated();
    event GameStarted();
    event GameFinished();

    constructor(string memory _raceId, address addr1, string memory name1, address addr2, string memory name2, address addr3, string memory name3, uint initCoins) {        
        raceId = _raceId;
        players[addr1] = makePlayer(name1, initCoins);
        players[addr2] = makePlayer(name2, initCoins);
        players[addr3] = makePlayer(name3, initCoins);

        currWinnerAddr = addr1;

        gameState = State(0);

        emit GameCreated();

    }

    //make player funciton 
    function makePlayer(string memory name, uint coins) private pure returns(Player memory) {
        return Player(name, coins, 0, true);
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
        return p != 0 && p.isPlayer;
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
        gameState = State(2);
        emit GameStarted();
    }

    function hasNotStart() external view returns (bool){
        return gameState != State(0);
    }

    function hasOngoing() external view returns (bool){
        return gameState == State(1);
    }

    function hasFinished() external view returns (bool){
        return gameState == State(2);
    }

    // functions for game
    function getTotalPlayers() external view returns (uint32){
        return 3;
    }

    // player specific 
    function getWinner() external view returns (address account) onlyOwner gameFinished { 
        return currWinnerAddr;
    }

    function getRaceId() external view returns (race id) {
        return raceId;
    }

    //function for getting a player
    function getPlayerName(uint256 playerId) external view returns (address account, string memory name, uint coins, uint distance) {
        Player memory p = players[playerId];
        return p.name;
    }

    // get a player's coins
    function getPlayerCoins(uint256 playerId) external view returns (address account, string memory name, uint coins, uint distance) {
        Player memory p = players[playerId];
        return p.coins;
    }

    // get players distance
    function getPlayerDistance(uint256 playerId) external view returns (address account, string memory name, uint coins, uint distance) {
        Player memory p = players[playerId];
        return p.distance;
    }

}

