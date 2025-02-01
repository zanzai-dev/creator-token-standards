# ImmutableMinterRoyaltiesInitializable
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/programmable-royalties/ImmutableMinterRoyalties.sol)

**Inherits:**
[OwnablePermissions](/src/access/OwnablePermissions.sol/abstract.OwnablePermissions.md), [ImmutableMinterRoyaltiesBase](/src/programmable-royalties/ImmutableMinterRoyalties.sol/abstract.ImmutableMinterRoyaltiesBase.md)

**Author:**
Limit Break, Inc.

Initializable ImmutableMinterRoyalties Contract implementation to allow for EIP-1167 clones.


## State Variables
### _minterRoyaltyFeeInitialized

```solidity
bool private _minterRoyaltyFeeInitialized;
```


## Functions
### initializeMinterRoyaltyFee


```solidity
function initializeMinterRoyaltyFee(uint256 royaltyFeeNumerator_) public;
```

## Errors
### ImmutableMinterRoyaltiesInitializable__MinterRoyaltyFeeAlreadyInitialized

```solidity
error ImmutableMinterRoyaltiesInitializable__MinterRoyaltyFeeAlreadyInitialized();
```

