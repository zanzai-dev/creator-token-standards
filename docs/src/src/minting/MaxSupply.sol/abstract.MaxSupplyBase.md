# MaxSupplyBase
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/minting/MaxSupply.sol)

**Inherits:**
[OwnablePermissions](/src/access/OwnablePermissions.sol/abstract.OwnablePermissions.md), [MintTokenBase](/src/minting/MintTokenBase.sol/abstract.MintTokenBase.md), [SequentialMintBase](/src/minting/SequentialMintBase.sol/abstract.SequentialMintBase.md)

**Author:**
Limit Break, Inc.

In order to support multiple contracts with a global maximum supply, the max supply has been moved to this base contract.

*Inheriting contracts must implement `_mintToken`.*


## State Variables
### _maxSupply
*The global maximum supply for a contract.  Inheriting contracts must reference this maximum supply in addition to any other*

*constraints they are looking to enforce.*

*If `_maxSupply` is set to zero, the global max supply will match the combined max allowable mints for each minting mix-in used.*

*If the `_maxSupply` is below the total sum of allowable mints, the `_maxSupply` will be prioritized.*


```solidity
uint256 private _maxSupply;
```


### _remainingOwnerMints
*The number of tokens remaining to mint via owner mint.*

*This can be used to guarantee minting out by allowing the owner to mint unclaimed supply after the public mint is completed.*


```solidity
uint256 private _remainingOwnerMints;
```


## Functions
### ownerMint

Mints the specified quantity to the provided address
Throws when the caller is not the owner
Throws when provided quantity is zero
Throws when provided address is address zero
Throws if the quantity minted plus amount already minted exceeds the maximum amount mintable by the owner


```solidity
function ownerMint(address to, uint256 quantity) external;
```

### maxSupply


```solidity
function maxSupply() public view virtual returns (uint256);
```

### remainingOwnerMints


```solidity
function remainingOwnerMints() public view returns (uint256);
```

### mintedSupply


```solidity
function mintedSupply() public view returns (uint256);
```

### _setMaxSupplyAndOwnerMints


```solidity
function _setMaxSupplyAndOwnerMints(uint256 maxSupply_, uint256 maxOwnerMints_) internal;
```

### _requireLessThanMaxSupply


```solidity
function _requireLessThanMaxSupply(uint256 supplyAfterMint) internal view;
```

### _mintBatch

*Batch mints the specified quantity to the specified address
Throws if quantity is zero
Throws if `to` is a smart contract that does not implement IERC721 receiver*


```solidity
function _mintBatch(address to, uint256 quantity) internal returns (uint256 startTokenId, uint256 endTokenId);
```

## Events
### MaxSupplyInitialized
*Emitted when the maximum supply is initialized*


```solidity
event MaxSupplyInitialized(uint256 maxSupply, uint256 maxOwnerMints);
```

## Errors
### MaxSupplyBase__CannotClaimMoreThanMaximumAmountOfOwnerMints

```solidity
error MaxSupplyBase__CannotClaimMoreThanMaximumAmountOfOwnerMints();
```

### MaxSupplyBase__CannotMintToAddressZero

```solidity
error MaxSupplyBase__CannotMintToAddressZero();
```

### MaxSupplyBase__MaxSupplyCannotBeSetToMaxUint256

```solidity
error MaxSupplyBase__MaxSupplyCannotBeSetToMaxUint256();
```

### MaxSupplyBase__MaxSupplyExceeded

```solidity
error MaxSupplyBase__MaxSupplyExceeded();
```

### MaxSupplyBase__MintedQuantityMustBeGreaterThanZero

```solidity
error MaxSupplyBase__MintedQuantityMustBeGreaterThanZero();
```

