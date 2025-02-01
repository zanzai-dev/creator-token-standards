# ImmutableMinterRoyalties
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/programmable-royalties/ImmutableMinterRoyalties.sol)

**Inherits:**
[ImmutableMinterRoyaltiesBase](/src/programmable-royalties/ImmutableMinterRoyalties.sol/abstract.ImmutableMinterRoyaltiesBase.md)

**Author:**
Limit Break, Inc.

Constructable ImmutableMinterRoyalties Contract implementation.


## State Variables
### _royaltyFeeNumeratorImmutable

```solidity
uint256 private immutable _royaltyFeeNumeratorImmutable;
```


## Functions
### constructor


```solidity
constructor(uint256 royaltyFeeNumerator_);
```

### royaltyFeeNumerator


```solidity
function royaltyFeeNumerator() public view override returns (uint256);
```

