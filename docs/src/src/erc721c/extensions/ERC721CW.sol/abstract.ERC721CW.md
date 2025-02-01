# ERC721CW
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/erc721c/extensions/ERC721CW.sol)

**Inherits:**
[ERC721WrapperBase](/src/erc721c/extensions/ERC721CW.sol/abstract.ERC721WrapperBase.md), [ERC721C](/src/erc721c/ERC721C.sol/abstract.ERC721C.md)

**Author:**
Limit Break, Inc.

Constructable ERC721C Wrapper Contract implementation


## State Variables
### wrappedCollectionImmutable

```solidity
IERC721 private immutable wrappedCollectionImmutable;
```


## Functions
### constructor


```solidity
constructor(address wrappedCollectionAddress_);
```

### supportsInterface

Indicates whether the contract implements the specified interface.

*Overrides supportsInterface in ERC165.*


```solidity
function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`interfaceId`|`bytes4`|The interface id|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|true if the contract implements the specified interface, false otherwise|


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
function _doTokenMint(address to, uint256 tokenId) internal virtual override;
```

### _doTokenBurn


```solidity
function _doTokenBurn(uint256 tokenId) internal virtual override;
```

### _getOwnerOfToken


```solidity
function _getOwnerOfToken(uint256 tokenId) internal view virtual override returns (address);
```

### _tokenExists


```solidity
function _tokenExists(uint256 tokenId) internal view virtual override returns (bool);
```

