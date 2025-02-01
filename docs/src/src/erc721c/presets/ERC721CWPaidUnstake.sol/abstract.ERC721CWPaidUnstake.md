# ERC721CWPaidUnstake
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/erc721c/presets/ERC721CWPaidUnstake.sol)

**Inherits:**
[ERC721CW](/src/erc721c/extensions/ERC721CW.sol/abstract.ERC721CW.md)

**Author:**
Limit Break, Inc.

Extension of ERC721CW that enforces a payment to unstake the wrapped token.


## State Variables
### unstakePrice
*The price required to unstake.  This cannot be modified after contract creation.*


```solidity
uint256 private immutable unstakePrice;
```


## Functions
### constructor


```solidity
constructor(uint256 unstakePrice_, address wrappedCollectionAddress_, string memory name_, string memory symbol_)
    ERC721CW(wrappedCollectionAddress_)
    ERC721OpenZeppelin(name_, symbol_);
```

### getUnstakePrice

Returns the price, in wei, required to unstake


```solidity
function getUnstakePrice() external view returns (uint256);
```

### _onUnstake

*Reverts if the unstaking payment is not exactly equal to the unstaking price.*


```solidity
function _onUnstake(uint256, uint256 value) internal virtual override;
```

## Errors
### ERC721CWPaidUnstake__IncorrectUnstakePayment

```solidity
error ERC721CWPaidUnstake__IncorrectUnstakePayment();
```

