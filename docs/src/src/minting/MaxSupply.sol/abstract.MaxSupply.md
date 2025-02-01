# MaxSupply
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/minting/MaxSupply.sol)

**Inherits:**
[MaxSupplyBase](/src/minting/MaxSupply.sol/abstract.MaxSupplyBase.md)

**Author:**
Limit Break, Inc.

Constructable implementation of the MaxSupplyBase mixin.


## State Variables
### _maxSupplyImmutable

```solidity
uint256 internal immutable _maxSupplyImmutable;
```


## Functions
### constructor


```solidity
constructor(uint256 maxSupply_, uint256 maxOwnerMints_);
```

### maxSupply


```solidity
function maxSupply() public view virtual override returns (uint256);
```

