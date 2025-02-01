# CreatorTokenBase
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/utils/CreatorTokenBase.sol)

**Inherits:**
[OwnablePermissions](/src/access/OwnablePermissions.sol/abstract.OwnablePermissions.md), [TransferValidation](/src/utils/TransferValidation.sol/abstract.TransferValidation.md), [ICreatorToken](/src/interfaces/ICreatorToken.sol/interface.ICreatorToken.md)

**Author:**
Limit Break, Inc.

CreatorTokenBaseV3 is an abstract contract that provides basic functionality for managing token
transfer policies through an implementation of ICreatorTokenTransferValidator/ICreatorTokenTransferValidatorV2/ICreatorTokenTransferValidatorV3.
This contract is intended to be used as a base for creator-specific token contracts, enabling customizable transfer
restrictions and security policies.
<h4>Features:</h4>
<ul>Ownable: This contract can have an owner who can set and update the transfer validator.</ul>
<ul>TransferValidation: Implements the basic token transfer validation interface.</ul>
<h4>Benefits:</h4>
<ul>Provides a flexible and modular way to implement custom token transfer restrictions and security policies.</ul>
<ul>Allows creators to enforce policies such as account and codehash blacklists, whitelists, and graylists.</ul>
<ul>Can be easily integrated into other token contracts as a base contract.</ul>
<h4>Intended Usage:</h4>
<ul>Use as a base contract for creator token implementations that require advanced transfer restrictions and
security policies.</ul>
<ul>Set and update the ICreatorTokenTransferValidator implementation contract to enforce desired policies for the
creator token.</ul>
<h4>Compatibility:</h4>
<ul>Backward and Forward Compatible - V1/V2/V3 Creator Token Base will work with V1/V2/V3 Transfer Validators.</ul>


## State Variables
### DEFAULT_TRANSFER_VALIDATOR
*The default transfer validator that will be used if no transfer validator has been set by the creator.*


```solidity
address public constant DEFAULT_TRANSFER_VALIDATOR = address(0x721C002B0059009a671D00aD1700c9748146cd1B);
```


### isValidatorInitialized
*Used to determine if the default transfer validator is applied.*

*Set to true when the creator sets a transfer validator address.*


```solidity
bool private isValidatorInitialized;
```


### transferValidator
*Address of the transfer validator to apply to transactions.*


```solidity
address private transferValidator;
```


## Functions
### constructor


```solidity
constructor();
```

### setTransferValidator

Sets the transfer validator for the token contract.

*Throws when provided validator contract is not the zero address and does not have code.*

*Throws when the caller is not the contract owner.*

*<h4>Postconditions:</h4>
1. The transferValidator address is updated.
2. The `TransferValidatorUpdated` event is emitted.*


```solidity
function setTransferValidator(address transferValidator_) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`transferValidator_`|`address`|The address of the transfer validator contract.|


### getTransferValidator

Returns the transfer validator contract address for this token contract.


```solidity
function getTransferValidator() public view override returns (address validator);
```

### _preValidateTransfer

*Pre-validates a token transfer, reverting if the transfer is not allowed by this token's security policy.
Inheriting contracts are responsible for overriding the _beforeTokenTransfer function, or its equivalent
and calling _validateBeforeTransfer so that checks can be properly applied during token transfers.*

*Be aware that if the msg.sender is the transfer validator, the transfer is automatically permitted, as the
transfer validator is expected to pre-validate the transfer.*

*Throws when the transfer doesn't comply with the collection's transfer policy, if the transferValidator is
set to a non-zero address.*


```solidity
function _preValidateTransfer(address caller, address from, address to, uint256 tokenId, uint256)
    internal
    virtual
    override;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`caller`|`address`| The address of the caller.|
|`from`|`address`|   The address of the sender.|
|`to`|`address`|     The address of the receiver.|
|`tokenId`|`uint256`|The token id being transferred.|
|`<none>`|`uint256`||


### _preValidateTransfer

*Pre-validates a token transfer, reverting if the transfer is not allowed by this token's security policy.
Inheriting contracts are responsible for overriding the _beforeTokenTransfer function, or its equivalent
and calling _validateBeforeTransfer so that checks can be properly applied during token transfers.*

*Be aware that if the msg.sender is the transfer validator, the transfer is automatically permitted, as the
transfer validator is expected to pre-validate the transfer.*

*Used for ERC20 and ERC1155 token transfers which have an amount value to validate in the transfer validator.*

*The `tokenId` for ERC20 tokens should be set to `0`.*

*Throws when the transfer doesn't comply with the collection's transfer policy, if the transferValidator is
set to a non-zero address.*


```solidity
function _preValidateTransfer(address caller, address from, address to, uint256 tokenId, uint256 amount, uint256)
    internal
    virtual
    override;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`caller`|`address`| The address of the caller.|
|`from`|`address`|   The address of the sender.|
|`to`|`address`|     The address of the receiver.|
|`tokenId`|`uint256`|The token id being transferred.|
|`amount`|`uint256`| The amount of token being transferred.|
|`<none>`|`uint256`||


### _tokenType


```solidity
function _tokenType() internal pure virtual returns (uint16);
```

### _registerTokenType


```solidity
function _registerTokenType(address validator) internal;
```

### _emitDefaultTransferValidator

*Used during contract deployment for constructable and cloneable creator tokens*

*to emit the `TransferValidatorUpdated` event signaling the validator for the contract*

*is the default transfer validator.*


```solidity
function _emitDefaultTransferValidator() internal;
```

## Errors
### CreatorTokenBase__InvalidTransferValidatorContract
*Thrown when setting a transfer validator address that has no deployed code.*


```solidity
error CreatorTokenBase__InvalidTransferValidatorContract();
```

