// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Bageltoken is ERC20, Ownable {
    constructor() ERC20("Bagel", "BAGL") Ownable(msg.sender) {}

    function mint(address to, uint128 amount) external {
        _mint(to, amount);
    }
}