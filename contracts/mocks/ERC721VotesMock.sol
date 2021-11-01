// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../token/ERC721/extensions/ERC721Votes.sol";

contract ERC721VotesMock is ERC721Votes {
    constructor(string memory name, string memory symbol) ERC721(name, symbol) ERC721Permit(name) {}

    function mint(address account, uint256 tokenId) public {
        _mint(account, tokenId);
    }

    function burn(uint256 tokenId) public {
        _burn(tokenId);
    }

    function getChainId() external view returns (uint256) {
        return block.chainid;
    }

    function _maxSupply() internal pure override returns(uint224){
        return uint224(4);
    }
}