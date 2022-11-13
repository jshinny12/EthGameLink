// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IGame.sol";

interface IPayoutGame is IGame {
    event PlayerWithdraw(uint256 indexed id, address indexed addr);
    event OwnerWithdraw(uint256 indexed id, address indexed addr);

    function getGameOwner() external view returns (address);
    function getWithdrawBalance() external view returns (uint256);

    // used for players to withdraw tokens from contract, ex prize money
    function withdraw() external returns (bool);

    // specific withdraw for owner. Should enforce so that 
    // owner can withdraw in edge cases, 
    // they can override if they dont like it
    function ownerWithdraw() external returns (bool);
}