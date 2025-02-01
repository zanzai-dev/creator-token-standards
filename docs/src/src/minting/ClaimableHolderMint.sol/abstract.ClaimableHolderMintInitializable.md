# ClaimableHolderMintInitializable
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/minting/ClaimableHolderMint.sol)

**Inherits:**
[ClaimableHolderMintBase](/src/minting/ClaimableHolderMint.sol/abstract.ClaimableHolderMintBase.md), [MaxSupplyInitializable](/src/minting/MaxSupply.sol/abstract.MaxSupplyInitializable.md)

**Author:**
Limit Break, Inc.

Initializable ClaimableHolderMint Contract implementation to allow for EIP-1167 clones.


## State Variables
### _rootCollectionsInitialized
*Flag indicating that the root collections have been initialized.*


```solidity
bool private _rootCollectionsInitialized;
```


## Functions
### initializeRootCollections


```solidity
function initializeRootCollections(
    address[] memory rootCollections_,
    uint256[] memory rootCollectionMaxSupplies_,
    uint256[] memory tokensPerClaimArray_
) public;
```

## Errors
### ClaimableHolderMintInitializable__RootCollectionsAlreadyInitialized

```solidity
error ClaimableHolderMintInitializable__RootCollectionsAlreadyInitialized();
```

