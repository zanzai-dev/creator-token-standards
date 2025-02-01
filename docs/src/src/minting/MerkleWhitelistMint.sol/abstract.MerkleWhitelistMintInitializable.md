# MerkleWhitelistMintInitializable
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/minting/MerkleWhitelistMint.sol)

**Inherits:**
[MerkleWhitelistMintBase](/src/minting/MerkleWhitelistMint.sol/abstract.MerkleWhitelistMintBase.md), [MaxSupplyInitializable](/src/minting/MaxSupply.sol/abstract.MaxSupplyInitializable.md)

**Author:**
Limit Break, Inc.

Initializable MerkleWhitelistMint Contract implementation to allow for EIP-1167 clones.


## State Variables
### _merkleSupplyInitialized
*Flag indicating that the merkle mint max supply has been initialized.*


```solidity
bool private _merkleSupplyInitialized;
```


## Functions
### initializeMaxMerkleMintsAndPermittedNumberOfMerkleRootChanges


```solidity
function initializeMaxMerkleMintsAndPermittedNumberOfMerkleRootChanges(
    uint256 maxMerkleMints_,
    uint256 permittedNumberOfMerkleRootChanges_
) public;
```

## Errors
### MerkleWhitelistMintInitializable__MerkleSupplyAlreadyInitialized

```solidity
error MerkleWhitelistMintInitializable__MerkleSupplyAlreadyInitialized();
```

