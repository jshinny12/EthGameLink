// SPDX-License-Identifier: SEE LICENSE IN LICENSE
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
        PREGAME,
        ONGOING,
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

    //make player funciton 
    function makePlayer(string memory name, uint coins) private pure returns(Player memory) {
        return Player(name, coins, 0, true);
    }

    // Modifiers regarding play stage
    modifier pregame() {
        require(gameState == State(0));
        _;
    }
    modifier ongoing() {
        require(gameState == State(1));
        _;
    }
    
    modifier finished() {
        require(gameState == State(2));
        _;
    }

    // view functions regarding play stage
    function isPregame() external view returns (bool){
        return gameState != State(0);
    }

    function isOngoing() external view returns (bool){
        return gameState == State(1);
    }

    function isFinished() external view returns (bool){
        return gameState == State(2);
    }
    
    // functions for game
    function startGame() public onlyOwner pregame {
        gameState = State(1);
        emit GameBegun();
    }

    function endGame() public onlyOwner ongoing{
        gameState = State(2);
        emit GameFinished();
    }

    function getTotalPlayers() external view returns (uint32){
        return 3;
    }
    
    function getRaceId() external view returns (string memory) {
        return raceId;
    }

    function updatePlayer(address addr, uint coins, uint distance) public onlyOwner ongoing {
        require(this.isPlayer(addr));

        Player memory p = players[addr];

        require(coins <= p.coins && distance >= p.distance);

        p.coins = coins;
        p.distance = distance;
        
        Player memory currWinner = players[currWinnerAddr];
        if(p.distance > currWinner.distance) {
            currWinnerAddr = addr;
        }
    }

    // player specific 
    function isPlayer(address account) external view returns (bool){
        Player memory p = players[account];
        return p.isPlayer && (account != address(0));
    }

    function getWinner() external view finished returns (address) { 
        return currWinnerAddr;
    }

    function getPlayerName(address playerId) external view returns (string memory) {
        Player memory p = players[playerId];
        return p.name;
    }

    function getPlayerCoins(address playerId) external view returns (uint) {
        Player memory p = players[playerId];
        return p.coins;
    }

    function getPlayerDistance(address playerId) external view returns (uint) {
        Player memory p = players[playerId];
        return p.distance;
    }

}

