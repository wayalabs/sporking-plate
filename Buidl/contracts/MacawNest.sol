// SPDX-License-Identifier: MIT

import "openzeppelin-solidity/contracts/token/ERC721/SafeERC721.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "ethereum-wand/contracts/WandERC721Receiver.sol";

pragma solidity ^0.6.04;

struct IncubatorToken {
  uint256 id;
  string name;
  string symbol;
  uint256 value;
  uint256 expiration;
}

IncubatorToken[]  public incubatorTokens;

mapping(uint256 => address) public incubatorTokenOwner;

contract MacawNest is SafeERC721, WandERC721Receiver {
  using SafeMath for uint256;

  // Inherit from the SafeERC721 contract and implement the required functions
  function balanceOf(address owner) public view returns (uint256) {
    return incubatorTokenOwner.count(owner);
  }

  function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
    return incubatorTokenOwner.get(owner, index);
  }

  function ownerOf(uint256 tokenId) public view returns (address) {
    return incubatorTokenOwner[tokenId];
  }

  function isApprovedOrOwner(address spender, uint256 tokenId) public view returns (bool) {
    return spender == ownerOf(tokenId) || approved[tokenId] == spender;
  }
}

// Creates a function to mint new incubator tokens 
function mint(string memory _name, string memory _symbol, uint256 _value, uint256 _expiration) public {
    uint256 id = incubatorTokens.length + 1;
    address owner = msg.sender;

    incubatorTokens.push(IncubatorToken(id, _name, _symbol, _value, _expiration));
    incubatorTokenOwner[id] = owner;

  emit Transfer(address(0), owner, id);
}

// Creates a function to allow holders of incubator tokens to redeem them for a regular ERC-721 token
function redeem(uint256 tokenId) public {
    IncubatorToken storage incubatorToken = incubatorTokens[tokenId - 1];
      require(incubatorToken.expiration > now, "Token has expired");
      require(incubatorToken.value <= msg.value, "Insufficient value");

  address owner = incubatorTokenOwner
}
