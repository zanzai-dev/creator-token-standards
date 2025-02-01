# AirdropMint
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/minting/AirdropMint.sol)

**Inherits:**
[AirdropMintBase](/src/minting/AirdropMint.sol/abstract.AirdropMintBase.md), [MaxSupply](/src/minting/MaxSupply.sol/abstract.MaxSupply.md)

**Author:**
Limit Break, Inc.

Constructable AirdropMint Contract implementation.


## Functions
### constructor


```solidity
constructor(uint256 maxAirdropMints_);
```

### maxSupply


```solidity
function maxSupply() public view override(MaxSupplyBase, MaxSupply) returns (uint256);
```

