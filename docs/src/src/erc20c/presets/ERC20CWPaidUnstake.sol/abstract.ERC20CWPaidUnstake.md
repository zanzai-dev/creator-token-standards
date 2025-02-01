# ERC20CWPaidUnstake
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/erc20c/presets/ERC20CWPaidUnstake.sol)

**Inherits:**
[ERC20CW](/src/erc20c/extensions/ERC20CW.sol/abstract.ERC20CW.md)

**Author:**
Limit Break, Inc.

Extension of ERC20CW that enforces a payment to unstake the wrapped token.


## State Variables
### unstakeUnitPrice
*The price required to unstake.  This cannot be modified after contract creation.*


```solidity
uint256 private immutable unstakeUnitPrice;
```


## Functions
### constructor


```solidity
constructor(
    uint256 unstakeUnitPrice_,
    address wrappedCollectionAddress_,
    string memory name_,
    string memory symbol_,
    uint8 decimals_
) ERC20CW(wrappedCollectionAddress_) ERC20OpenZeppelin(name_, symbol_, decimals_);
```

### getUnstakeUnitPrice

Returns the price, in wei, required to unstake per one item.


```solidity
function getUnstakeUnitPrice() external view returns (uint256);
```

### _onUnstake

*Reverts if the unstaking payment is not exactly equal to the unstaking price.*


```solidity
function _onUnstake(uint256 amount, uint256 value) internal virtual override;
```

## Errors
### ERC20CWPaidUnstake__IncorrectUnstakePayment

```solidity
error ERC20CWPaidUnstake__IncorrectUnstakePayment();
```

