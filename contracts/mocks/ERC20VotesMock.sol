// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../token/ERC20/extensions/ERC20Votes.sol";

contract ERC20VotesMock is ERC20Votes {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) EIP712(name, "1") {}

    function mint(address account, uint256 amount) public {
        _transfer(address(0), account, amount);
    }

    function burn(address account, uint256 amount) public {
        _transfer(account, address(0), amount);
    }

    function getChainId() external view returns (uint256) {
        return block.chainid;
    }
}
