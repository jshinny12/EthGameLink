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
    const fact = await ethers.getContractFactory("ech_race_wrap");
    wrap = await fact.deploy();
});

describe("Startup test", function () {
    it("Should deploy", async function () {
        console.log("here");
    })
});