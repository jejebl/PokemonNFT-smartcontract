// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract Pokemon is ERC721URIStorage  {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721 ("Pokemon", "POKE"){
    }

    //Make the svg image
    function generateCharacter(string memory data) public pure returns(string memory){
      bytes memory svg = abi.encodePacked(data);

      return string(
          abi.encodePacked(
              "data:image/svg+xml;base64,",
              Base64.encode(svg)
          )    
      );
    }

    //Get the token URI
    function getTokenURI(uint256 tokenId, string memory data, string memory name) public pure returns (string memory){
      bytes memory dataURI = abi.encodePacked(
          '{',
            '"name": "Pokemon #', tokenId.toString(),' ', name, '",',
            '"description": "Pokemon",',
            '"image": "', generateCharacter(data), '"',
        '}'
      );
      return string(
          abi.encodePacked(
              "data:application/json;base64,",
              Base64.encode(dataURI)
          )
      );
    }

    function mint(string memory data, string memory name) public {
      _tokenIds.increment();
      uint256 newItemId = _tokenIds.current();
      _safeMint(msg.sender, newItemId);
      _setTokenURI(newItemId, getTokenURI(newItemId, data, name));
    }

    function evolve(uint256 tokenId, string memory data, string memory name) public {
      require(_exists(tokenId), "Please use an existing token");
      require(ownerOf(tokenId) == msg.sender, "You must own this token to train it");
      _setTokenURI(tokenId, getTokenURI(tokenId, data, name));
    }
}