# MutableMinterRoyaltiesBase
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/programmable-royalties/MutableMinterRoyalties.sol)

**Inherits:**
IERC2981, ERC165

**Author:**
Limit Break, Inc.

*Base functionality of an NFT mix-in contract implementing programmable royalties for minters, allowing the minter of each token ID to
update the royalty fee percentage.*


## State Variables
### FEE_DENOMINATOR

```solidity
uint96 public constant FEE_DENOMINATOR = 10_000;
```


### _defaultRoyaltyFeeNumerator

```solidity
uint96 private _defaultRoyaltyFeeNumerator;
```


### _tokenRoyaltyInfo

```solidity
mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
```


## Functions
### setRoyaltyFee

Allows the minter to update the royalty fee percentage for a specific token ID.

*The caller must be the minter of the specified token ID.*

*Throws when royaltyFeeNumerator is greater than FEE_DENOMINATOR*

*Throws when the caller is not the minter of the specified token ID*


```solidity
function setRoyaltyFee(uint256 tokenId, uint96 royaltyFeeNumerator) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`uint256`|The token ID|
|`royaltyFeeNumerator`|`uint96`|The new royalty fee numerator|


### supportsInterface

Indicates whether the contract implements the specified interface.

*Overrides supportsInterface in ERC165.*


```solidity
function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`interfaceId`|`bytes4`|The interface id|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|true if the contract implements the specified interface, false otherwise|


### defaultRoyaltyFeeNumerator


```solidity
function defaultRoyaltyFeeNumerator() public view virtual returns (uint96);
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

*Sets the minter's address and royalty fraction for the specified token ID in the _tokenRoyaltyInfo mapping
when a new token is minted.*

*Throws when minter is the zero address*

*Throws when the minter has already been assigned to the specified token ID*


```solidity
function _onMinted(address minter, uint256 tokenId) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`minter`|`address`|The address of the minter|
|`tokenId`|`uint256`|The token ID|


### _onBurned

*Removes the royalty information from the _tokenRoyaltyInfo mapping for the specified token ID when a token
is burned.*


```solidity
function _onBurned(uint256 tokenId) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`uint256`|The token ID|


### _setDefaultRoyaltyFee


```solidity
function _setDefaultRoyaltyFee(uint96 defaultRoyaltyFeeNumerator_) internal;
```

## Events
### RoyaltySet
*Emitted when royalty is set.*


```solidity
event RoyaltySet(uint256 indexed tokenId, address indexed receiver, uint96 feeNumerator);
```

## Errors
### MutableMinterRoyalties__MinterCannotBeZeroAddress

```solidity
error MutableMinterRoyalties__MinterCannotBeZeroAddress();
```

### MutableMinterRoyalties__MinterHasAlreadyBeenAssignedToTokenId

```solidity
error MutableMinterRoyalties__MinterHasAlreadyBeenAssignedToTokenId();
```

### MutableMinterRoyalties__OnlyMinterCanChangeRoyaltyFee

```solidity
error MutableMinterRoyalties__OnlyMinterCanChangeRoyaltyFee();
```

### MutableMinterRoyalties__RoyaltyFeeWillExceedSalePrice

```solidity
error MutableMinterRoyalties__RoyaltyFeeWillExceedSalePrice();
```

## Structs
### RoyaltyInfo

```solidity
struct RoyaltyInfo {
    address receiver;
    uint96 royaltyFraction;
}
```

