// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

interface IGameMetaData {
    // returns the name of the game, ex matchbox
    function getGameName() external view returns (string memory);
}