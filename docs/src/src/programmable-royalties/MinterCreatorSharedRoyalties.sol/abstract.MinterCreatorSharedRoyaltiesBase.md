# MinterCreatorSharedRoyaltiesBase
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/programmable-royalties/MinterCreatorSharedRoyalties.sol)

**Inherits:**
IERC2981, ERC165

**Author:**
Limit Break, Inc.

*Base functionality of an NFT mix-in contract implementing programmable royalties.  Royalties are shared between creators and minters.*


## State Variables
### FEE_DENOMINATOR

```solidity
uint256 public constant FEE_DENOMINATOR = 10_000;
```


### _royaltyFeeNumerator

```solidity
uint256 private _royaltyFeeNumerator;
```


### _minterShares

```solidity
uint256 private _minterShares;
```


### _creatorShares

```solidity
uint256 private _creatorShares;
```


### _creator

```solidity
address private _creator;
```


### _paymentSplitterReference

```solidity
address private _paymentSplitterReference;
```


### _minters

```solidity
mapping(uint256 => address) private _minters;
```


### _paymentSplitters

```solidity
mapping(uint256 => address) private _paymentSplitters;
```


### _minterPaymentSplitters

```solidity
mapping(address => address[]) private _minterPaymentSplitters;
```


## Functions
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


### royaltyFeeNumerator


```solidity
function royaltyFeeNumerator() public view virtual returns (uint256);
```

### minterShares


```solidity
function minterShares() public view virtual returns (uint256);
```

### creatorShares


```solidity
function creatorShares() public view virtual returns (uint256);
```

### creator


```solidity
function creator() public view virtual returns (address);
```

### paymentSplitterReference


```solidity
function paymentSplitterReference() public view virtual returns (address);
```

### royaltyInfo

Returns the royalty fee and recipient for a given token.


```solidity
function royaltyInfo(uint256 tokenId, uint256 salePrice) external view override returns (address, uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`uint256`|  The id of the token whose royalty info is being queried.|
|`salePrice`|`uint256`|The sale price of the token.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The royalty fee and recipient for a given token.|
|`<none>`|`uint256`||


### minterOf

Returns the minter of the token with id `tokenId`.


```solidity
function minterOf(uint256 tokenId) external view returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`uint256`| The id of the token whose minter is being queried.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The minter of the token with id `tokenId`.|


### paymentSplitterOf

Returns the payment splitter of the token with id `tokenId`.


```solidity
function paymentSplitterOf(uint256 tokenId) external view returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`uint256`| The id of the token whose payment splitter is being queried.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The payment splitter of the token with id `tokenId`.|


### paymentSplittersOfMinter

Returns the payment splitters of the minter `minter`.


```solidity
function paymentSplittersOfMinter(address minter) external view returns (address[] memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`minter`|`address`| The minter whose payment splitters are being queried.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address[]`|The payment splitters of the minter `minter`.|


### releasableNativeFunds

Returns the amount of native funds that can be released to the minter or creator of the token with id `tokenId`.


```solidity
function releasableNativeFunds(uint256 tokenId, ReleaseTo releaseTo) external view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`uint256`|  The id of the token whose releasable funds are being queried.|
|`releaseTo`|`ReleaseTo`|Specifies whether the minter or creator should be queried.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The amount of native funds that can be released to the minter or creator of the token with id `tokenId`.|


### releasableERC20Funds

Returns the amount of ERC20 funds that can be released to the minter or creator of the token with id `tokenId`.


```solidity
function releasableERC20Funds(uint256 tokenId, address coin, ReleaseTo releaseTo) external view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`uint256`|  The id of the token whose releasable funds are being queried.|
|`coin`|`address`|     The address of the ERC20 token whose releasable funds are being queried.|
|`releaseTo`|`ReleaseTo`|Specifies whether the minter or creator should be queried.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The amount of ERC20 funds that can be released to the minter or creator of the token with id `tokenId`.|


### releaseNativeFunds

Releases all available native funds to the minter or creator of the token with id `tokenId`.


```solidity
function releaseNativeFunds(uint256 tokenId, ReleaseTo releaseTo) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`uint256`|  The id of the token whose funds are being released.|
|`releaseTo`|`ReleaseTo`|Specifies whether the minter or creator should be released to.|


### releaseERC20Funds

Releases all available ERC20 funds to the minter or creator of the token with id `tokenId`.


```solidity
function releaseERC20Funds(uint256 tokenId, address coin, ReleaseTo releaseTo) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`uint256`|  The id of the token whose funds are being released.|
|`coin`|`address`|     The address of the ERC20 token whose funds are being released.|
|`releaseTo`|`ReleaseTo`|Specifies whether the minter or creator should be released to.|


### _onMinted

*Internal function that must be called when a token is minted.
Creates a payment splitter for the minter and creator of the token to share royalties.*


```solidity
function _onMinted(address minter, uint256 tokenId) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`minter`|`address`| The minter of the token.|
|`tokenId`|`uint256`|The id of the token that was minted.|


### _onBurned

*Internal function that must be called when a token is burned.
Deletes the payment splitter mapping and minter mapping for the token in case it is ever re-minted.*


```solidity
function _onBurned(uint256 tokenId) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`uint256`|The id of the token that was burned.|


### _createPaymentSplitter

*Internal function that creates a payment splitter for the minter and creator of the token to share royalties.*


```solidity
function _createPaymentSplitter(address minter) private returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`minter`|`address`|The minter of the token.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The address of the payment splitter.|


### _getPaymentSplitterForTokenOrRevert

*Gets the payment splitter for the specified token id or reverts if it does not exist.*


```solidity
function _getPaymentSplitterForTokenOrRevert(uint256 tokenId) private view returns (IPaymentSplitterInitializable);
```

### _setRoyaltyFeeNumeratorAndShares


```solidity
function _setRoyaltyFeeNumeratorAndShares(
    uint256 royaltyFeeNumerator_,
    uint256 minterShares_,
    uint256 creatorShares_,
    address creator_,
    address paymentSplitterReference_
) internal;
```

## Errors
### MinterCreatorSharedRoyalties__CreatorCannotBeZeroAddress

```solidity
error MinterCreatorSharedRoyalties__CreatorCannotBeZeroAddress();
```

### MinterCreatorSharedRoyalties__CreatorSharesCannotBeZero

```solidity
error MinterCreatorSharedRoyalties__CreatorSharesCannotBeZero();
```

### MinterCreatorSharedRoyalties__MinterCannotBeZeroAddress

```solidity
error MinterCreatorSharedRoyalties__MinterCannotBeZeroAddress();
```

### MinterCreatorSharedRoyalties__MinterHasAlreadyBeenAssignedToTokenId

```solidity
error MinterCreatorSharedRoyalties__MinterHasAlreadyBeenAssignedToTokenId();
```

### MinterCreatorSharedRoyalties__MinterSharesCannotBeZero

```solidity
error MinterCreatorSharedRoyalties__MinterSharesCannotBeZero();
```

### MinterCreatorSharedRoyalties__PaymentSplitterDoesNotExistForSpecifiedTokenId

```solidity
error MinterCreatorSharedRoyalties__PaymentSplitterDoesNotExistForSpecifiedTokenId();
```

### MinterCreatorSharedRoyalties__PaymentSplitterReferenceCannotBeZeroAddress

```solidity
error MinterCreatorSharedRoyalties__PaymentSplitterReferenceCannotBeZeroAddress();
```

### MinterCreatorSharedRoyalties__RoyaltyFeeWillExceedSalePrice

```solidity
error MinterCreatorSharedRoyalties__RoyaltyFeeWillExceedSalePrice();
```

## Enums
### ReleaseTo

```solidity
enum ReleaseTo {
    Minter,
    Creator
}
```

