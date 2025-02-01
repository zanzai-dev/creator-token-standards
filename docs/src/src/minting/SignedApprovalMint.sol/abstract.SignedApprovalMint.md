# SignedApprovalMint
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/minting/SignedApprovalMint.sol)

**Inherits:**
[SignedApprovalMintBase](/src/minting/SignedApprovalMint.sol/abstract.SignedApprovalMintBase.md), [MaxSupply](/src/minting/MaxSupply.sol/abstract.MaxSupply.md)

**Author:**
Limit Break, Inc.

Constructable SignedApprovalMint Contract implementation.


## Functions
### constructor


```solidity
constructor(address signer_, uint256 maxSignedMints_);
```

### maxSupply


```solidity
function maxSupply() public view override(MaxSupplyBase, MaxSupply) returns (uint256);
```

