# AirdropMintBase
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/minting/AirdropMint.sol)

**Inherits:**
[MaxSupplyBase](/src/minting/MaxSupply.sol/abstract.MaxSupplyBase.md)

**Author:**
Limit Break, Inc.

Base functionality of a contract mix-in that may optionally be used with extend ERC-721 tokens with airdrop minting capabilities.

*Inheriting contracts must implement `_mintToken`.*


## State Variables
### _remainingAirdropSupply
*The current amount of tokens mintable via airdrop.*


```solidity
uint256 private _remainingAirdropSupply;
```


## Functions
### airdropMint

Owner bulk mint to airdrop.
Throws if length of `to` array is zero.
Throws if minting batch would exceed the max supply.


```solidity
function airdropMint(address[] calldata to) external;
```

### remainingAirdropSupply

Returns the remaining amount of tokens mintable via airdrop


```solidity
function remainingAirdropSupply() public view returns (uint256);
```

### _setMaxAirdropSupply


```solidity
function _setMaxAirdropSupply(uint256 maxAirdropMints_) internal;
```

## Errors
### AirdropMint__AirdropBatchSizeMustBeGreaterThanZero

```solidity
error AirdropMint__AirdropBatchSizeMustBeGreaterThanZero();
```

### AirdropMint__CannotMintToZeroAddress

```solidity
error AirdropMint__CannotMintToZeroAddress();
```

### AirdropMint__MaxAirdropSupplyCannotBeSetToMaxUint256

```solidity
error AirdropMint__MaxAirdropSupplyCannotBeSetToMaxUint256();
```

### AirdropMint__MaxAirdropSupplyCannotBeSetToZero

```solidity
error AirdropMint__MaxAirdropSupplyCannotBeSetToZero();
```

### AirdropMint__MaxAirdropSupplyExceeded

```solidity
error AirdropMint__MaxAirdropSupplyExceeded();
```

