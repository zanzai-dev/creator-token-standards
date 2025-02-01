# ERC1155CWPermanent
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/erc1155c/presets/ERC1155CWPermanent.sol)

**Inherits:**
[ERC1155CW](/src/erc1155c/extensions/ERC1155CW.sol/abstract.ERC1155CW.md)

**Author:**
Limit Break, Inc.

Extension of ERC1155CW that permanently stakes the wrapped token.


## Functions
### canUnstake

Permanent Creator Tokens Are Never Unstakeable


```solidity
function canUnstake(uint256, uint256) public view virtual override returns (bool);
```

### _onUnstake

*Reverts on any attempt to unstake.*


```solidity
function _onUnstake(uint256, uint256, uint256) internal virtual override;
```

## Errors
### ERC1155CWPermanent__UnstakeIsNotPermitted

```solidity
error ERC1155CWPermanent__UnstakeIsNotPermitted();
```

