# AdventureERC721CW
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/erc721c/extensions/AdventureERC721CW.sol)

**Inherits:**
[ERC721WrapperBase](/src/erc721c/extensions/ERC721CW.sol/abstract.ERC721WrapperBase.md), [AdventureERC721C](/src/erc721c/AdventureERC721C.sol/abstract.AdventureERC721C.md)

**Author:**
Limit Break, Inc.

Extends AdventureERC721-C contracts and adds a staking feature used to wrap another ERC721 contract.
The wrapper token gives the developer access to the same set of controls present in the ERC721-C standard.
in addition to Limit Break's AdventureERC721 staking features.
Holders opt-in to this contract by staking, and it is possible for holders to unstake at the developers' discretion.
The intent of this contract is to allow developers to upgrade existing NFT collections and provide enhanced features.

Creators also have discretion to set optional staker constraints should they wish to restrict staking to
EOA accounts only.


## State Variables
### wrappedCollectionImmutable
*Points to an external ERC721 contract that will be wrapped via staking.*


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

