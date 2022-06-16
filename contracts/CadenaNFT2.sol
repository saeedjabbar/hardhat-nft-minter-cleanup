// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract CadenaNFT is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    uint256 public constant MAX_SUPPLY = 1000000;
    uint256 public constant MINT_PRICE = 0.001 ether;

    constructor() ERC721("CadenaNFT", "CAD") {
             // Initialize the tokenIdCounter to start 1
         _tokenIdCounter.increment();
    }
  

    function _baseURI() internal pure override returns (string memory) {
        return "";
    }

    function safeMint(address to, string memory uri) public payable  {
        require (msg.value >= MINT_PRICE, 'Transaction value did not equal the mint price!');
        require(totalSupply() < MAX_SUPPLY, "Max supply reached");

        uint256 tokenId = _tokenIdCounter.current(); 
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    //all this is coming from Ownable
    function withdrawPayments() public onlyOwner {
      payable(owner()).transfer(address(this).balance);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}