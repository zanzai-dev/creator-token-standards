# ERC1155OpenZeppelinInitializable
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/token/erc1155/ERC1155OpenZeppelin.sol)

**Inherits:**
[OwnablePermissions](/src/access/OwnablePermissions.sol/abstract.OwnablePermissions.md), [ERC1155OpenZeppelinBase](/src/token/erc1155/ERC1155OpenZeppelin.sol/abstract.ERC1155OpenZeppelinBase.md)


## State Variables
### _erc1155Initialized

```solidity
bool private _erc1155Initialized;
```


## Functions
### initializeERC1155


```solidity
function initializeERC1155(string memory uri_) public virtual;
```

## Errors
### ERC1155OpenZeppelinInitializable__AlreadyInitializedERC1155

```solidity
error ERC1155OpenZeppelinInitializable__AlreadyInitializedERC1155();
```

