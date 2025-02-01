# OwnableInitializable
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/access/OwnableInitializable.sol)

**Inherits:**
[OwnablePermissions](/src/access/OwnablePermissions.sol/abstract.OwnablePermissions.md), Ownable


## State Variables
### _ownerInitialized

```solidity
bool private _ownerInitialized;
```


## Functions
### initializeOwner

*When EIP-1167 is used to clone a contract that inherits Ownable permissions,
this is required to assign the initial contract owner, as the constructor is
not called during the cloning process.*


```solidity
function initializeOwner(address owner_) public;
```

### renounceOwnership


```solidity
function renounceOwnership() public override;
```

### _requireCallerIsContractOwner


```solidity
function _requireCallerIsContractOwner() internal view virtual override;
```

## Errors
### InitializableOwnable__OwnerAlreadyInitialized

```solidity
error InitializableOwnable__OwnerAlreadyInitialized();
```

