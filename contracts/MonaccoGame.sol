pragma solidity ^0.8.0;

contract MonaccoGame is IGame, Ownable {
    
    struct Player {
        uint256 id;
        uint256 amount;
        uint256 score;
    }

    address currentWinner; // address of the current winner
    uint256 currentWinnerId; // id of the current winner

    mapping(address => Player) players;

    // modifier for checking if the game has started, and ended
    modifier hasStarted() {
        require(hasStart(), "Game has not started yet");
        _;
    }

    modifier hasEnded() {
        require(hasFinished(), "Game has not ended yet");
        _;
    }

    event GameCreated(bool status);
    event GameStarted(bool status);
    event GameFinished(bool status);
    event PlayerJoined(address indexed addr);

    //implment all IGame functions
    function getTotalPlayers() external view returns (uint32) {
        return 0;
    }
    function hasStart() external view returns (bool) {
        return false;
    }
    function hasFinished() external view returns (bool) {
        return false;
    }

    function getWinner() external view returns (address account) {
        return address(0);
    }
    function isPlayer(address account) external view returns (bool) {
        return false;
    }
    function joinGame() external payable returns (bool) {
        return false;
    }



}