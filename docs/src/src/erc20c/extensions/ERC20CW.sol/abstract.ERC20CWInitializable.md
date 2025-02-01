# ERC20CWInitializable
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/erc20c/extensions/ERC20CW.sol)

**Inherits:**
[ERC20WrapperBase](/src/erc20c/extensions/ERC20CW.sol/abstract.ERC20WrapperBase.md), [ERC20CInitializable](/src/erc20c/ERC20C.sol/abstract.ERC20CInitializable.md)

**Author:**
Limit Break, Inc.

Initializable ERC20C Wrapper Contract implementation to allow for EIP-1167 clones.


## State Variables
### wrappedCollection
*Points to an external ERC20 contract that will be wrapped via staking.*


```solidity
IERC20 private wrappedCollection;
```


### _wrappedCollectionInitialized

```solidity
bool private _wrappedCollectionInitialized;
```


## Functions
### initializeWrappedCollectionAddress


```solidity
function initializeWrappedCollectionAddress(address wrappedCollectionAddress_) public;
```

### supportsInterface


```solidity
function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool);
```

### getWrappedCollectionAddress

Returns the address of the wrapped ERC20 contract.


```solidity
function getWrappedCollectionAddress() public view virtual override returns (address);
```

### _requireAccountIsVerifiedEOA


```solidity
function _requireAccountIsVerifiedEOA(address account) internal view virtual override;
```

### _doTokenMint


```solidity
function _doTokenMint(address to, uint256 amount) internal virtual override;
```

### _doTokenBurn


```solidity
function _doTokenBurn(address from, uint256 amount) internal virtual override;
```

### _getBalanceOf


```solidity
function _getBalanceOf(address account) internal view virtual override returns (uint256);
```

## Errors
### ERC20CWInitializable__AlreadyInitializedWrappedCollection

```solidity
error ERC20CWInitializable__AlreadyInitializedWrappedCollection();
```

