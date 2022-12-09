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
    const monaco_fact = await ethers.getContractFactory("MonacoResults");
    monaco = await monaco_fact.deploy();
});


describe.only("Add Race Test", function () {
    let race;
    let raceId = "0"
    
    
    beforeEach(async function () {
        await addRace(raceId, player1.address, "Alice", player2.address, "Bob", player3.address, "Charlie", 15000);
        race = await getRace(raceId);
    });

    it("Rce has correct variables", async function () {
        assert(await owner(raceId) == raceOwner.address, "Owner is raceOwner");
        assert(await isPlayer(raceId, player1.address), "Player1 is player 1");
        assert(await isPlayer(raceId, player2.address), "Player2 is player 2");
        assert(await isPlayer(raceId, player3.address), "Player3 is player 3");
        assert(!(await isPlayer(raceId, nonPlayer.address)), "isPlayer returns false for non-Player");
        assert(await getPlayerName(raceId, player1.address) == "Alice", "Player1 is Alice");
        assert(await getPlayerName(raceId,player2.address) == "Bob", "Player2 is Bob");
        assert(await getPlayerName(raceId, player3.address) == "Charlie", "Player3 is Charlie");
        assert(await getPlayerName(raceId, nonPlayer.address)==0);
    });

    it("Race should have correct initial state", async function () {
        assert(await getTotalPlayers(raceId) == 3, "Total players should be 3");
        assert(await isPregame(raceId), "Initializes game state to pregame");
        assert(!(await isOngoing(raceId)), "Game is not Ongoing");
        assert(await isFinished(raceId) == false, "Game is not Finished");
        assert(await getPlayerCoins(raceId, player1.address) == 15000, "Player1 has 15000 coins");
        assert(await getPlayerCoins(raceId, player2.address) == 15000, "Player2 has 15000 coins");
        assert(await getPlayerCoins(raceId, player3.address) == 15000, "Player3 has 15000 coins");
        assert(await getPlayerCoins(raceId, nonPlayer.address)==0);
        assert(await getPlayerDistance(raceId, player1.address) == 0, "Player1 should have no distance");
        assert(await getPlayerDistance(raceId, player2.address) == 0, "Player2 should have no distance");
        assert(await getPlayerDistance(raceId, player3.address) == 0, "Player3 should have no distance");
        assert(await getPlayerDistance(raceId, nonPlayer.address)==0);
    });
    
});


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

async function addRace(_raceId, addr1, name1, addr2, name2, addr3, name3, initCoins) {
    return await monaco.addRace(_raceId, addr1, name1, addr2, name2, addr3, name3,initCoins);
}

async function updateRacePlayer(_raceId, playerAddress, coins, distance) {
    return await monaco.updateRacePlayer(_raceId, playerAddress, coins, distance);
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