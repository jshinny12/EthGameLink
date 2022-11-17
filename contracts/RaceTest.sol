// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

//import ownable properties
import "@openzeppelin/contracts/access/Ownable.sol";
// import counter
import "@openzeppelin/contracts/utils/Counters.sol";
//import IGame
import "./IGame.sol";

contract RaceTest is IGame, Ownable {
    struct Player {
        string name;
        uint256 coins;
        uint256 distance;
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
    address payable currWinnerAddr;

    constructor(
    ) {
        address payable addr1 = payable(0xB1bD86E80f7A6286F575F7702618330b6Cd71510);
        address payable addr2 = payable(0x068A7c2cde82b5DB1E5c345fbD07666a7EA87931);
        address payable addr3 = payable(0xE6C93D50B1A3309b5d6b8867E1447c2D9b4DFe9a);

        uint256 initCoins = 10;   
        
        raceId = "1";
        
        players[addr1] = makePlayer("alice", initCoins);
        players[addr2] = makePlayer("bob", initCoins);
        players[addr3] = makePlayer("charlie", initCoins);

        currWinnerAddr = addr1;

        gameState = State(0);

        emit GameCreated();
    }

    //make player funciton
    function makePlayer(string memory name, uint256 coins)
        private
        pure
        returns (Player memory)
    {
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
    function isPregame() external view override returns (bool) {
        return gameState == State(0);
    }

    function isOngoing() external view override returns (bool) {
        return gameState == State(1);
    }

    function isFinished() external view override returns (bool) {
        return gameState == State(2);
    }

    // functions for game
    function startGame() public onlyOwner pregame {
        gameState = State(1);
        emit GameBegun();
    }

    function endGame() public onlyOwner ongoing {
        gameState = State(2);
        emit GameFinished();
    }

    function getTotalPlayers() external view override returns (uint32) {
        return 3;
    }

    function getRaceId() external view returns (string memory) {
        return raceId;
    }

    function updatePlayer(
        address addr,
        uint256 coins,
        uint256 distance
    ) public onlyOwner ongoing {
        require(this.isPlayer(addr));

        Player memory p = players[addr];

        require(coins <= p.coins && distance >= p.distance);

        p.coins = coins;
        p.distance = distance;
        players[addr] = p;

        Player memory currWinner = players[currWinnerAddr];
        if (p.distance > currWinner.distance) {
            currWinnerAddr = payable(addr);
        }
    }

    // player specific
    function isPlayer(address account) external view override returns (bool) {
        Player memory p = players[account];
        return p.isPlayer && (account != address(0));
    }

    function getWinner() external view override finished returns (address) {
        return currWinnerAddr;
    }

    function getPlayerName(address playerAddr)
        external
        view
        returns (string memory)
    {
        Player memory p = players[playerAddr];
        return p.name;
    }

    function getPlayerCoins(address playerAddr)
        external
        view
        returns (uint256)
    {
        Player memory p = players[playerAddr];
        return p.coins;
    }

    function getPlayerDistance(address playerAddr)
        external
        view
        returns (uint256)
    {
        Player memory p = players[playerAddr];
        return p.distance;
    }
}
