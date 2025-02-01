# AirdropMintInitializable
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/minting/AirdropMint.sol)

**Inherits:**
[AirdropMintBase](/src/minting/AirdropMint.sol/abstract.AirdropMintBase.md), [MaxSupplyInitializable](/src/minting/MaxSupply.sol/abstract.MaxSupplyInitializable.md)

**Author:**
Limit Break, Inc.

Initializable AirdropMint Contract implementation to allow for EIP-1167 clones.


## State Variables
### _airdropSupplyInitialized
*Flag indicating that the airdrop max supply has been initialized.*


```solidity
bool private _airdropSupplyInitialized;
```


## Functions
### initializeMaxAirdropSupply


```solidity
function initializeMaxAirdropSupply(uint256 maxAirdropMints_) public;
```

## Errors
### AirdropMintInitializable__MaxAirdropSupplyAlreadyInitialized

```solidity
error AirdropMintInitializable__MaxAirdropSupplyAlreadyInitialized();
```

