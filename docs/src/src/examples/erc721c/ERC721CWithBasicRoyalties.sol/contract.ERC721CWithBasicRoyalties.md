# ERC721CWithBasicRoyalties
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/examples/erc721c/ERC721CWithBasicRoyalties.sol)

**Inherits:**
[OwnableBasic](/src/access/OwnableBasic.sol/abstract.OwnableBasic.md), [ERC721C](/src/erc721c/ERC721C.sol/abstract.ERC721C.md), [BasicRoyalties](/src/programmable-royalties/BasicRoyalties.sol/abstract.BasicRoyalties.md)

**Author:**
Limit Break, Inc.

Extension of ERC721C that adds basic royalties support.

*These contracts are intended for example use and are not intended for production deployments as-is.*


## Functions
### constructor


```solidity
constructor(address royaltyReceiver_, uint96 royaltyFeeNumerator_, string memory name_, string memory symbol_)
    ERC721OpenZeppelin(name_, symbol_)
    BasicRoyalties(royaltyReceiver_, royaltyFeeNumerator_);
```

### supportsInterface


```solidity
function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721C, ERC2981) returns (bool);
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

### setDefaultRoyalty


```solidity
function setDefaultRoyalty(address receiver, uint96 feeNumerator) public;
```

### setTokenRoyalty


```solidity
function setTokenRoyalty(uint256 tokenId, address receiver, uint96 feeNumerator) public;
```

