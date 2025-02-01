# ERC721CWithMinterCreatorSharedRoyalties
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/examples/erc721c/ERC721CWithMinterCreatorSharedRoyalties.sol)

**Inherits:**
[OwnableBasic](/src/access/OwnableBasic.sol/abstract.OwnableBasic.md), [ERC721C](/src/erc721c/ERC721C.sol/abstract.ERC721C.md), [MinterCreatorSharedRoyalties](/src/programmable-royalties/MinterCreatorSharedRoyalties.sol/abstract.MinterCreatorSharedRoyalties.md)

**Author:**
Limit Break, Inc.

Extension of ERC721C that allows for minters and creators to receive a split of royalties on the tokens minted.
The royalty fee and percent split is immutable and set at contract creation.

*These contracts are intended for example use and are not intended for production deployments as-is.*


## Functions
### constructor


```solidity
constructor(
    uint256 royaltyFeeNumerator_,
    uint256 minterShares_,
    uint256 creatorShares_,
    address creator_,
    address paymentSplitterReference_,
    string memory name_,
    string memory symbol_
)
    ERC721OpenZeppelin(name_, symbol_)
    MinterCreatorSharedRoyalties(royaltyFeeNumerator_, minterShares_, creatorShares_, creator_, paymentSplitterReference_);
```

### supportsInterface


```solidity
function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override(ERC721C, MinterCreatorSharedRoyaltiesBase)
    returns (bool);
```

### mint


```solidity
function mint(address to, uint256 tokenId) external;
```

### safeMint


```solidity
function safeMint(address to, uint256 tokenId) external;
```

### burn


```solidity
function burn(uint256 tokenId) external;
```

### _mint


```solidity
function _mint(address to, uint256 tokenId) internal virtual override;
```

### _burn


```solidity
function _burn(uint256 tokenId) internal virtual override;
```

