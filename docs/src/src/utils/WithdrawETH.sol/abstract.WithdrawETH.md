# WithdrawETH
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/utils/WithdrawETH.sol)

**Inherits:**
[OwnablePermissions](/src/access/OwnablePermissions.sol/abstract.OwnablePermissions.md)

**Author:**
Limit Break, Inc.

A mix-in that can be combined with any ownable contract to enable the contract owner to withdraw ETH from the contract.


## Functions
### withdrawETH

Allows contract owner to withdraw ETH that has been paid into the contract.
This allows inadvertantly lost ETH to be recovered and it also allows the contract owner
To collect funds that have been properly paid into the contract over time.
Throws when caller is not the contract owner.
Throws when the specified amount is zero.
Throws when the specified recipient is zero address.
Throws when the current balance in this contract is less than the specified amount.
Throws when the ETH transfer is unsuccessful.
Postconditions:
---------------
1. The specified amount of ETH has been sent to the specified recipient.
2. A `Withdrawal` event is emitted.


```solidity
function withdrawETH(address payable recipient, uint256 amount) external;
```

## Events
### Withdrawal
*Emitted when a withdrawal is successful.*


```solidity
event Withdrawal(address indexed recipient, uint256 amount);
```

## Errors
### WithdrawETH__AmountMustBeGreaterThanZero
*Thrown when amount is a zero value.*


```solidity
error WithdrawETH__AmountMustBeGreaterThanZero();
```

### WithdrawETH__RecipientMustBeNonZeroAddress
*Thrown when the withdrawal recipient is the zero address.*


```solidity
error WithdrawETH__RecipientMustBeNonZeroAddress();
```

### WithdrawETH__InsufficientBalance
*Thrown when the amount being withdrawn is greater than the contract balance.*


```solidity
error WithdrawETH__InsufficientBalance();
```

### WithdrawETH__WithdrawalUnsuccessful
*Thrown when the withdrawal does not successfully send to the recipient.*


```solidity
error WithdrawETH__WithdrawalUnsuccessful();
```

