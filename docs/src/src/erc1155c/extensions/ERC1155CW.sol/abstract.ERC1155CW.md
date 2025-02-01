# ERC1155CW
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/erc1155c/extensions/ERC1155CW.sol)

**Inherits:**
ERC1155Holder, [ERC1155WrapperBase](/src/erc1155c/extensions/ERC1155CW.sol/abstract.ERC1155WrapperBase.md), [ERC1155C](/src/erc1155c/ERC1155C.sol/abstract.ERC1155C.md)

**Author:**
Limit Break, Inc.

Constructable ERC1155C Wrapper Contract implementation


## State Variables
### wrappedCollectionImmutable

```solidity
IERC1155 private immutable wrappedCollectionImmutable;
```


## Functions
### constructor


```solidity
constructor(address wrappedCollectionAddress_);
```

### supportsInterface


```solidity
function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155C, ERC1155Receiver) returns (bool);
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
function _doTokenMint(address to, uint256 id, uint256 amount) internal virtual override;
```

### _doTokenBurn


```solidity
function _doTokenBurn(address from, uint256 id, uint256 amount) internal virtual override;
```

### _getBalanceOf


```solidity
function _getBalanceOf(address account, uint256 id) internal view virtual override returns (uint256);
```

