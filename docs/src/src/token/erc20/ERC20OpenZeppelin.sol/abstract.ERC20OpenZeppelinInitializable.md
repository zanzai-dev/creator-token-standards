# ERC20OpenZeppelinInitializable
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/token/erc20/ERC20OpenZeppelin.sol)

**Inherits:**
[OwnablePermissions](/src/access/OwnablePermissions.sol/abstract.OwnablePermissions.md), [ERC20OpenZeppelinBase](/src/token/erc20/ERC20OpenZeppelin.sol/abstract.ERC20OpenZeppelinBase.md)


## State Variables
### _erc20Initialized
Specifies whether or not the contract is initialized


```solidity
bool private _erc20Initialized;
```


## Functions
### constructor


```solidity
constructor() ERC20("", "");
```

### initializeERC20

*Initializes parameters of ERC721 tokens.
These cannot be set in the constructor because this contract is optionally compatible with EIP-1167.*


```solidity
function initializeERC20(string memory name_, string memory symbol_, uint8 decimals_) public virtual;
```

## Errors
### ERC20OpenZeppelinInitializable__AlreadyInitializedERC20

```solidity
error ERC20OpenZeppelinInitializable__AlreadyInitializedERC20();
```

