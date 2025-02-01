# MaxSupplyInitializable
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/minting/MaxSupply.sol)

**Inherits:**
[MaxSupplyBase](/src/minting/MaxSupply.sol/abstract.MaxSupplyBase.md)

**Author:**
Limit Break, Inc.

Initializable implementation of the MaxSupplyBase mixin to allow for EIP-1167 clones.


## State Variables
### _maxSupplyInitialized
*Boolean value set during initialization to prevent reinitializing the value.*


```solidity
bool private _maxSupplyInitialized;
```


## Functions
### initializeMaxSupply


```solidity
function initializeMaxSupply(uint256 maxSupply_, uint256 maxOwnerMints_) external;
```

### maxSupplyInitialized


```solidity
function maxSupplyInitialized() public view returns (bool);
```

## Errors
### InitializableMaxSupplyBase__MaxSupplyAlreadyInitialized

```solidity
error InitializableMaxSupplyBase__MaxSupplyAlreadyInitialized();
```

