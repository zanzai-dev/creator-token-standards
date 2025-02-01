# ERC20CW
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/erc20c/extensions/ERC20CW.sol)

**Inherits:**
[ERC20WrapperBase](/src/erc20c/extensions/ERC20CW.sol/abstract.ERC20WrapperBase.md), [ERC20C](/src/erc20c/ERC20C.sol/abstract.ERC20C.md)

**Author:**
Limit Break, Inc.

Constructable ERC20C Wrapper Contract implementation


## State Variables
### wrappedCollectionImmutable

```solidity
IERC20 private immutable wrappedCollectionImmutable;
```


## Functions
### constructor


```solidity
constructor(address wrappedCollectionAddress_);
```

### supportsInterface


```solidity
function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool);
```

### getWrappedCollectionAddress


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

