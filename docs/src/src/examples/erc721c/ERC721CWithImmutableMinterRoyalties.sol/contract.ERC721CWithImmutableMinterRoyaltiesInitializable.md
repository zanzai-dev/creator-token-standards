# ERC721CWithImmutableMinterRoyaltiesInitializable
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/examples/erc721c/ERC721CWithImmutableMinterRoyalties.sol)

**Inherits:**
[OwnableInitializable](/src/access/OwnableInitializable.sol/abstract.OwnableInitializable.md), [ERC721CInitializable](/src/erc721c/ERC721C.sol/abstract.ERC721CInitializable.md), [ImmutableMinterRoyaltiesInitializable](/src/programmable-royalties/ImmutableMinterRoyalties.sol/abstract.ImmutableMinterRoyaltiesInitializable.md)

**Author:**
Limit Break, Inc.

Initializable extension of ERC721C that allows for minters to receive royalties on the tokens they mint.
The royalty fee is immutable and set at contract creation.  Allows for EIP-1167 clones.


## Functions
### constructor


```solidity
constructor() ERC721("", "");
```

### supportsInterface


```solidity
function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override(ERC721CInitializable, ImmutableMinterRoyaltiesBase)
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

