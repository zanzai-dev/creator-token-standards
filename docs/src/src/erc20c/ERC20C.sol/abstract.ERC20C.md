# ERC20C
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/erc20c/ERC20C.sol)

**Inherits:**
ERC165, [ERC20OpenZeppelin](/src/token/erc20/ERC20OpenZeppelin.sol/abstract.ERC20OpenZeppelin.md), [CreatorTokenBase](/src/utils/CreatorTokenBase.sol/abstract.CreatorTokenBase.md), [AutomaticValidatorTransferApproval](/src/utils/AutomaticValidatorTransferApproval.sol/abstract.AutomaticValidatorTransferApproval.md)

**Author:**
Limit Break, Inc.

Extends OpenZeppelin's ERC20 implementation with Creator Token functionality, which
allows the contract owner to update the transfer validation logic by managing a security policy in
an external transfer validation security policy registry.  See {CreatorTokenTransferValidator}.


## Functions
### allowance

Overrides behavior of allowance such that if a spender is not explicitly approved,
the contract owner can optionally auto-approve the 20-C transfer validator for transfers.


```solidity
function allowance(address owner, address spender) public view virtual override returns (uint256 _allowance);
```

### supportsInterface

Indicates whether the contract implements the specified interface.

*Overrides supportsInterface in ERC165.*


```solidity
function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`interfaceId`|`bytes4`|The interface id|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|true if the contract implements the specified interface, false otherwise|


### getTransferValidationFunction

Returns the function selector for the transfer validator's validation function to be called

for transaction simulation.


```solidity
function getTransferValidationFunction() external pure returns (bytes4 functionSignature, bool isViewFunction);
```

### _beforeTokenTransfer

*Ties the open-zeppelin _beforeTokenTransfer hook to more granular transfer validation logic*


```solidity
function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override;
```

### _afterTokenTransfer

*Ties the open-zeppelin _afterTokenTransfer hook to more granular transfer validation logic*


```solidity
function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual override;
```

### _tokenType


```solidity
function _tokenType() internal pure override returns (uint16);
```

