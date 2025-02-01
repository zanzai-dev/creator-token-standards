# ERC20CWPermanent
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/erc20c/presets/ERC20CWPermanent.sol)

**Inherits:**
[ERC20CW](/src/erc20c/extensions/ERC20CW.sol/abstract.ERC20CW.md)

**Author:**
Limit Break, Inc.

Extension of ERC20CW that permanently stakes the wrapped token.


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
### ERC20CWPermanent__UnstakeIsNotPermitted

```solidity
error ERC20CWPermanent__UnstakeIsNotPermitted();
```

