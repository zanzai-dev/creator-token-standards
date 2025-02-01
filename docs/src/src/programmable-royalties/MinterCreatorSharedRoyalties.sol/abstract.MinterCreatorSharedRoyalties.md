# MinterCreatorSharedRoyalties
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/programmable-royalties/MinterCreatorSharedRoyalties.sol)

**Inherits:**
[MinterCreatorSharedRoyaltiesBase](/src/programmable-royalties/MinterCreatorSharedRoyalties.sol/abstract.MinterCreatorSharedRoyaltiesBase.md)

**Author:**
Limit Break, Inc.

Constructable MinterCreatorSharedRoyalties Contract implementation.


## State Variables
### _royaltyFeeNumeratorImmutable

```solidity
uint256 private immutable _royaltyFeeNumeratorImmutable;
```


### _minterSharesImmutable

```solidity
uint256 private immutable _minterSharesImmutable;
```


### _creatorSharesImmutable

```solidity
uint256 private immutable _creatorSharesImmutable;
```


### _creatorImmutable

```solidity
address private immutable _creatorImmutable;
```


### _paymentSplitterReferenceImmutable

```solidity
address private immutable _paymentSplitterReferenceImmutable;
```


## Functions
### constructor

*Constructor that sets the royalty fee numerator, creator, and minter/creator shares.*

*Throws when defaultRoyaltyFeeNumerator_ is greater than FEE_DENOMINATOR*


```solidity
constructor(
    uint256 royaltyFeeNumerator_,
    uint256 minterShares_,
    uint256 creatorShares_,
    address creator_,
    address paymentSplitterReference_
);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`royaltyFeeNumerator_`|`uint256`|The royalty fee numerator|
|`minterShares_`|`uint256`| The number of shares minters get allocated in payment processors|
|`creatorShares_`|`uint256`|The number of shares creators get allocated in payment processors|
|`creator_`|`address`|      The NFT creator's royalty wallet|
|`paymentSplitterReference_`|`address`||


### royaltyFeeNumerator


```solidity
function royaltyFeeNumerator() public view override returns (uint256);
```

### minterShares


```solidity
function minterShares() public view override returns (uint256);
```

### creatorShares


```solidity
function creatorShares() public view override returns (uint256);
```

### creator


```solidity
function creator() public view override returns (address);
```

### paymentSplitterReference


```solidity
function paymentSplitterReference() public view override returns (address);
```

