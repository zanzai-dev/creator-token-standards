# MintTokenBase
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/minting/MintTokenBase.sol)

**Author:**
Limit Break, Inc.

*Standard mint token interface for mixins to mint tokens.*


## Functions
### _mintToken

*Inheriting contracts must implement the token minting logic - inheriting contract should use _mint, or something equivalent
The minting function should throw if `to` is address(0)*


```solidity
function _mintToken(address to, uint256 tokenId) internal virtual;
```

