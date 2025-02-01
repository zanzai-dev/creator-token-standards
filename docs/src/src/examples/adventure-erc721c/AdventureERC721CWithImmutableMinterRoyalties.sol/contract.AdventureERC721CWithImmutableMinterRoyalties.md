# AdventureERC721CWithImmutableMinterRoyalties
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/examples/adventure-erc721c/AdventureERC721CWithImmutableMinterRoyalties.sol)

**Inherits:**
[OwnableBasic](/src/access/OwnableBasic.sol/abstract.OwnableBasic.md), [AdventureERC721C](/src/erc721c/AdventureERC721C.sol/abstract.AdventureERC721C.md), [ImmutableMinterRoyalties](/src/programmable-royalties/ImmutableMinterRoyalties.sol/abstract.ImmutableMinterRoyalties.md)

**Author:**
Limit Break, Inc.

Extension of AdventureERC721C that allows for minters to receive royalties on the tokens they mint.
The royalty fee is immutable and set at contract creation.

*These contracts are intended for example use and are not intended for production deployments as-is.*


## Functions
### constructor


```solidity
constructor(uint256 royaltyFeeNumerator_, uint256 maxSimultaneousQuests_, string memory name_, string memory symbol_)
    AdventureERC721(maxSimultaneousQuests_)
    ERC721OpenZeppelin(name_, symbol_)
    ImmutableMinterRoyalties(royaltyFeeNumerator_);
```

### supportsInterface


```solidity
function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override(AdventureERC721C, ImmutableMinterRoyaltiesBase)
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

