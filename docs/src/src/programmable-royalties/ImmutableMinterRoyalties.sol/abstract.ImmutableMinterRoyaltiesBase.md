# ImmutableMinterRoyaltiesBase
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/programmable-royalties/ImmutableMinterRoyalties.sol)

**Inherits:**
IERC2981, ERC165

**Author:**
Limit Break, Inc.

*Base functionality of an NFT mix-in contract implementing programmable royalties for minters*


## State Variables
### FEE_DENOMINATOR

```solidity
uint256 public constant FEE_DENOMINATOR = 10_000;
```


### _royaltyFeeNumerator

```solidity
uint256 private _royaltyFeeNumerator;
```


### _minters

```solidity
mapping(uint256 => address) private _minters;
```


## Functions
### supportsInterface

Indicates whether the contract implements the specified interface.

*Overrides supportsInterface in ERC165.*


```solidity
function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`interfaceId`|`bytes4`|The interface id|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|true if the contract implements the specified interface, false otherwise|


### royaltyFeeNumerator


```solidity
function royaltyFeeNumerator() public view virtual returns (uint256);
```

### royaltyInfo

Returns the royalty info for a given token ID and sale price.

*Implements the IERC2981 interface.*


```solidity
function royaltyInfo(uint256 tokenId, uint256 salePrice)
    external
    view
    override
    returns (address receiver, uint256 royaltyAmount);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`uint256`|The token ID|
|`salePrice`|`uint256`|The sale price|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`receiver`|`address`|The minter's address|
|`royaltyAmount`|`uint256`|The royalty amount|


### _onMinted

*Internal function to be called when a new token is minted.*

*Throws when the minter is the zero address.*

*Throws when a minter has already been assigned to the specified token ID.*


```solidity
function _onMinted(address minter, uint256 tokenId) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`minter`|`address`|The minter's address|
|`tokenId`|`uint256`|The token ID|


### _onBurned

*Internal function to be called when a token is burned.  Clears the minter's address.*


```solidity
function _onBurned(uint256 tokenId) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`uint256`|The token ID|


### _setRoyaltyFeeNumerator


```solidity
function _setRoyaltyFeeNumerator(uint256 royaltyFeeNumerator_) internal;
```

## Errors
### ImmutableMinterRoyalties__MinterCannotBeZeroAddress

```solidity
error ImmutableMinterRoyalties__MinterCannotBeZeroAddress();
```

### ImmutableMinterRoyalties__MinterHasAlreadyBeenAssignedToTokenId

```solidity
error ImmutableMinterRoyalties__MinterHasAlreadyBeenAssignedToTokenId();
```

### ImmutableMinterRoyalties__RoyaltyFeeWillExceedSalePrice

```solidity
error ImmutableMinterRoyalties__RoyaltyFeeWillExceedSalePrice();
```

