# ERC721CWPermanent
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/erc721c/presets/ERC721CWPermanent.sol)

**Inherits:**
[ERC721CW](/src/erc721c/extensions/ERC721CW.sol/abstract.ERC721CW.md)

**Author:**
Limit Break, Inc.

Extension of ERC721CW that permanently stakes the wrapped token.


## Functions
### canUnstake

Permanent Creator Tokens Are Never Unstakeable


```solidity
function canUnstake(uint256) public view virtual override returns (bool);
```

### _onUnstake

*Reverts on any attempt to unstake.*


```solidity
function _onUnstake(uint256, uint256) internal virtual override;
```

## Errors
### ERC721CWPermanent__UnstakeIsNotPermitted

```solidity
error ERC721CWPermanent__UnstakeIsNotPermitted();
```

