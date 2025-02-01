# ERC721OpenZeppelinBase
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/token/erc721/ERC721OpenZeppelin.sol)

**Inherits:**
ERC721


## State Variables
### _contractName

```solidity
string internal _contractName;
```


### _contractSymbol

```solidity
string internal _contractSymbol;
```


## Functions
### name


```solidity
function name() public view virtual override returns (string memory);
```

### symbol


```solidity
function symbol() public view virtual override returns (string memory);
```

### _setNameAndSymbol


```solidity
function _setNameAndSymbol(string memory name_, string memory symbol_) internal;
```

