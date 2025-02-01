# AutomaticValidatorTransferApproval
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/utils/AutomaticValidatorTransferApproval.sol)

**Inherits:**
[OwnablePermissions](/src/access/OwnablePermissions.sol/abstract.OwnablePermissions.md)

**Author:**
Limit Break, Inc.

Base contract mix-in that provides boilerplate code giving the contract owner the
option to automatically approve a 721-C transfer validator implementation for transfers.


## State Variables
### autoApproveTransfersFromValidator
*If true, the collection's transfer validator is automatically approved to transfer holder's tokens.*


```solidity
bool public autoApproveTransfersFromValidator;
```


## Functions
### setAutomaticApprovalOfTransfersFromValidator

Sets if the transfer validator is automatically approved as an operator for all token owners.

*Throws when the caller is not the contract owner.*


```solidity
function setAutomaticApprovalOfTransfersFromValidator(bool autoApprove) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`autoApprove`|`bool`|If true, the collection's transfer validator will be automatically approved to transfer holder's tokens.|


## Events
### AutomaticApprovalOfTransferValidatorSet
*Emitted when the automatic approval flag is modified by the creator.*


```solidity
event AutomaticApprovalOfTransferValidatorSet(bool autoApproved);
```

