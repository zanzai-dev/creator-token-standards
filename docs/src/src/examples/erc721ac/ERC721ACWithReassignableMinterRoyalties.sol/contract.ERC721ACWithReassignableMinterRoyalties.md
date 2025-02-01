# ERC721ACWithReassignableMinterRoyalties
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/examples/erc721ac/ERC721ACWithReassignableMinterRoyalties.sol)

**Inherits:**
[OwnableBasic](/src/access/OwnableBasic.sol/abstract.OwnableBasic.md), [ERC721AC](/src/erc721c/ERC721AC.sol/abstract.ERC721AC.md), [MinterRoyaltiesReassignableRightsNFT](/src/programmable-royalties/MinterRoyaltiesReassignableRightsNFT.sol/abstract.MinterRoyaltiesReassignableRightsNFT.md)

**Author:**
Limit Break, Inc.

Extension of ERC721AC that creates a separate reassignable royalty rights NFT for each token.
The reassignable royalty rights NFT is freely tradeable, abstracting royalty rights from the token itself.

*These contracts are intended for example use and are not intended for production deployments as-is.*


## Functions
### constructor


```solidity
constructor(
    uint256 royaltyFeeNumerator_,
    address royaltyRightsNFTReference_,
    string memory name_,
    string memory symbol_
) ERC721AC(name_, symbol_) MinterRoyaltiesReassignableRightsNFT(royaltyFeeNumerator_, royaltyRightsNFTReference_);
```

### supportsInterface


```solidity
function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override(ERC721AC, MinterRoyaltiesReassignableRightsNFT)
    returns (bool);
```

### mint


```solidity
function mint(address to, uint256 quantity) external;
```

### safeMint


```solidity
function safeMint(address to, uint256 quantity) external;
```

### burn


```solidity
function burn(uint256 tokenId) external;
```

### _mint


```solidity
function _mint(address to, uint256 quantity) internal virtual override;
```

### _burn


```solidity
function _burn(uint256 tokenId) internal virtual override;
```

### _startTokenId


```solidity
function _startTokenId() internal view virtual override returns (uint256);
```

