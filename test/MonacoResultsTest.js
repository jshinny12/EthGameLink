const { ethers } = require("hardhat");
const { expect, assert, AssertionError} = require('chai');
const web3 = require("web3");
const { describe } = require("mocha");
const { solidity } = require("ethereum-waffle");

//before each test
let owner; 
let player1; 
let player2; 
let player3;
let nonPlayer;
let monaco;
let raceOwner;




beforeEach(async function () {
    [owner, player1, player2, player3, nonPlayer] = await ethers.getSigners();
    const monaco_fact = await ethers.getContractFactory("MonacoResults");
    monaco = await monaco_fact.deploy();
    raceOwner = monaco.address
});



describe("Add Race Test", function () {    
    
    it("Add Multiple Races", async function () {
        await addRaceAndTest("0", player1.address, "Alice", player2.address, "Bob", player3.address, "Charlie", 15000);
        await addRaceAndTest("1", player2.address, "A", player3.address, "B", player1.address, "C", 15000);
        await addRaceAndTest("2", player3.address, "A", player2.address, "B", player1.address, "C", 15000);
    });

    it("Can't add a race that already exists", async function () {
        await addRaceAndTest("0", player1.address, "Alice", player2.address, "Bob", player3.address, "Charlie", 15000);
        await expect(
            addRace("0", player1.address, "Alice", player2.address, "Bob", player3.address, "Charlie", 15000)
        ).to.be.reverted;
       
        await expect(
            addRace("0", player3.address, "A", player2.address, "B", player1.address, "C", 15000)
        ).to.be.reverted;
    });

    it("Player1 address = 0 reverts", async function() {
        await expect(addRace("1", "0x0000000000000000000000000000000000000000", "Alice", player2.address, "Bob", player3.address, "Charlie", 15000)).to.be.reverted;
    });

    it("Player2 address = 0 reverts", async function() {
        await expect(addRace("1", player1.address, "Alice", "0x0000000000000000000000000000000000000000", "Bob", player3.address, "Charlie", 15000)).to.be.reverted;
    });

    it("Player3 address = 0 reverts", async function() {
        await expect(addRace("1", player1.address, "Alice", player2.address, "Bob", "0x0000000000000000000000000000000000000000", "Charlie", 15000)).to.be.reverted;
    });

    it("initCoins = 0 reverts", async function() {
        await expect(addRace("1", player1.address, "Alice", player2.address, "Bob", player3.address, "Charlie", 0)).to.be.reverted;
    });
    
});

describe("Delete Race Test", function () {    
    it("Delete Races", async function () {
        await addRaceAndTest("0", player1.address, "Alice", player2.address, "Bob", player3.address, "Charlie", 15000);
        await removeRaceAndTest("0");
        await addRaceAndTest("0", player1.address, "Alice", player2.address, "Bob", player3.address, "Charlie", 15000);
        await expect(
            addRace("0", player3.address, "A", player2.address, "B", player1.address, "C", 15000)
        ).to.be.reverted;
        await removeRaceAndTest("0");
        await addRaceAndTest("0", player1.address, "Alice", player2.address, "Bob", player3.address, "Charlie", 15000);
    });

});

describe("Update Race Test", function () {    
    it("Update Race", async function () {
        await addRaceAndTest("0", player1.address, "Alice", player2.address, "Bob", player3.address, "Charlie", 15000);
        await startGame("0")
        assert(!await isPregame("0"), "Game is NOT pregame");
        assert(await isOngoing("0"), "Game is Ongoing");
        assert(! await isFinished("0"), "Game is NOT Finished");
        await updateRacePlayer("0", player1.address, 10, 100)
        await testRace("0", player1.address, "Alice", 10, 100, player2.address, "Bob", 15000, 0, player3.address, "Charlie", 15000, 0);
        await endGame("0")
        assert(!await isPregame("0"), "Game is NOT pregame");
        assert(!await isOngoing("0"), "Game is NOT Ongoing");
        assert(await isFinished("0"), "Game is Finished");
        await expect(getWinner("0") == player1.address)
    });

    it("Cant Update Race that does not exist", async function () {
        await expect(
            updateRacePlayer("0", player1.address, 10, 100)
        ).to.be.reverted;
    });

});

describe("Non Owner cant do anything", function () {   

    it("Non owner can't add game", async function () {
        await expect(
            monaco.connect(player1).addRace("0", player1.address, "Alice", player2.address, "Bob", player3.address, "Charlie", 15000)
        ).to.be.reverted; 
    });

    it("Non owner can't update", async function () {
        await addRaceAndTest("0", player1.address, "Alice", player2.address, "Bob", player3.address, "Charlie", 15000);
        await expect(
            monaco.connect(player1).updateRacePlayer("0", player1.address, 10, 10)
        ).to.be.reverted; 
    });

    it("Non owner can't start game", async function () {
        await addRaceAndTest("0", player1.address, "Alice", player2.address, "Bob", player3.address, "Charlie", 15000);
        assert(await isPregame("0"), "Initializes game state to pregame");
        assert(!await isOngoing("0"), "Game is not Ongoing");
        assert(! await isFinished("0"), "Game is not Finished");
        await expect(
            monaco.connect(player1).startGame("0")
        ).to.be.reverted; 
        assert(await isPregame("0"), "Initializes game state to pregame");
        assert(!await isOngoing("0"), "Game is not Ongoing");
        assert(! await isFinished("0"), "Game is not Finished");
    });

    it("Non owner can't end game", async function () {
        await addRaceAndTest("0", player1.address, "Alice", player2.address, "Bob", player3.address, "Charlie", 15000);
        await startGame("0")
        assert(!await isPregame("0"), "Game is NOT pregame");
        assert(await isOngoing("0"), "Game is Ongoing");
        assert(! await isFinished("0"), "Game is NOT Finished");
        await expect(
            monaco.connect(player1).startGame("0")
        ).to.be.reverted; 
        assert(!await isPregame("0"), "Game is NOT pregame");
        assert(await isOngoing("0"), "Game is Ongoing");
        assert(! await isFinished("0"), "Game is NOT Finished");
    });

});



async function getOwner() {
    return await monaco.owner();
}

async function getGameOwner(_raceId) {
    return await monaco.getGameOwner(_raceId);
}

async function isPregame(_raceId) {
    return await monaco.isPregame(_raceId);
}

async function isOngoing(_raceId) {
    return await monaco.isOngoing(_raceId);
}

async function isFinished(_raceId) {
    return await monaco.isFinished(_raceId);
}

async function startGame(_raceId) {
    return await monaco.startGame(_raceId);
}

async function endGame(_raceId) {
    return await monaco.endGame(_raceId);
}

async function addRaceAndTest(_raceId, addr1, name1, addr2, name2, addr3, name3, initCoins) {
    addRace(_raceId, addr1, name1, addr2, name2, addr3, name3, initCoins);   
    await testRace(_raceId, addr1, name1, initCoins, 0, addr2, name2, initCoins, 0, addr3, name3, initCoins, 0);
    assert(await isPregame(_raceId), "Initializes game state to pregame");
    assert(!(await isOngoing(_raceId)), "Game is not Ongoing");
    assert(await isFinished(_raceId) == false, "Game is not Finished");
}

async function addRace(_raceId, addr1, name1, addr2, name2, addr3, name3, initCoins) {
    return await monaco.addRace(_raceId, addr1, name1, addr2, name2, addr3, name3,initCoins);
}

async function testRace(raceId, addr1, name1, coins1, dist1, addr2, name2, coins2, dist2, addr3, name3, coins3, dist3) {
    assert(await getGameOwner(raceId) == raceOwner, "Owner is raceOwner");

    assert(await isPlayer(raceId, addr1));
    assert(await isPlayer(raceId, addr2));
    assert(await isPlayer(raceId, addr3));

    assert(!(await isPlayer(raceId, nonPlayer.address)));

    assert(await getPlayerName(raceId, addr1) == name1);
    assert(await getPlayerName(raceId, addr2) == name2);
    assert(await getPlayerName(raceId, addr3) == name3);
    assert(await getPlayerName(raceId, nonPlayer.address)==0);

    assert(await getTotalPlayers(raceId) == 3, "Total players should be 3");

    assert(await getPlayerCoins(raceId, addr1) == coins1);
    assert(await getPlayerCoins(raceId, addr2) == coins2);
    assert(await getPlayerCoins(raceId, addr3) == coins3);
    assert(await getPlayerCoins(raceId, nonPlayer.address)==0);

    assert(await getPlayerDistance(raceId, addr1) == dist1);
    assert(await getPlayerDistance(raceId, addr2) == dist2);
    assert(await getPlayerDistance(raceId, addr3) == dist3);
    assert(await getPlayerDistance(raceId, nonPlayer.address)== 0);
}

async function removeRaceAndTest(raceId) {
    removeRace(raceId);
    assert(await getRace("raceId") == ethers.constants.AddressZero)
}

async function removeRace(raceId) {
    return await monaco.removeRace(raceId);
}

async function updateRacePlayer(_raceId, playerAddress, coins, distance) {
    await monaco.updateRacePlayer(_raceId, playerAddress, coins, distance);
}

async function getRace(_raceId) {
    return await monaco.getRace(_raceId);
}

async function getTotalPlayers(_raceId) {
    return await monaco.getTotalPlayers(_raceId);
}

async function isPlayer(_raceId, _account) {
    return await monaco.isPlayer(_raceId, _account);
}

async function getWinner(_raceId) {
    return await monaco.getWinner(_raceId);
}

async function getPlayerName(_raceId, _account) {
    return await monaco.getPlayerName(_raceId, _account);
}

async function getPlayerCoins(_raceId, _account) {
    return await monaco.getPlayerCoins(_raceId, _account);
}

async function getPlayerDistance(_raceId, _account) {
    return await monaco.getPlayerDistance(_raceId, _account);
}
