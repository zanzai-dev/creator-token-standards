# SafeMintTokenBase
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/minting/SafeMintTokenBase.sol)

**Author:**
Limit Break, Inc.

*Standard safe mint token interface for mixins to call safe mint.*


## Functions
### _safeMintToken

*Inheriting contracts must implement the token minting logic - inheriting contract should use _safeMint, or something equivalent
The minting function should throw if `to` is address(0) or `to` is a contract that does not implement IERC721Receiver.*


```solidity
function _safeMintToken(address to, uint256 tokenId) internal virtual;
```

