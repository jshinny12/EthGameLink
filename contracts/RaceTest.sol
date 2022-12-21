// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

//import ownable properties
import "@openzeppelin/contracts/access/Ownable.sol";
// import counter
import "@openzeppelin/contracts/utils/Counters.sol";
//import IGame
import "./IGame.sol";

import "./Race.sol";

contract RaceTest {
    Race level;

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

    constructor() payable {
        level = new Race(
            "1",
            payable(0xB1bD86E80f7A6286F575F7702618330b6Cd71510),
            "alice",
            payable(0x068A7c2cde82b5DB1E5c345fbD07666a7EA87931),
            "bob",
            payable(0xE6C93D50B1A3309b5d6b8867E1447c2D9b4DFe9a),
            "charlie",
            10
        );
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

    function test_updatePlayer() public {
        level.updatePlayer(
            payable(0xB1bD86E80f7A6286F575F7702618330b6Cd71510),
            2,
            2
        );
        test_hacked();
    }

    function test_hacked() public returns (bool) {
        assert(msg.sender == address(level));
    }
}
