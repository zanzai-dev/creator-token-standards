# ClaimableHolderMint
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/minting/ClaimableHolderMint.sol)

**Inherits:**
[ClaimableHolderMintBase](/src/minting/ClaimableHolderMint.sol/abstract.ClaimableHolderMintBase.md), [MaxSupply](/src/minting/MaxSupply.sol/abstract.MaxSupply.md)

**Author:**
Limit Break, Inc.

Constructable ClaimableHolderMint Contract implementation.


## Functions
### constructor


```solidity
constructor(
    address[] memory rootCollections_,
    uint256[] memory rootCollectionMaxSupplies_,
    uint256[] memory tokensPerClaimArray_
);
```

### maxSupply


```solidity
function maxSupply() public view override(MaxSupplyBase, MaxSupply) returns (uint256);
```

