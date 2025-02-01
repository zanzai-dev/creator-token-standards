# ERC721ACWithMutableMinterRoyalties
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/examples/erc721ac/ERC721ACWithMutableMinterRoyalties.sol)

**Inherits:**
[OwnableBasic](/src/access/OwnableBasic.sol/abstract.OwnableBasic.md), [ERC721AC](/src/erc721c/ERC721AC.sol/abstract.ERC721AC.md), [MutableMinterRoyalties](/src/programmable-royalties/MutableMinterRoyalties.sol/abstract.MutableMinterRoyalties.md)

**Author:**
Limit Break, Inc.

Extension of ERC721AC that allows for minters to receive royalties on the tokens they mint.
The royalty fee is mutable and settable by the owner of each minted token.

*These contracts are intended for example use and are not intended for production deployments as-is.*


## Functions
### constructor


```solidity
constructor(uint96 defaultRoyaltyFeeNumerator_, string memory name_, string memory symbol_)
    ERC721AC(name_, symbol_)
    MutableMinterRoyalties(defaultRoyaltyFeeNumerator_);
```

### supportsInterface


```solidity
function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override(ERC721AC, MutableMinterRoyaltiesBase)
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

