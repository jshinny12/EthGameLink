// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "./Race.sol";

contract ech_race_wrap {
   Race race;
   address ogOwner;

    constructor() {
         race = new Race(
            "1",
            payable(0xB1bD86E80f7A6286F575F7702618330b6Cd71510),
            "alice",
            payable(0x068A7c2cde82b5DB1E5c345fbD07666a7EA87931),
            "bob",
            payable(0xE6C93D50B1A3309b5d6b8867E1447c2D9b4DFe9a),
            "charlie",
            10
        );
        ogOwner = race.owner();
    }

    // functions for game
    function test_startGame() external {
        bool wasPregame = race.isPregame();
        race.startGame();
        assert(wasPregame);
    }

    function test_endGame() external {
        bool wasOngoing = race.isOngoing();
        race.endGame();
        assert(wasOngoing);
    }

    /// if_succeeds {:msg "Player Coins have Decreased" } old(players[addr].coins) > players[addr].coins;
    /// if_succeeds {:msg "intentionally failing test" } old(players[addr].coins) < players[addr].coins;
    function test_updatePlayer(
        address addr,
        uint256 coins,
        uint256 distance
    ) external {
        uint preCoins = race.getPlayerCoins(addr);
        uint preDist = race.getPlayerDistance(addr);
        race.updatePlayer(addr, coins, distance);
        assert(preCoins >= race.getPlayerCoins(addr));
        assert(preDist <= race.getPlayerCoins(addr));
    }

    function test_owner_hacked() public view {
        assert(race.owner() == ogOwner);
    }

}
