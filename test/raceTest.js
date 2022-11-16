const { ethers } = require("hardhat");
const { expect, assert, AssertionError} = require('chai');
const web3 = require("web3");
const { describe } = require("mocha");
const { solidity } = require("ethereum-waffle");

//before each test
let raceOwner; 
let player1; 
let player2; 
let player3;
let nonPlayer;
let race;


beforeEach(async function () {
    [raceOwner, player1, player2, player3, nonPlayer] = await ethers.getSigners();
    const race_fact = await ethers.getContractFactory("Race");
    race = await race_fact.deploy(0, player1.address, "Alice", player2.address, "Bob", player3.address, "Charlie", 15000, { gasLimit: 10000000 });
});

describe("Startup test", function () {
    it("Should deploy contract with correct variables", async function () {
        assert(await getRaceId() == 0, "Race id should be 0");
        assert(await owner() == raceOwner.address, "Owner is raceOwner");
        assert(await isPlayer(player1.address), "Player1 is player 1");
        assert(await isPlayer(player2.address), "Player2 is player 2");
        assert(await isPlayer(player3.address), "Player3 is player 3");
        assert(await getPlayerName(player1.address) == "Alice", "Player1 is Alice");
        assert(await getPlayerName(player2.address) == "Bob", "Player2 is Bob");
        assert(await getPlayerName(player3.address) == "Charlie", "Player3 is Charlie");
    });
    it("Should deploy with correct initial state", async function () {
        assert(await getTotalPlayers() == 3, "Total players should be 3");
        assert(await isPregame(), "Initializes game state to pregame");
        assert(!(await isOngoing()), "Game is not Ongoing");
        assert(await isFinished() == false, "Game is not Finished");
        assert(await getPlayerCoins(player1.address) == 15000, "Player1 has 15000 coins");
        assert(await getPlayerCoins(player2.address) == 15000, "Player2 has 15000 coins");
        assert(await getPlayerCoins(player3.address) == 15000, "Player3 has 15000 coins");
        assert(await getPlayerDistance(player1.address) == 0, "Player1 should have no distance");
        assert(await getPlayerDistance(player2.address) == 0, "Player2 should have no distance");
        assert(await getPlayerDistance(player3.address) == 0, "Player3 should have no distance");
    });
    it("Player1 address = 0 reverts", async function() {
        race_fact = await ethers.getContractFactory("Race");
        await expect(race_fact.deploy(0, "0x0000000000000000000000000000000000000000", "Alice", player2.address, "Bob", player3.address, "Charlie", 15000, { gasLimit: 10000000 })).to.be.reverted;
    });
    it("Player2 address = 0 reverts", async function() {
        race_fact = await ethers.getContractFactory("Race");
        await expect(race_fact.deploy(0, player1.address, "Alice", "0x0000000000000000000000000000000000000000", "Bob", player3.address, "Charlie", 15000, { gasLimit: 10000000 })).to.be.reverted;
    });
    it("Player3 address = 0 reverts", async function() {
        race_fact = await ethers.getContractFactory("Race");
        await expect(race_fact.deploy(0, player1.address, "Alice", player2.address, "Bob", "0x0000000000000000000000000000000000000000", "Charlie", 15000, { gasLimit: 10000000 })).to.be.reverted;
    });
    it("initCoins = 0 reverts", async function() {
        race_fact = await ethers.getContractFactory("Race");
        await expect(race_fact.deploy(0, player1.address, "Alice", player2.address, "Bob", player3.address, "Charlie", 0, { gasLimit: 10000000 })).to.be.reverted;
    });
});

describe("end/start game tests", function () {
    it("startGame basic", async function() {
        await race.connect(raceOwner).startGame();
        assert(!(await isPregame()), "Not Pregame");
        assert((await isOngoing()), "Is Ongoing");
        assert(!(await isFinished()), "Not Finished");
    });

    it("startGame reverts if not owner", async function() {
        await expect(race.connect(player1).startGame()).to.be.reverted;
    }); 

    it("startGame rverts if wrong current state", async function () {
        race.connect(raceOwner).startGame();
        await expect(race.connect(raceOwner).startGame()).to.be.reverted;
        race.connect(raceOwner).endGame();
        await expect(race.connect(raceOwner).startGame()).to.be.reverted;
    });

    it("endGame basic", async function () {
        await race.connect(raceOwner).startGame();
        await race.connect(raceOwner).endGame();
        assert(!(await isPregame()), "Not Pregame");
        assert(!(await isOngoing()), "Is Ongoing");
        assert((await isFinished()), "Not Finished");
    });

    it("endGame reverts if not owner", async function() {
        await race.connect(raceOwner).startGame();
        await expect(race.connect(player1).endGame()).to.be.reverted;
    });

    it("endGame reverts if wrong current state", async function() {
        await expect(race.connect(raceOwner).endGame()).to.be.reverted;
        race.connect(raceOwner).startGame();
        race.connect(raceOwner).endGame();
        await expect(race.connect(raceOwner).startGame()).to.be.reverted;
    });
});



describe("Invalid player data lookup", function () {
    it("isPlayer false", async function() {
        assert(!(await isPlayer(nonPlayer.address)), "isPlayer returns false for non-Player");
    });
    it("getPlayerName bad", async function() {
        assert(await getPlayerName(nonPlayer.address)==0);
    });
    it("getPlayerCoins bad"), async function() {
        assert(await getPlayerCoins(nonPlayer.address)==0);
    }
    it("getPlayerDistance bad", async function() {
        assert(await getPlayerDistance(nonPlayer.address)==0);
    });
});

describe("getWinner test", function() {
    it("finish get winner default" , async function() {
        await race.connect(raceOwner).startGame();
        await race.connect(raceOwner).endGame();
        assert(await race.getWinner() == player1.address, "default winner is player1");
        assert(await getPlayerCoins(player1.address) == 15000, "Player1 has 15000 coins");
        assert(await getPlayerDistance(player1.address) == 0, "Player1 has 0 distance");
    });

    it("getWinner after finish" , async function() {
        await race.connect(raceOwner).startGame();
        await race.connect(raceOwner).updatePlayer(player1.address, 7000, 5, { gasLimit: 10000000 });
        await race.connect(raceOwner).updatePlayer(player2.address, 5000, 8, { gasLimit: 10000000 });
        await race.connect(raceOwner).updatePlayer(player3.address, 2000, 14, { gasLimit: 10000000 });
        await race.connect(raceOwner).endGame();

        assert(await race.getWinner() == player3.address, "player3 largest distance");
        assert(await getPlayerCoins(player1.address) == 7000, "Player1 has 7000 coins");
        assert(await getPlayerDistance(player1.address) == 5, "Player1 has 5 distance");
        assert(await getPlayerCoins(player2.address) == 5000, "Player2 has 5000 coins");
        assert(await getPlayerDistance(player2.address) == 8, "Player2 has 8 distance");
        assert(await getPlayerCoins(player3.address) == 2000, "Player3 has 2000 coins");
        assert(await getPlayerDistance(player3.address) == 14, "Player3 has 14 distance");
    });

    it("getWinner reverted, game hasn't finished", async function() {
        await race.connect(raceOwner).startGame();
        race.connect(raceOwner).updatePlayer(player1.address, 7000, 6, { gasLimit: 10000000 });
        await expect(race.connect(raceOwner).getWinner()).to.be.reverted;
    });
})

describe("updatePlayer tests", function ()  {
    it("updatePlayer basic" , async function() {
        await race.connect(raceOwner).startGame();
        await race.connect(raceOwner).updatePlayer(player1.address, 7000, 5, { gasLimit: 10000000 });
        assert(await getPlayerCoins(player1.address) == 7000, "Player1 has 7000 coins");
        assert(await getPlayerDistance(player1.address) == 5, "Player1 has 5 distance");
        assert(await getPlayerCoins(player2.address) == 15000, "Player2 should not have changed");
        assert(await getPlayerDistance(player2.address) == 0, "Player2 should not have changed");
        assert(await getPlayerCoins(player3.address) == 15000, "Player3 should not have changed");
        assert(await getPlayerDistance(player3.address) == 0, "Player3 should not have changed");
    });
    it("updatePlayer reverted, before started" , async function() {
        await expect(race.connect(raceOwner).updatePlayer(player1.address, 7000, 5, { gasLimit: 10000000 })).to.be.reverted;
    });
    it("updatePlayer reverted, not owner" , async function() {
        await race.connect(raceOwner).startGame();
        await expect(race.connect(player1).updatePlayer(player1.address, 7000, 5, { gasLimit: 10000000 })).to.be.reverted;
    });

    it("updatePlayer, coins too many" , async function() {
        await race.connect(raceOwner).startGame();
        await expect(race.connect(raceOwner).updatePlayer(player1.address, 17000, 5, { gasLimit: 10000000 })).to.be.reverted;
    });

    it("updatePlayer reverted, distance too little" , async function() {
        await race.connect(raceOwner).startGame();
        await race.connect(raceOwner).updatePlayer(player1.address, 7000, 6, { gasLimit: 10000000 });
        await expect(race.connect(raceOwner).updatePlayer(player1.address, 2000, 3, { gasLimit: 10000000 })).to.be.reverted;
    });
});
        
async function endGame() {
    return await race.endGame()
}

async function getPlayerCoins(playerId) {
    return await race.getPlayerCoins(playerId)
}

async function getPlayerDistance(playerId) {
    return await race.getPlayerDistance(playerId)
}

async function getPlayerName(playerId) {
    return await race.getPlayerName(playerId)
}

async function getRaceId() {
    return await race.getRaceId()
}

async function getTotalPlayers() {
    return await race.getTotalPlayers()
}

async function getWinner() {
    return await race.getWinner()
}

async function isFinished() {
    return await race.isFinished()
}

async function isOngoing() {
    return await race.isOngoing()
}

async function isPlayer(addr) {
    return await race.isPlayer(addr)
}

async function isPregame() {
    return await race.isPregame()
}

async function owner() {
    return await race.owner()
}

async function players() {
    // accesses the public mapping players
    return await race.players()
}

async function renounceOwnership() {
    return await race.renounceOwnership();
}

async function getPlayerAddress(playerId) {
  return await race.getPlayerAddress(playerId);
}

async function getPlayerCoins(playerId) {
  return await race.getPlayerCoins(playerId);
}

async function isPlayer(address) {
  return await race.isPlayer(address);
}

async function getBalance(address) {
  var balance = (await ethers.provider.getBalance(address)) / 1e18;
  return balance;
}

async function getPlayerDistance(playerId) {
  return await race.getPlayerDistance(playerId);
}

async function startGame() {
    return await race.startGame()
}

async function transferOwnership(newOwnerAddr) {
    return await race.transferOwnership(newOwnerAddr)
}

async function updatePlayer(addr, coins, dist) {
    return await race.updatePlayer(addr, coins, dist)
}


