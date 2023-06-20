// contracts/OceanToken.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract SpaceToken is ERC20Capped, ERC20Burnable {
    address payable public owner;
    uint256 public blockReward;

    /**
    Token Design
   * Initial Supply - This is the initial supply to be held with the owner of the contract
   * Capped/Max Supply - This is the total amount of tokens minted
   * Minting Strategy - These consists of the rules and mechanisms by which new tokens will be created or minted
   * Block reward - It is a primary concept related to blockchain networks that utilize POW and POS consensus algorithms...Although not commonly used as an ERC20 token..Unless that token is designed to be mined through some compatible blockchain thing
   * Burnable - It refers to the capability of destroying or permanent removing tokens from circulation
     */

    constructor(uint256 cap, uint256 reward) ERC20("SpaceToken", "SPC") ERC20Capped(cap * (10 ** decimals())) {
        owner = payable(msg.sender);
        _mint(owner, 70000000 * (10 ** decimals()));
        blockReward = reward * (10 ** decimals());
    }

    function _mint(address account, uint256 amount) internal virtual override(ERC20Capped, ERC20) {
        require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }

    function _mintMinerReward() internal {
        _mint(block.coinbase, blockReward);
    }

    function _beforeTokenTransfer(address from, address to, uint256 value) internal virtual override {
        if(from != address(0) && to != block.coinbase && block.coinbase != address(0)) {
            _mintMinerReward();
        }
        super._beforeTokenTransfer(from, to, value);
    }

    function setBlockReward(uint256 reward) public onlyOwner {
        blockReward = reward * (10 ** decimals());
    }

    // function destroy() public onlyOwner {
    //     selfdestruct(owner);
    // }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
}
