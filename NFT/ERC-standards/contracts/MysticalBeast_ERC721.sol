// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MythicalBeast is ERC721, ERC721Enumerable, Pausable, Ownable {
    using Counters for Counters.Counter;
    uint maxSupply = 100;

    bool public publicMintOpen = false;
    bool public allowListMintOpen = false;

    mapping(address => bool) public allowList;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("MythicalBeast", "MYB") {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://Qmaa6TuP2s9pSKczHF4rwWhTKUdygrrDs8RmYYqCjP3Hye/";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    // Modify the mint windows
    function editMintWindows(
        bool _publicMintOpen, bool _allowListMintOpen
    ) external onlyOwner{
        publicMintOpen = _publicMintOpen;
        allowListMintOpen = _allowListMintOpen;
    }

    // Allowlist Mint
    function allowListMint() public payable{
        require(allowListMintOpen, "Allowlist Mint closed!");
        require(allowList[msg.sender], "You are not in the allowlist");
        require(msg.value == 0.001 ether, "Not enough funds");
        internalMint();
    }

    // Add payments
    // Add limited supply
    function publicMint() public payable{
        require(publicMintOpen, "Public Mint closed!");
        require(msg.value == 0.01 ether, "Not enough funds");
        internalMint();
    }

    // Populate the allow list
    function setAllowList(address[] calldata addresses) external onlyOwner{
        for(uint i = 0; i < addresses.length; i++){
            allowList[addresses[i]] = true;
        }
    }

    // Withdraw
    function withdraw(address _addr) external onlyOwner {
        // get the balance of the contract
        uint balance = address(this).balance;
        payable(_addr).transfer(balance);
    }

    function internalMint() internal {
        require(totalSupply() < maxSupply, "No more tokens!");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}