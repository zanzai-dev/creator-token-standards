# ERC1155CWPaidUnstake
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/erc1155c/presets/ERC1155CWPaidUnstake.sol)

**Inherits:**
[ERC1155CW](/src/erc1155c/extensions/ERC1155CW.sol/abstract.ERC1155CW.md)

**Author:**
Limit Break, Inc.

Extension of ERC1155CW that enforces a payment to unstake the wrapped token.


## State Variables
### unstakeUnitPrice
*The price required to unstake.  This cannot be modified after contract creation.*


```solidity
uint256 private immutable unstakeUnitPrice;
```


## Functions
### constructor


```solidity
constructor(uint256 unstakeUnitPrice_, address wrappedCollectionAddress_, string memory uri_)
    ERC1155CW(wrappedCollectionAddress_)
    ERC1155OpenZeppelin(uri_);
```

### getUnstakeUnitPrice

Returns the price, in wei, required to unstake per one item.


```solidity
function getUnstakeUnitPrice() external view returns (uint256);
```

### _onUnstake

*Reverts if the unstaking payment is not exactly equal to the unstaking price.*


```solidity
function _onUnstake(uint256, uint256 amount, uint256 value) internal virtual override;
```

## Errors
### ERC1155CWPaidUnstake__IncorrectUnstakePayment

```solidity
error ERC1155CWPaidUnstake__IncorrectUnstakePayment();
```

