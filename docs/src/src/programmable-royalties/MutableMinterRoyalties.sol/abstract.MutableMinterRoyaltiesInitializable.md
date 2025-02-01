# MutableMinterRoyaltiesInitializable
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/programmable-royalties/MutableMinterRoyalties.sol)

**Inherits:**
[OwnablePermissions](/src/access/OwnablePermissions.sol/abstract.OwnablePermissions.md), [MutableMinterRoyaltiesBase](/src/programmable-royalties/MutableMinterRoyalties.sol/abstract.MutableMinterRoyaltiesBase.md)

**Author:**
Limit Break, Inc.

Initializable MutableMinterRoyalties Contract implementation to allow for EIP-1167 clones.


## State Variables
### _defaultMinterRoyaltyFeeInitialized

```solidity
bool private _defaultMinterRoyaltyFeeInitialized;
```


## Functions
### initializeDefaultMinterRoyaltyFee


```solidity
function initializeDefaultMinterRoyaltyFee(uint96 defaultRoyaltyFeeNumerator_) public;
```

## Errors
### MutableMinterRoyaltiesInitializable__DefaultMinterRoyaltyFeeAlreadyInitialized

```solidity
error MutableMinterRoyaltiesInitializable__DefaultMinterRoyaltyFeeAlreadyInitialized();
```

