// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";


contract MyUpgradableToken is ERC20Upgradeable, OwnableUpgradeable, PausableUpgradeable {
 
   
    function initialize(
        string memory name,
        string memory symbol,
        uint256 totalSupply
    ) external initializer {
        __ERC20_init(name, symbol);
        __Ownable_init_unchained();
        __Pausable_init_unchained();

        _mint(msg.sender, totalSupply * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, amount);
    }
    
    
    function burn(address to, uint256 amount) external onlyOwner returns (bool) {
        _burn(to, amount);
        return true;
    }

    function pause() external onlyOwner whenNotPaused returns (bool) {
        _pause();
        return true;
    }

    function unpause() external onlyOwner whenPaused returns (bool) {
        _unpause();
        return true;
    }

}