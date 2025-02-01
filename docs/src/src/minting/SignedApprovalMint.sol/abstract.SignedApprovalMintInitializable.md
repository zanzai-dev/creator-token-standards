# SignedApprovalMintInitializable
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/minting/SignedApprovalMint.sol)

**Inherits:**
[SignedApprovalMintBase](/src/minting/SignedApprovalMint.sol/abstract.SignedApprovalMintBase.md), [MaxSupplyInitializable](/src/minting/MaxSupply.sol/abstract.MaxSupplyInitializable.md)

**Author:**
Limit Break, Inc.

Initializable SignedApprovalMint Contract implementation to allow for EIP-1167 clones.


## State Variables
### _signedMintSupplyInitialized

```solidity
bool private _signedMintSupplyInitialized;
```


## Functions
### initializeSignerAndMaxSignedMintSupply


```solidity
function initializeSignerAndMaxSignedMintSupply(address signer_, uint256 maxSignedMints_) public;
```

## Errors
### SignedApprovalMintInitializable__SignedMintSupplyAlreadyInitialized

```solidity
error SignedApprovalMintInitializable__SignedMintSupplyAlreadyInitialized();
```

