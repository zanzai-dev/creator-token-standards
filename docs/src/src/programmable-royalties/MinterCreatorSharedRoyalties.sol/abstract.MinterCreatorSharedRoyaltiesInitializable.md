# MinterCreatorSharedRoyaltiesInitializable
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/programmable-royalties/MinterCreatorSharedRoyalties.sol)

**Inherits:**
[OwnablePermissions](/src/access/OwnablePermissions.sol/abstract.OwnablePermissions.md), [MinterCreatorSharedRoyaltiesBase](/src/programmable-royalties/MinterCreatorSharedRoyalties.sol/abstract.MinterCreatorSharedRoyaltiesBase.md)

**Author:**
Limit Break, Inc.

Initializable MinterCreatorSharedRoyalties Contract implementation to allow for EIP-1167 clones.


## State Variables
### _royaltyFeeAndSharesInitialized

```solidity
bool private _royaltyFeeAndSharesInitialized;
```


## Functions
### initializeMinterRoyaltyFee


```solidity
function initializeMinterRoyaltyFee(
    uint256 royaltyFeeNumerator_,
    uint256 minterShares_,
    uint256 creatorShares_,
    address creator_,
    address paymentSplitterReference_
) public;
```

## Errors
### MinterCreatorSharedRoyaltiesInitializable__RoyaltyFeeAndSharesAlreadyInitialized

```solidity
error MinterCreatorSharedRoyaltiesInitializable__RoyaltyFeeAndSharesAlreadyInitialized();
```

