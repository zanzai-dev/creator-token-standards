# MinterRoyaltiesReassignableRightsNFT
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/programmable-royalties/MinterRoyaltiesReassignableRightsNFT.sol)

**Inherits:**
IERC2981, ERC165


## State Variables
### FEE_DENOMINATOR

```solidity
uint256 public constant FEE_DENOMINATOR = 10_000;
```


### royaltyFeeNumerator

```solidity
uint256 public immutable royaltyFeeNumerator;
```


### royaltyRightsNFT

```solidity
ICloneableRoyaltyRightsERC721 public immutable royaltyRightsNFT;
```


## Functions
### constructor


```solidity
constructor(uint256 royaltyFeeNumerator_, address royaltyRightsNFTReference_);
```

### supportsInterface


```solidity
function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool);
```

### royaltyInfo


```solidity
function royaltyInfo(uint256 tokenId, uint256 salePrice)
    external
    view
    override
    returns (address receiver, uint256 royaltyAmount);
```

### _onMinted


```solidity
function _onMinted(address minter, uint256 tokenId) internal;
```

### _onBurned


```solidity
function _onBurned(uint256 tokenId) internal;
```

## Errors
### MinterRoyaltiesReassignableRightsNFT__MinterCannotBeZeroAddress

```solidity
error MinterRoyaltiesReassignableRightsNFT__MinterCannotBeZeroAddress();
```

### MinterRoyaltiesReassignableRightsNFT__RoyaltyFeeWillExceedSalePrice

```solidity
error MinterRoyaltiesReassignableRightsNFT__RoyaltyFeeWillExceedSalePrice();
```

