# MutableMinterRoyalties
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/programmable-royalties/MutableMinterRoyalties.sol)

**Inherits:**
[MutableMinterRoyaltiesBase](/src/programmable-royalties/MutableMinterRoyalties.sol/abstract.MutableMinterRoyaltiesBase.md)

**Author:**
Limit Break, Inc.

Constructable MutableMinterRoyalties Contract implementation.


## State Variables
### _defaultRoyaltyFeeNumeratorImmutable

```solidity
uint96 private immutable _defaultRoyaltyFeeNumeratorImmutable;
```


## Functions
### constructor


```solidity
constructor(uint96 defaultRoyaltyFeeNumerator_);
```

### defaultRoyaltyFeeNumerator


```solidity
function defaultRoyaltyFeeNumerator() public view override returns (uint96);
```

