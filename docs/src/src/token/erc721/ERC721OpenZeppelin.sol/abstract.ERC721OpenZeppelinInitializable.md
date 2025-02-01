# ERC721OpenZeppelinInitializable
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/token/erc721/ERC721OpenZeppelin.sol)

**Inherits:**
[OwnablePermissions](/src/access/OwnablePermissions.sol/abstract.OwnablePermissions.md), [ERC721OpenZeppelinBase](/src/token/erc721/ERC721OpenZeppelin.sol/abstract.ERC721OpenZeppelinBase.md)


## State Variables
### _erc721Initialized
Specifies whether or not the contract is initialized


```solidity
bool private _erc721Initialized;
```


## Functions
### initializeERC721

*Initializes parameters of ERC721 tokens.
These cannot be set in the constructor because this contract is optionally compatible with EIP-1167.*


```solidity
function initializeERC721(string memory name_, string memory symbol_) public virtual;
```

## Errors
### ERC721OpenZeppelinInitializable__AlreadyInitializedERC721

```solidity
error ERC721OpenZeppelinInitializable__AlreadyInitializedERC721();
```

