contract Matchbox {

    // game struct that stores game info
    struct Game {
        uint256 id;
        address owner;
        address admin;
        uint256 fee;
        bool status;
        uint256 totalAmount;
        uint256 totalPlayers;
        uint256 totalWinners;
        uint256 totalWinAmount;
        uint256 totalLoseAmount;
    }

    // player struct that stores player info
    struct Player {
        uint256 id;
        address addr;
        uint256 amount;
        uint256 winAmount;
        uint256 loseAmount;
        uint256 winCount;
        uint256 loseCount;
        uint256 lastPlayTime;
        uint256 lastWithdrawTime;
    }

    // map of game id to games
    mapping(uint256 => Game) public games;
}