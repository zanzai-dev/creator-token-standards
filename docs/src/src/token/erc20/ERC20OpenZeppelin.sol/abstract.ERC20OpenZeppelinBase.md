# ERC20OpenZeppelinBase
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/token/erc20/ERC20OpenZeppelin.sol)

**Inherits:**
ERC20


## State Variables
### _contractName

```solidity
string internal _contractName;
```


### _contractSymbol

```solidity
string internal _contractSymbol;
```


### _decimals

```solidity
uint8 internal _decimals;
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

### decimals


```solidity
function decimals() public view virtual override returns (uint8);
```

### _setNameSymbolAndDecimals


```solidity
function _setNameSymbolAndDecimals(string memory name_, string memory symbol_, uint8 decimals_) internal;
```

