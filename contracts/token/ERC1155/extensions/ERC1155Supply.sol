// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155Supply.sol)

pragma solidity ^0.8.0;

import "../ERC1155.sol";

/**
 * @dev Extension of ERC1155 that adds tracking of total supply per id.
 *
 * Useful for scenarios where Fungible and Non-fungible tokens have to be
 * clearly identified. Note: While a totalSupply of 1 might mean the
 * corresponding is an NFT, there is no guarantees that no other token with the
 * same id are not going to be minted.
 */
abstract contract ERC1155Supply is ERC1155 {
    mapping(uint256 => uint256) private _totalSupply;
    uint256 private _totalSupplyAll;

    /**
     * @dev Total amount of tokens in with a given id.
     */
    function totalSupply(uint256 id) public view virtual returns (uint256) {
        return _totalSupply[id];
    }

    /**
     * @dev Total amount of tokens.
     */
    function totalSupply() public view virtual returns (uint256) {
        return _totalSupplyAll;
    }

    /**
     * @dev Indicates whether any token exist with a given id, or not.
     */
    function exists(uint256 id) public view virtual returns (bool) {
        return ERC1155Supply.totalSupply(id) > 0;
    }

    /**
     * @dev See {ERC1155-_update}.
     */
    function _update(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override {
        uint256 totalAmount;
        if (from == address(0)) {
            for (uint256 i = 0; i < ids.length; ++i) {
                _totalSupply[ids[i]] += amounts[i];
                totalAmount += amounts[i];
            }
            _totalSupplyAll += totalAmount;
        }

        if (to == address(0)) {
            for (uint256 i = 0; i < ids.length; ++i) {
                uint256 id = ids[i];
                uint256 amount = amounts[i];
                uint256 supply = _totalSupply[id];
                require(supply >= amount, "ERC1155: burn amount exceeds totalSupply");
                unchecked {
                    _totalSupply[id] = supply - amount;
                    totalAmount += amount;
                }
            }
            _totalSupplyAll -= totalAmount;
        }
        super._update(from, to, ids, amounts, data);
    }
}
