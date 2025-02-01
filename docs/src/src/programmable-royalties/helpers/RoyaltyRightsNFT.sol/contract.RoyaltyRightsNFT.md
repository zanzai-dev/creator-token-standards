# RoyaltyRightsNFT
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/programmable-royalties/helpers/RoyaltyRightsNFT.sol)

**Inherits:**
ERC721, [ICloneableRoyaltyRightsERC721](/src/programmable-royalties/helpers/ICloneableRoyaltyRightsERC721.sol/interface.ICloneableRoyaltyRightsERC721.md)


## State Variables
### collection

```solidity
IERC721Metadata public collection;
```


## Functions
### constructor

*Empty constructor so that it can be cloned and initialized by the real collection.*


```solidity
constructor() ERC721("", "");
```

### initializeAndBindToCollection


```solidity
function initializeAndBindToCollection() external override;
```

### mint


```solidity
function mint(address to, uint256 tokenId) external override;
```

### burn


```solidity
function burn(uint256 tokenId) external override;
```

### name


```solidity
function name() public view virtual override returns (string memory);
```

### symbol


```solidity
function symbol() public view virtual override returns (string memory);
```

### tokenURI

Returns the token URI from the linked collection so that users can view
the image and details of the NFT associated with these royalty rights.


```solidity
function tokenURI(uint256 tokenId) public view virtual override returns (string memory);
```

## Errors
### RoyaltyRightsNFT__CollectionAlreadyInitialized

```solidity
error RoyaltyRightsNFT__CollectionAlreadyInitialized();
```

### RoyaltyRightsNFT__OnlyBurnableFromCollection

```solidity
error RoyaltyRightsNFT__OnlyBurnableFromCollection();
```

### RoyaltyRightsNFT__OnlyMintableFromCollection

```solidity
error RoyaltyRightsNFT__OnlyMintableFromCollection();
```

