// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.17;
//import ownable from openzeppelin
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/Access.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

interface IGame is Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _playerId;

    struct Player {
        uint256 id;
        address addr;
        uint256 amount;
    }

    // would have a mapping of address -> players

    // example modifiers for when we implement games: 

    // modifier for onlyOwner
    // modifier onlyOwner() {
    //     require(msg.sender == owner, "Only owner can call this function.");
    //     _;
    // }

    // modifier for game started 
    // modifier gameStarted() {
    //     require(gameStarted, "Game has not started yet.");
    //     _;
    // }

    // modifier for game ended
    // modifier gameEnded() {
    //     require(gameEnded, "Game has not ended yet.");
    //     _;
    // }

    // modifier for is player
    // modifier isPlayer() {
    //     require(players[msg.sender].addr != address(0), "You are not a player.");
    //     _;
    // }

    // modifier for is not player
    // modifier isNotPlayer() {
    //     require(players[msg.sender].addr == address(0), "You are already a player.");
    //     _;
    // }

    // Events specific for game
    event GameCreated(uint256 indexed id, address indexed owner, uint256 fee, bool status);
    event GameUpdated(uint256 indexed id, address indexed owner, uint256 fee, bool status);
    event GameFinished(uint256 indexed id, address indexed owner, uint256 fee, bool status);
    event GameResult(uint256 indexed id, address indexed addr, uint256 amount, uint256 winAmount, uint256 loseAmount);

    // Events for players
    event PlayerJoined(uint256 indexed id, address indexed addr);
    event PlayerLeft(uint256 indexed id, address indexed addr);
    event PlayerWithdraw(uint256 indexed id, address indexed addr);
    
    // functions for game
    function getTotalPlayers() external view returns (uint256);

    // player specific 
    function getPlayerId(address addr) external view returns (uint256);
    function getPlayer(uint256 id) external view returns (Player memory);
    function startGame() external view returns (uint256);
    function endGame() external view returns (uint256);
    
    // specific functions for players
    function joinGame() external payable returns (bool);
    function leaveGame() external returns (bool);
    function withdraw(Player player) external returns (bool);

    // implement game owner
    function getOwner() external view returns (address);
    function getWinner() external view returns (address);
    function payWinner() external view returns (address);

    function getAmount(address addr) external view returns (uint256);

}


interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}