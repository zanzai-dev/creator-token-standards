# CreatorTokenTransferValidator
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/utils/CreatorTokenTransferValidator.sol)

**Inherits:**
[IEOARegistry](/src/interfaces/IEOARegistry.sol/interface.IEOARegistry.md), [ITransferValidator](/src/interfaces/ITransferValidator.sol/interface.ITransferValidator.md), ERC165, Tstorish, PermitC

**Author:**
Limit Break, Inc.

The CreatorTokenTransferValidator contract is designed to provide a customizable and secure transfer
validation mechanism for NFT collections. This contract allows the owner of an NFT collection to configure
the transfer security level, blacklisted accounts and codehashes, whitelisted accounts and codehashes, and
authorized accounts and codehashes for each collection.

*<h4>Features</h4>
- Transfer security levels: Provides different levels of transfer security,
from open transfers to completely restricted transfers.
- Blacklist: Allows the owner of a collection to blacklist specific operator addresses or codehashes
from executing transfers on behalf of others.
- Whitelist: Allows the owner of a collection to whitelist specific operator addresses or codehashes
permitted to execute transfers on behalf of others or send/receive tokens when otherwise disabled by
security policy.
- Authorizers: Allows the owner of a collection to enable authorizer contracts, that can perform
authorization-based filtering of transfers.*

*<h4>Benefits</h4>
- Enhanced security: Allows creators to have more control over their NFT collections, ensuring the safety
and integrity of their assets.
- Flexibility: Provides collection owners the ability to customize transfer rules as per their requirements.
- Compliance: Facilitates compliance with regulations by enabling creators to restrict transfers based on
specific criteria.*

*<h4>Intended Usage</h4>
- The CreatorTokenTransferValidatorV3 contract is intended to be used by NFT collection owners to manage and
enforce transfer policies. This contract is integrated with the following varations of creator token
NFT contracts to validate transfers according to the defined security policies.
- ERC721-C:   Creator token implenting OpenZeppelin's ERC-721 standard.
- ERC721-AC:  Creator token implenting Azuki's ERC-721A standard.
- ERC721-CW:  Creator token implementing OpenZeppelin's ERC-721 standard with opt-in staking to
wrap/upgrade a pre-existing ERC-721 collection.
- ERC721-ACW: Creator token implementing Azuki's ERC721-A standard with opt-in staking to
wrap/upgrade a pre-existing ERC-721 collection.
- ERC1155-C:  Creator token implenting OpenZeppelin's ERC-1155 standard.
- ERC1155-CW: Creator token implementing OpenZeppelin's ERC-1155 standard with opt-in staking to
wrap/upgrade a pre-existing ERC-1155 collection.
<h4>Transfer Security Levels</h4>
- Recommended: Recommended defaults are same as Level 3 (Whitelisting with OTC Enabled).
- Caller Constraints: OperatorWhitelistEnableOTC
- Receiver Constraints: None
- Level 1: No transfer restrictions.
- Caller Constraints: None
- Receiver Constraints: None
- Level 2: Only non-blacklisted operators can initiate transfers, over-the-counter (OTC) trading enabled.
- Caller Constraints: OperatorBlacklistEnableOTC
- Receiver Constraints: None
- Level 3: Only whitelisted accounts can initiate transfers, over-the-counter (OTC) trading enabled.
- Caller Constraints: OperatorWhitelistEnableOTC
- Receiver Constraints: None
- Level 4: Only whitelisted accounts can initiate transfers, over-the-counter (OTC) trading disabled.
- Caller Constraints: OperatorWhitelistDisableOTC
- Receiver Constraints: None
- Level 5: Only whitelisted accounts can initiate transfers, over-the-counter (OTC) trading enabled.
Transfers to contracts with code are not allowed, unless present on the whitelist.
- Caller Constraints: OperatorWhitelistEnableOTC
- Receiver Constraints: NoCode
- Level 6: Only whitelisted accounts can initiate transfers, over-the-counter (OTC) trading enabled.
Transfers are allowed only to Externally Owned Accounts (EOAs), unless present on the whitelist.
- Caller Constraints: OperatorWhitelistEnableOTC
- Receiver Constraints: EOA
- Level 7: Only whitelisted accounts can initiate transfers, over-the-counter (OTC) trading disabled.
Transfers to contracts with code are not allowed, unless present on the whitelist.
- Caller Constraints: OperatorWhitelistDisableOTC
- Receiver Constraints: NoCode
- Level 8: Only whitelisted accounts can initiate transfers, over-the-counter (OTC) trading disabled.
Transfers are allowed only to Externally Owned Accounts (EOAs), unless present on the whitelist.
- Caller Constraints: OperatorWhitelistDisableOTC
- Receiver Constraints: EOA*


## State Variables
### _callerConstraintsLookup
*Immutable lookup table for constant gas determination of caller constraints by security level.*

*Created during contract construction using defined constants.*


```solidity
uint256 private immutable _callerConstraintsLookup;
```


### _receiverConstraintsLookup
*Immutable lookup table for constant gas determination of receiver constraints by security level.*

*Created during contract construction using defined constants.*


```solidity
uint256 private immutable _receiverConstraintsLookup;
```


### _eoaRegistry
*The address of the EOA Registry to use to validate an account is a verified EOA.*


```solidity
address private immutable _eoaRegistry;
```


### LEGACY_TRANSFER_VALIDATOR_INTERFACE_ID
*The legacy Creator Token Transfer Validator Interface*


```solidity
bytes4 private constant LEGACY_TRANSFER_VALIDATOR_INTERFACE_ID = 0x00000000;
```


### DEFAULT_ACCESS_CONTROL_ADMIN_ROLE
*The default admin role value for contracts that implement access control.*


```solidity
bytes32 private constant DEFAULT_ACCESS_CONTROL_ADMIN_ROLE = 0x00;
```


### BYTES32_ZERO
*Value representing a zero value code hash.*


```solidity
bytes32 private constant BYTES32_ZERO = 0x0000000000000000000000000000000000000000000000000000000000000000;
```


### WILDCARD_OPERATOR_ADDRESS

```solidity
address private constant WILDCARD_OPERATOR_ADDRESS = address(0x01);
```


### DEFAULT_TOKEN_TYPE

```solidity
uint16 private constant DEFAULT_TOKEN_TYPE = 0;
```


### lastListId
Keeps track of the most recently created list id.


```solidity
uint120 public lastListId;
```


### listOwners
Mapping of list ids to list owners


```solidity
mapping(uint120 => address) public listOwners;
```


### collectionSecurityPolicies
*Mapping of collection addresses to their security policy settings*


```solidity
mapping(address => CollectionSecurityPolicyV3) internal collectionSecurityPolicies;
```


### blacklists
*Mapping of list ids to blacklist settings*


```solidity
mapping(uint120 => List) internal blacklists;
```


### whitelists
*Mapping of list ids to whitelist settings*


```solidity
mapping(uint120 => List) internal whitelists;
```


### authorizers
*Mapping of list ids to authorizers*


```solidity
mapping(uint120 => List) internal authorizers;
```


### frozenAccounts
*Mapping of collections to accounts that are frozen for those collections*


```solidity
mapping(address => AccountList) internal frozenAccounts;
```


## Functions
### constructor


```solidity
constructor(
    address defaultOwner,
    address eoaRegistry_,
    string memory name,
    string memory version,
    address validatorConfiguration
)
    Tstorish()
    PermitC(
        name,
        version,
        defaultOwner,
        CreatorTokenTransferValidatorConfiguration(validatorConfiguration).getNativeValueToCheckPauseState()
    );
```

### _createDefaultList

*This function is only called during contract construction to create the default list.*


```solidity
function _createDefaultList(address defaultOwner) internal;
```

### _constructCallerConstraintsTable

*This function is only called during contract construction to create the caller constraints*

*lookup table.*


```solidity
function _constructCallerConstraintsTable() internal pure returns (uint256);
```

### _constructReceiverConstraintsTable

*This function is only called during contract construction to create the receiver constraints*

*lookup table.*


```solidity
function _constructReceiverConstraintsTable() internal pure returns (uint256);
```

### onlyListOwner

*This modifier restricts a function call to the owner of the list `id`.*

*Throws when the caller is not the list owner.*


```solidity
modifier onlyListOwner(uint120 id);
```

### validateTransfer

Apply the collection transfer policy to a transfer operation of a creator token.

*If the caller is self (Permit-C Processor) it means we have already applied operator validation in the
_beforeTransferFrom callback.  In this case, the security policy was already applied and the operator
that used the Permit-C processor passed the security policy check and transfer can be safely allowed.*

*The order of checking whitelisted accounts, authorized operator check and whitelisted codehashes
is very deliberate.  The order of operations is determined by the most frequently used settings that are
expected in the wild.*

*Throws when the collection has enabled account freezing mode and either the `from` or `to` addresses
are on the list of frozen accounts for the collection.*

*Throws when the collection is set to Level 9 - Soulbound Token.*

*Throws when the receiver has deployed code and isn't whitelisted, if ReceiverConstraints.NoCode is set
and the transfer is not approved by an authorizer for the collection.*

*Throws when the receiver has never verified a signature to prove they are an EOA and the receiver
isn't whitelisted, if the ReceiverConstraints.EOA is set and the transfer is not approved by an
authorizer for the collection..*

*Throws when `msg.sender` is blacklisted, if CallerConstraints.OperatorBlacklistEnableOTC is set, unless
`msg.sender` is also the `from` address or the transfer is approved by an authorizer for the collection.*

*Throws when `msg.sender` isn't whitelisted, if CallerConstraints.OperatorWhitelistEnableOTC is set, unless
`msg.sender` is also the `from` address or the transfer is approved by an authorizer for the collection.*

*Throws when neither `msg.sender` nor `from` are whitelisted, if
CallerConstraints.OperatorWhitelistDisableOTC is set and the transfer
is not approved by an authorizer for the collection.*

*<h4>Postconditions:</h4>
1. Transfer is allowed or denied based on the applied transfer policy.*


```solidity
function validateTransfer(address caller, address from, address to) public view;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`caller`|`address`|     The address initiating the transfer.|
|`from`|`address`|       The address of the token owner.|
|`to`|`address`|         The address of the token receiver.|


### validateTransfer

Apply the collection transfer policy to a transfer operation of a creator token.

*If the caller is self (Permit-C Processor) it means we have already applied operator validation in the
_beforeTransferFrom callback.  In this case, the security policy was already applied and the operator
that used the Permit-C processor passed the security policy check and transfer can be safely allowed.*

*The order of checking whitelisted accounts, authorized operator check and whitelisted codehashes
is very deliberate.  The order of operations is determined by the most frequently used settings that are
expected in the wild.*

*Throws when the collection has enabled account freezing mode and either the `from` or `to` addresses
are on the list of frozen accounts for the collection.*

*Throws when the collection is set to Level 9 - Soulbound Token.*

*Throws when the receiver has deployed code and isn't whitelisted, if ReceiverConstraints.NoCode is set
and the transfer is not approved by an authorizer for the collection.*

*Throws when the receiver has never verified a signature to prove they are an EOA and the receiver
isn't whitelisted, if the ReceiverConstraints.EOA is set and the transfer is not approved by an
authorizer for the collection..*

*Throws when `msg.sender` is blacklisted, if CallerConstraints.OperatorBlacklistEnableOTC is set, unless
`msg.sender` is also the `from` address or the transfer is approved by an authorizer for the collection.*

*Throws when `msg.sender` isn't whitelisted, if CallerConstraints.OperatorWhitelistEnableOTC is set, unless
`msg.sender` is also the `from` address or the transfer is approved by an authorizer for the collection.*

*Throws when neither `msg.sender` nor `from` are whitelisted, if
CallerConstraints.OperatorWhitelistDisableOTC is set and the transfer
is not approved by an authorizer for the collection.*

*<h4>Postconditions:</h4>
1. Transfer is allowed or denied based on the applied transfer policy.*


```solidity
function validateTransfer(address caller, address from, address to, uint256 tokenId) public view;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`caller`|`address`|     The address initiating the transfer.|
|`from`|`address`|       The address of the token owner.|
|`to`|`address`|         The address of the token receiver.|
|`tokenId`|`uint256`|    The token id being transferred.|


### validateTransfer

Apply the collection transfer policy to a transfer operation of a creator token.

*If the caller is self (Permit-C Processor) it means we have already applied operator validation in the
_beforeTransferFrom callback.  In this case, the security policy was already applied and the operator
that used the Permit-C processor passed the security policy check and transfer can be safely allowed.*

*The order of checking whitelisted accounts, authorized operator check and whitelisted codehashes
is very deliberate.  The order of operations is determined by the most frequently used settings that are
expected in the wild.*

*Throws when the collection has enabled account freezing mode and either the `from` or `to` addresses
are on the list of frozen accounts for the collection.*

*Throws when the collection is set to Level 9 - Soulbound Token.*

*Throws when the receiver has deployed code and isn't whitelisted, if ReceiverConstraints.NoCode is set
and the transfer is not approved by an authorizer for the collection.*

*Throws when the receiver has never verified a signature to prove they are an EOA and the receiver
isn't whitelisted, if the ReceiverConstraints.EOA is set and the transfer is not approved by an
authorizer for the collection..*

*Throws when `msg.sender` is blacklisted, if CallerConstraints.OperatorBlacklistEnableOTC is set, unless
`msg.sender` is also the `from` address or the transfer is approved by an authorizer for the collection.*

*Throws when `msg.sender` isn't whitelisted, if CallerConstraints.OperatorWhitelistEnableOTC is set, unless
`msg.sender` is also the `from` address or the transfer is approved by an authorizer for the collection.*

*Throws when neither `msg.sender` nor `from` are whitelisted, if
CallerConstraints.OperatorWhitelistDisableOTC is set and the transfer
is not approved by an authorizer for the collection.*

*<h4>Postconditions:</h4>
1. Transfer is allowed or denied based on the applied transfer policy.*


```solidity
function validateTransfer(address caller, address from, address to, uint256 tokenId, uint256) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`caller`|`address`|     The address initiating the transfer.|
|`from`|`address`|       The address of the token owner.|
|`to`|`address`|         The address of the token receiver.|
|`tokenId`|`uint256`|    The token id being transferred.|
|`<none>`|`uint256`||


### applyCollectionTransferPolicy

Apply the collection transfer policy to a transfer operation of a creator token.

*If the caller is self (Permit-C Processor) it means we have already applied operator validation in the
_beforeTransferFrom callback.  In this case, the security policy was already applied and the operator
that used the Permit-C processor passed the security policy check and transfer can be safely allowed.*

*The order of checking whitelisted accounts, authorized operator check and whitelisted codehashes
is very deliberate.  The order of operations is determined by the most frequently used settings that are
expected in the wild.*

*Throws when the collection has enabled account freezing mode and either the `from` or `to` addresses
are on the list of frozen accounts for the collection.*

*Throws when the collection is set to Level 9 - Soulbound Token.*

*Throws when the receiver has deployed code and isn't whitelisted, if ReceiverConstraints.NoCode is set
and the transfer is not approved by an authorizer for the collection.*

*Throws when the receiver has never verified a signature to prove they are an EOA and the receiver
isn't whitelisted, if the ReceiverConstraints.EOA is set and the transfer is not approved by an
authorizer for the collection..*

*Throws when `msg.sender` is blacklisted, if CallerConstraints.OperatorBlacklistEnableOTC is set, unless
`msg.sender` is also the `from` address or the transfer is approved by an authorizer for the collection.*

*Throws when `msg.sender` isn't whitelisted, if CallerConstraints.OperatorWhitelistEnableOTC is set, unless
`msg.sender` is also the `from` address or the transfer is approved by an authorizer for the collection.*

*Throws when neither `msg.sender` nor `from` are whitelisted, if
CallerConstraints.OperatorWhitelistDisableOTC is set and the transfer
is not approved by an authorizer for the collection.*

*<h4>Postconditions:</h4>
1. Transfer is allowed or denied based on the applied transfer policy.*


```solidity
function applyCollectionTransferPolicy(address caller, address from, address to) external view;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`caller`|`address`|     The address initiating the transfer.|
|`from`|`address`|       The address of the token owner.|
|`to`|`address`|         The address of the token receiver.|


### transferSecurityPolicies

Returns the caller and receiver constraints for the specified transfer security level.


```solidity
function transferSecurityPolicies(uint256 level)
    public
    view
    returns (uint256 callerConstraints, uint256 receiverConstraints);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`level`|`uint256`|The transfer security level to return the caller and receiver constraints for.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`callerConstraints`|`uint256`|   The `CallerConstraints` value for the level.|
|`receiverConstraints`|`uint256`|The `ReceiverConstraints` value for the level.|


### beforeAuthorizedTransfer

Sets an operator for an authorized transfer that skips transfer security level
validation for caller and receiver constraints.

*An authorizer *MUST* clear the authorization with a call to `afterAuthorizedTransfer`
to prevent unauthorized transfers of the token.*

*Throws when authorization mode is disabled for the collection.*

*Throws when using the wildcard operator address and the collection does not allow
for wildcard authorized operators.*

*Throws when the caller is not an allowed authorizer for the collection.*

*<h4>Postconditions:</h4>
1. The `operator` is stored as an authorized operator for transfers.*


```solidity
function beforeAuthorizedTransfer(address operator, address token, uint256 tokenId) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`operator`|`address`| The address of the operator to set as authorized for transfers.|
|`token`|`address`|    The address of the token to authorize.|
|`tokenId`|`uint256`|  The token id to set the authorized operator for.|


### afterAuthorizedTransfer

Clears the authorized operator for a token to prevent additional transfers that
do not conform to the transfer security level for the token.

*Throws when authorization mode is disabled for the collection.*

*Throws when using the wildcard operator address and the collection does not allow
for wildcard authorized operators.*

*Throws when the caller is not an allowed authorizer for the collection.*

*<h4>Postconditions:</h4>
1. The authorized operator for the token is cleared from storage.*


```solidity
function afterAuthorizedTransfer(address token, uint256 tokenId) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`token`|`address`|    The address of the token to authorize.|
|`tokenId`|`uint256`|  The token id to set the authorized operator for.|


### beforeAuthorizedTransfer

Sets an operator for an authorized transfer that skips transfer security level
validation for caller and receiver constraints.

This overload of `beforeAuthorizedTransfer` defaults to a tokenId of 0.

*An authorizer *MUST* clear the authorization with a call to `afterAuthorizedTransfer`
to prevent unauthorized transfers of the token.*

*Throws when authorization mode is disabled for the collection.*

*Throws when using the wildcard operator address and the collection does not allow
for wildcard authorized operators.*

*Throws when the caller is not an allowed authorizer for the collection.*

*<h4>Postconditions:</h4>
1. The `operator` is stored as an authorized operator for transfers.*


```solidity
function beforeAuthorizedTransfer(address operator, address token) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`operator`|`address`| The address of the operator to set as authorized for transfers.|
|`token`|`address`|    The address of the token to authorize.|


### afterAuthorizedTransfer

Clears the authorized operator for a token to prevent additional transfers that
do not conform to the transfer security level for the token.

This overload of `afterAuthorizedTransfer` defaults to a tokenId of 0.

*Throws when authorization mode is disabled for the collection.*

*Throws when using the wildcard operator address and the collection does not allow
for wildcard authorized operators.*

*Throws when the caller is not an allowed authorizer for the collection.*

*<h4>Postconditions:</h4>
1. The authorized operator for the token is cleared from storage.*


```solidity
function afterAuthorizedTransfer(address token) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`token`|`address`|    The address of the token to authorize.|


### beforeAuthorizedTransfer

Sets the wildcard operator to authorize any operator to transfer a token while
skipping transfer security level validation for caller and receiver constraints.

*An authorizer *MUST* clear the authorization with a call to `afterAuthorizedTransfer`
to prevent unauthorized transfers of the token.*

*Throws when authorization mode is disabled for the collection.*

*Throws when the collection does not allow for wildcard authorized operators.*

*Throws when the caller is not an allowed authorizer for the collection.*

*<h4>Postconditions:</h4>
1. The wildcard operator is stored as an authorized operator for transfers.*


```solidity
function beforeAuthorizedTransfer(address token, uint256 tokenId) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`token`|`address`|    The address of the token to authorize.|
|`tokenId`|`uint256`|  The token id to set the authorized operator for.|


### beforeAuthorizedTransferWithAmount

Sets the wildcard operator to authorize any operator to transfer a token while
skipping transfer security level validation for caller and receiver constraints.

*An authorizer *MUST* clear the authorization with a call to `afterAuthorizedTransfer`
to prevent unauthorized transfers of the token.*

*Throws when authorization mode is disabled for the collection.*

*Throws when the collection does not allow for wildcard authorized operators.*

*Throws when the caller is not an allowed authorizer for the collection.*

*<h4>Postconditions:</h4>
1. The wildcard operator is stored as an authorized operator for transfers.*


```solidity
function beforeAuthorizedTransferWithAmount(address token, uint256 tokenId, uint256) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`token`|`address`|    The address of the token to authorize.|
|`tokenId`|`uint256`|  The token id to set the authorized operator for.|
|`<none>`|`uint256`||


### afterAuthorizedTransferWithAmount

Clears the authorized operator for a token to prevent additional transfers that
do not conform to the transfer security level for the token.

*Throws when authorization mode is disabled for the collection.*

*Throws when using the wildcard operator address and the collection does not allow
for wildcard authorized operators.*

*Throws when the caller is not an allowed authorizer for the collection.*

*<h4>Postconditions:</h4>
1. The authorized operator for the token is cleared from storage.*


```solidity
function afterAuthorizedTransferWithAmount(address token, uint256 tokenId) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`token`|`address`|    The address of the token to authorize.|
|`tokenId`|`uint256`|  The token id to set the authorized operator for.|


### createList

Creates a new list id.  The list id is a handle to allow editing of blacklisted and whitelisted accounts
and codehashes.

*<h4>Postconditions:</h4>
1. A new list with the specified name is created.
2. The caller is set as the owner of the new list.
3. A `CreatedList` event is emitted.
4. A `ReassignedListOwnership` event is emitted.*


```solidity
function createList(string calldata name) public returns (uint120 id);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`name`|`string`|The name of the new list.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`|  The id of the new list.|


### createListCopy

Creates a new list id, and copies all blacklisted and whitelisted accounts and codehashes from the
specified source list.

*<h4>Postconditions:</h4>
1. A new list with the specified name is created.
2. The caller is set as the owner of the new list.
3. A `CreatedList` event is emitted.
4. A `ReassignedListOwnership` event is emitted.
5. All blacklisted and whitelisted accounts and codehashes from the specified source list are copied
to the new list.
6. An `AddedAccountToList` event is emitted for each blacklisted and whitelisted account copied.
7. An `AddedCodeHashToList` event is emitted for each blacklisted and whitelisted codehash copied.*


```solidity
function createListCopy(string calldata name, uint120 sourceListId) external returns (uint120 id);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`name`|`string`|        The name of the new list.|
|`sourceListId`|`uint120`|The id of the source list to copy from.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`|          The id of the new list.|


### reassignOwnershipOfList

Transfer ownership of a list to a new owner.

*Throws when the new owner is the zero address.*

*Throws when the caller does not own the specified list.*

*<h4>Postconditions:</h4>
1. The list ownership is transferred to the new owner.
2. A `ReassignedListOwnership` event is emitted.*


```solidity
function reassignOwnershipOfList(uint120 id, address newOwner) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`|      The id of the list.|
|`newOwner`|`address`|The address of the new owner.|


### renounceOwnershipOfList

Renounce the ownership of a list, rendering the list immutable.

*Throws when the caller does not own the specified list.*

*<h4>Postconditions:</h4>
1. The ownership of the specified list is renounced.
2. A `ReassignedListOwnership` event is emitted.*


```solidity
function renounceOwnershipOfList(uint120 id) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`|The id of the list.|


### setTransferSecurityLevelOfCollection

Set the transfer security level, authorization mode and account freezing mode settings of a collection.

*Throws when the caller is neither collection contract, nor the owner or admin of the specified collection.*

*<h4>Postconditions:</h4>
1. The transfer security level of the specified collection is set to the new value.
2. The authorization mode setting of the specified collection is set to the new value.
3. The authorization wildcard operator mode setting of the specified collection is set to the new value.
4. The account freezing mode setting of the specified collection is set to the new value.
5. A `SetTransferSecurityLevel` event is emitted.
6. A `SetAuthorizationModeEnabled` event is emitted.
7. A `SetAccountFreezingModeEnabled` event is emitted.*


```solidity
function setTransferSecurityLevelOfCollection(
    address collection,
    uint8 level,
    bool disableAuthorizationMode,
    bool disableWildcardOperators,
    bool enableAccountFreezingMode
) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`collection`|`address`|                The address of the collection.|
|`level`|`uint8`|                     The new transfer security level to apply.|
|`disableAuthorizationMode`|`bool`|  Flag if the collection allows for authorizer mode.|
|`disableWildcardOperators`|`bool`|  Flag if the authorizer can set wildcard operators.|
|`enableAccountFreezingMode`|`bool`| Flag if the collection is using account freezing.|


### setTokenTypeOfCollection

Set the token type setting of a collection.

*Throws when the caller is neither collection contract, nor the owner or admin of the specified collection.*

*<h4>Postconditions:</h4>
1. The token type of the specified collection is set to the new value.
2. A `SetTokenType` event is emitted.*


```solidity
function setTokenTypeOfCollection(address collection, uint16 tokenType) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`collection`|`address`| The address of the collection.|
|`tokenType`|`uint16`|  The new transfer security level to apply.|


### applyListToCollection

Applies the specified list to a collection.

*Throws when the caller is neither collection contract, nor the owner or admin of the specified collection.*

*Throws when the specified list id does not exist.*

*<h4>Postconditions:</h4>
1. The list of the specified collection is set to the new value.
2. An `AppliedListToCollection` event is emitted.*


```solidity
function applyListToCollection(address collection, uint120 id) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`collection`|`address`|The address of the collection.|
|`id`|`uint120`|        The id of the operator whitelist.|


### freezeAccountsForCollection

Adds accounts to the frozen accounts list of a collection.

*Throws when the caller is neither collection contract, nor the owner or admin of the specified collection.*

*<h4>Postconditions:</h4>
1. The accounts are added to the list of frozen accounts for a collection.
2. A `AccountFrozenForCollection` event is emitted for each account added to the list.*


```solidity
function freezeAccountsForCollection(address collection, address[] calldata accountsToFreeze) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`collection`|`address`|       The address of the collection.|
|`accountsToFreeze`|`address[]`| The list of accounts to added to frozen accounts.|


### unfreezeAccountsForCollection

Removes accounts to the frozen accounts list of a collection.

*Throws when the caller is neither collection contract, nor the owner or admin of the specified collection.*

*<h4>Postconditions:</h4>
1. The accounts are removed from the list of frozen accounts for a collection.
2. A `AccountUnfrozenForCollection` event is emitted for each account removed from the list.*


```solidity
function unfreezeAccountsForCollection(address collection, address[] calldata accountsToUnfreeze) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`collection`|`address`|         The address of the collection.|
|`accountsToUnfreeze`|`address[]`| The list of accounts to remove from frozen accounts.|


### getCollectionSecurityPolicy

Get the security policy of the specified collection.


```solidity
function getCollectionSecurityPolicy(address collection) external view returns (CollectionSecurityPolicyV3 memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`collection`|`address`|The address of the collection.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`CollectionSecurityPolicyV3`|The security policy of the specified collection, which includes: Transfer security level, operator whitelist id, permitted contract receiver allowlist id, authorizer mode, if authorizer can set a wildcard operator, and if account freezing is enabled.|


### addAccountsToBlacklist

Adds one or more accounts to a blacklist.

*Throws when the caller does not own the specified list.*

*Throws when the accounts array is empty.*

*<h4>Postconditions:</h4>
1. Accounts not previously in the list are added.
2. An `AddedAccountToList` event is emitted for each account that is newly added to the list.*


```solidity
function addAccountsToBlacklist(uint120 id, address[] calldata accounts) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`|      The id of the list.|
|`accounts`|`address[]`|The addresses of the accounts to add.|


### addAccountsToWhitelist

Adds one or more accounts to a whitelist.

*Throws when the caller does not own the specified list.*

*Throws when the accounts array is empty.*

*<h4>Postconditions:</h4>
1. Accounts not previously in the list are added.
2. An `AddedAccountToList` event is emitted for each account that is newly added to the list.*


```solidity
function addAccountsToWhitelist(uint120 id, address[] calldata accounts) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`|      The id of the list.|
|`accounts`|`address[]`|The addresses of the accounts to add.|


### addAccountsToAuthorizers

Adds one or more accounts to authorizers.

*Throws when the caller does not own the specified list.*

*Throws when the accounts array is empty.*

*<h4>Postconditions:</h4>
1. Accounts not previously in the list are added.
2. An `AddedAccountToList` event is emitted for each account that is newly added to the list.*


```solidity
function addAccountsToAuthorizers(uint120 id, address[] calldata accounts) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`|      The id of the list.|
|`accounts`|`address[]`|The addresses of the accounts to add.|


### addCodeHashesToBlacklist

Adds one or more codehashes to a blacklist.

*Throws when the caller does not own the specified list.*

*Throws when the codehashes array is empty.*

*Throws when a codehash is zero.*

*<h4>Postconditions:</h4>
1. Codehashes not previously in the list are added.
2. An `AddedCodeHashToList` event is emitted for each codehash that is newly added to the list.*


```solidity
function addCodeHashesToBlacklist(uint120 id, bytes32[] calldata codehashes) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`|        The id of the list.|
|`codehashes`|`bytes32[]`|The codehashes to add.|


### addCodeHashesToWhitelist

Adds one or more codehashes to a whitelist.

*Throws when the caller does not own the specified list.*

*Throws when the codehashes array is empty.*

*Throws when a codehash is zero.*

*<h4>Postconditions:</h4>
1. Codehashes not previously in the list are added.
2. An `AddedCodeHashToList` event is emitted for each codehash that is newly added to the list.*


```solidity
function addCodeHashesToWhitelist(uint120 id, bytes32[] calldata codehashes) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`|        The id of the list.|
|`codehashes`|`bytes32[]`|The codehashes to add.|


### removeAccountsFromBlacklist

Removes one or more accounts from a blacklist.

*Throws when the caller does not own the specified list.*

*Throws when the accounts array is empty.*

*<h4>Postconditions:</h4>
1. Accounts previously in the list are removed.
2. A `RemovedAccountFromList` event is emitted for each account that is removed from the list.*


```solidity
function removeAccountsFromBlacklist(uint120 id, address[] calldata accounts) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`|      The id of the list.|
|`accounts`|`address[]`|The addresses of the accounts to remove.|


### removeAccountsFromWhitelist

Removes one or more accounts from a whitelist.

*Throws when the caller does not own the specified list.*

*Throws when the accounts array is empty.*

*<h4>Postconditions:</h4>
1. Accounts previously in the list are removed.
2. A `RemovedAccountFromList` event is emitted for each account that is removed from the list.*


```solidity
function removeAccountsFromWhitelist(uint120 id, address[] calldata accounts) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`|      The id of the list.|
|`accounts`|`address[]`|The addresses of the accounts to remove.|


### removeAccountsFromAuthorizers

Removes one or more accounts from authorizers.

*Throws when the caller does not own the specified list.*

*Throws when the accounts array is empty.*

*<h4>Postconditions:</h4>
1. Accounts previously in the list are removed.
2. A `RemovedAccountFromList` event is emitted for each account that is removed from the list.*


```solidity
function removeAccountsFromAuthorizers(uint120 id, address[] calldata accounts) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`|      The id of the list.|
|`accounts`|`address[]`|The addresses of the accounts to remove.|


### removeCodeHashesFromBlacklist

Removes one or more codehashes from a blacklist.

*Throws when the caller does not own the specified list.*

*Throws when the codehashes array is empty.*

*<h4>Postconditions:</h4>
1. Codehashes previously in the list are removed.
2. A `RemovedCodeHashFromList` event is emitted for each codehash that is removed from the list.*


```solidity
function removeCodeHashesFromBlacklist(uint120 id, bytes32[] calldata codehashes) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`|        The id of the list.|
|`codehashes`|`bytes32[]`|The codehashes to remove.|


### removeCodeHashesFromWhitelist

Removes one or more codehashes from a whitelist.

*Throws when the caller does not own the specified list.*

*Throws when the codehashes array is empty.*

*<h4>Postconditions:</h4>
1. Codehashes previously in the list are removed.
2. A `RemovedCodeHashFromList` event is emitted for each codehash that is removed from the list.*


```solidity
function removeCodeHashesFromWhitelist(uint120 id, bytes32[] calldata codehashes) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`|        The id of the list.|
|`codehashes`|`bytes32[]`|The codehashes to remove.|


### getBlacklistedAccounts

Get blacklisted accounts by list id.


```solidity
function getBlacklistedAccounts(uint120 id) public view returns (address[] memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`|The id of the list.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address[]`|An array of blacklisted accounts.|


### getWhitelistedAccounts

Get whitelisted accounts by list id.


```solidity
function getWhitelistedAccounts(uint120 id) public view returns (address[] memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`|The id of the list.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address[]`|An array of whitelisted accounts.|


### getAuthorizerAccounts

Get authorizor accounts by list id.


```solidity
function getAuthorizerAccounts(uint120 id) public view returns (address[] memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`|The id of the list.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address[]`|An array of authorizer accounts.|


### getBlacklistedCodeHashes

Get blacklisted codehashes by list id.


```solidity
function getBlacklistedCodeHashes(uint120 id) public view returns (bytes32[] memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`|The id of the list.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes32[]`|An array of blacklisted codehashes.|


### getWhitelistedCodeHashes

Get whitelisted codehashes by list id.


```solidity
function getWhitelistedCodeHashes(uint120 id) public view returns (bytes32[] memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`|The id of the list.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes32[]`|An array of whitelisted codehashes.|


### isAccountBlacklisted

Check if an account is blacklisted in a specified list.


```solidity
function isAccountBlacklisted(uint120 id, address account) public view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`|      The id of the list.|
|`account`|`address`| The address of the account to check.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|True if the account is blacklisted in the specified list, false otherwise.|


### isAccountWhitelisted

Check if an account is whitelisted in a specified list.


```solidity
function isAccountWhitelisted(uint120 id, address account) public view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`|      The id of the list.|
|`account`|`address`| The address of the account to check.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|True if the account is whitelisted in the specified list, false otherwise.|


### isAccountAuthorizer

Check if an account is an authorizer in a specified list.


```solidity
function isAccountAuthorizer(uint120 id, address account) public view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`|      The id of the list.|
|`account`|`address`| The address of the account to check.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|True if the account is an authorizer in the specified list, false otherwise.|


### isCodeHashBlacklisted

Check if a codehash is blacklisted in a specified list.


```solidity
function isCodeHashBlacklisted(uint120 id, bytes32 codehash) public view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`|      The id of the list.|
|`codehash`|`bytes32`| The codehash to check.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|True if the codehash is blacklisted in the specified list, false otherwise.|


### isCodeHashWhitelisted

Check if a codehash is whitelisted in a specified list.


```solidity
function isCodeHashWhitelisted(uint120 id, bytes32 codehash) public view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`|      The id of the list.|
|`codehash`|`bytes32`| The codehash to check.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|True if the codehash is whitelisted in the specified list, false otherwise.|


### getBlacklistedAccountsByCollection

Get blacklisted accounts by collection.


```solidity
function getBlacklistedAccountsByCollection(address collection) external view returns (address[] memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`collection`|`address`|The address of the collection.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address[]`|An array of blacklisted accounts.|


### getWhitelistedAccountsByCollection

Get whitelisted accounts by collection.


```solidity
function getWhitelistedAccountsByCollection(address collection) external view returns (address[] memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`collection`|`address`|The address of the collection.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address[]`|An array of whitelisted accounts.|


### getAuthorizerAccountsByCollection

Get authorizer accounts by collection.


```solidity
function getAuthorizerAccountsByCollection(address collection) external view returns (address[] memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`collection`|`address`|The address of the collection.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address[]`|An array of authorizer accounts.|


### getFrozenAccountsByCollection

Get frozen accounts by collection.


```solidity
function getFrozenAccountsByCollection(address collection) external view returns (address[] memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`collection`|`address`|The address of the collection.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address[]`|An array of frozen accounts.|


### getBlacklistedCodeHashesByCollection

Get blacklisted codehashes by collection.


```solidity
function getBlacklistedCodeHashesByCollection(address collection) external view returns (bytes32[] memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`collection`|`address`|The address of the collection.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes32[]`|An array of blacklisted codehashes.|


### getWhitelistedCodeHashesByCollection

Get whitelisted codehashes by collection.


```solidity
function getWhitelistedCodeHashesByCollection(address collection) external view returns (bytes32[] memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`collection`|`address`|The address of the collection.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes32[]`|An array of whitelisted codehashes.|


### isAccountBlacklistedByCollection

Check if an account is blacklisted by a specified collection.


```solidity
function isAccountBlacklistedByCollection(address collection, address account) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`collection`|`address`|The address of the collection.|
|`account`|`address`|   The address of the account to check.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|True if the account is blacklisted by the specified collection, false otherwise.|


### isAccountWhitelistedByCollection

Check if an account is whitelisted by a specified collection.


```solidity
function isAccountWhitelistedByCollection(address collection, address account) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`collection`|`address`|The address of the collection.|
|`account`|`address`|   The address of the account to check.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|True if the account is whitelisted by the specified collection, false otherwise.|


### isAccountAuthorizerOfCollection

Check if an account is an authorizer of a specified collection.


```solidity
function isAccountAuthorizerOfCollection(address collection, address account) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`collection`|`address`|The address of the collection.|
|`account`|`address`|   The address of the account to check.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|True if the account is an authorizer by the specified collection, false otherwise.|


### isAccountFrozenForCollection

Check if an account is frozen for a specified collection.


```solidity
function isAccountFrozenForCollection(address collection, address account) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`collection`|`address`|The address of the collection.|
|`account`|`address`|   The address of the account to check.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|True if the account is frozen by the specified collection, false otherwise.|


### isCodeHashBlacklistedByCollection

Check if a codehash is blacklisted by a specified collection.


```solidity
function isCodeHashBlacklistedByCollection(address collection, bytes32 codehash) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`collection`|`address`|The address of the collection.|
|`codehash`|`bytes32`|  The codehash to check.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|True if the codehash is blacklisted by the specified collection, false otherwise.|


### isCodeHashWhitelistedByCollection

Check if a codehash is whitelisted by a specified collection.


```solidity
function isCodeHashWhitelistedByCollection(address collection, bytes32 codehash) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`collection`|`address`|The address of the collection.|
|`codehash`|`bytes32`|  The codehash to check.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|True if the codehash is whitelisted by the specified collection, false otherwise.|


### isVerifiedEOA

Returns true if the specified account has verified a signature on the registry, false otherwise.


```solidity
function isVerifiedEOA(address account) public view returns (bool);
```

### supportsInterface

ERC-165 Interface Support

*Do not remove LEGACY from this contract or future contracts.
Doing so will break backwards compatibility with V1 and V2 creator tokens.*


```solidity
function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool);
```

### _requireCallerIsNFTOrContractOwnerOrAdmin

Reverts the transaction if the caller is not the owner or assigned the default

admin role of the contract at `tokenAddress`.

*Throws when the caller is neither owner nor assigned the default admin role.*


```solidity
function _requireCallerIsNFTOrContractOwnerOrAdmin(address tokenAddress) internal view;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenAddress`|`address`|The contract address of the token to check permissions for.|


### _copyAddressSet

Copies all addresses in `ptrFromList` to `ptrToList`.

*This function will copy all addresses from one list to another list.*

*Note: If used to copy adddresses to an existing list the current list contents will not be*

*deleted before copying. New addresses will be appeneded to the end of the list and the*

*non-enumerable mapping key value will be set to true.*

*<h4>Postconditions:</h4>
1. Addresses in from list that are not already present in to list are added to the to list.
2. Emits an `AddedAccountToList` event for each address copied to the list.*


```solidity
function _copyAddressSet(uint8 listType, uint120 destinationListId, List storage ptrFromList, List storage ptrToList)
    private;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`listType`|`uint8`|         The type of list addresses are being copied from and to.|
|`destinationListId`|`uint120`|The id of the list being copied to.|
|`ptrFromList`|`List`|      The storage pointer for the list being copied from.|
|`ptrToList`|`List`|        The storage pointer for the list being copied to.|


### _copyBytes32Set

Copies all codehashes in `ptrFromList` to `ptrToList`.

*This function will copy all codehashes from one list to another list.*

*Note: If used to copy codehashes to an existing list the current list contents will not be*

*deleted before copying. New codehashes will be appeneded to the end of the list and the*

*non-enumerable mapping key value will be set to true.*

*<h4>Postconditions:</h4>
1. Codehashes in from list that are not already present in to list are added to the to list.
2. Emits an `AddedCodeHashToList` event for each codehash copied to the list.*


```solidity
function _copyBytes32Set(uint8 listType, uint120 destinationListId, List storage ptrFromList, List storage ptrToList)
    private;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`listType`|`uint8`|         The type of list codehashes are being copied from and to.|
|`destinationListId`|`uint120`|The id of the list being copied to.|
|`ptrFromList`|`List`|      The storage pointer for the list being copied from.|
|`ptrToList`|`List`|        The storage pointer for the list being copied to.|


### _addAccountsToList

Adds one or more accounts to a list.

*<h4>Postconditions:</h4>
1. Accounts that were not previously in the list are added to the list.
2. An `AddedAccountToList` event is emitted for each account that was not
previously on the list.*


```solidity
function _addAccountsToList(List storage list, uint8 listType, uint120 id, address[] calldata accounts)
    internal
    onlyListOwner(id);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`list`|`List`|    The storage pointer for the list to add accounts to.|
|`listType`|`uint8`|The type of list the accounts are being added to.|
|`id`|`uint120`|      The id of the list the accounts are being added to.|
|`accounts`|`address[]`|An array of accounts to add to the list.|


### _addCodeHashesToList

Adds one or more codehashes to a list.

*<h4>Postconditions:</h4>
1. Codehashes that were not previously in the list are added to the list.
2. An `AddedCodeHashToList` event is emitted for each codehash that was not
previously on the list.*


```solidity
function _addCodeHashesToList(List storage list, uint8 listType, uint120 id, bytes32[] calldata codehashes)
    internal
    onlyListOwner(id);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`list`|`List`|       The storage pointer for the list to add codehashes to.|
|`listType`|`uint8`|   The type of list the codehashes are being added to.|
|`id`|`uint120`|         The id of the list the codehashes are being added to.|
|`codehashes`|`bytes32[]`| An array of codehashes to add to the list.|


### _removeAccountsFromList

Removes one or more accounts from a list.

*<h4>Postconditions:</h4>
1. Accounts that were previously in the list are removed from the list.
2. An `RemovedAccountFromList` event is emitted for each account that was
previously on the list.*


```solidity
function _removeAccountsFromList(List storage list, uint8 listType, uint120 id, address[] memory accounts)
    internal
    onlyListOwner(id);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`list`|`List`|       The storage pointer for the list to remove accounts from.|
|`listType`|`uint8`|   The type of list the accounts are being removed from.|
|`id`|`uint120`|         The id of the list the accounts are being removed from.|
|`accounts`|`address[]`|   An array of accounts to remove from the list.|


### _removeCodeHashesFromList

Removes one or more codehashes from a list.

*<h4>Postconditions:</h4>
1. Codehashes that were previously in the list are removed from the list.
2. An `RemovedCodeHashFromList` event is emitted for each codehash that was
previously on the list.*


```solidity
function _removeCodeHashesFromList(List storage list, uint8 listType, uint120 id, bytes32[] calldata codehashes)
    internal
    onlyListOwner(id);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`list`|`List`|       The storage pointer for the list to remove codehashes from.|
|`listType`|`uint8`|   The type of list the codehashes are being removed from.|
|`id`|`uint120`|         The id of the list the codehashes are being removed from.|
|`codehashes`|`bytes32[]`| An array of codehashes to remove from the list.|


### _reassignOwnershipOfList

Sets the owner of list `id` to `newOwner`.

*Throws when the caller is not the owner of the list.*

*<h4>Postconditions:</h4>
1. The owner of list `id` is set to `newOwner`.
2. Emits a `ReassignedListOwnership` event.*


```solidity
function _reassignOwnershipOfList(uint120 id, address newOwner) private;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`|      The id of the list to reassign ownership of.|
|`newOwner`|`address`|The account to assign ownership of the list to.|


### _requireCallerOwnsList

Requires the caller to be the owner of list `id`.

*Throws when the caller is not the owner of the list.*


```solidity
function _requireCallerOwnsList(uint120 id) private view;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint120`| The id of the list to check ownership of.|


### _getCodeLengthAsm

*Internal function used to efficiently retrieve the code length of `account`.*


```solidity
function _getCodeLengthAsm(address account) internal view returns (uint256 length);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`account`|`address`|The address to get the deployed code length for.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`length`|`uint256`|The length of deployed code at the address.|


### _getCodeHashAsm

*Internal function used to efficiently retrieve the codehash of `account`.*


```solidity
function _getCodeHashAsm(address account) internal view returns (bytes32 codehash);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`account`|`address`|The address to get the deployed codehash for.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`codehash`|`bytes32`|The codehash of the deployed code at the address.|


### _beforeTransferFrom

*Hook that is called before any permitted token transfer that goes through Permit-C.
Applies the collection transfer policy, using the operator that called Permit-C as the caller.
This allows creator token standard protections to extend to permitted transfers.*


```solidity
function _beforeTransferFrom(uint256 tokenType, address token, address from, address to, uint256 id, uint256)
    internal
    override
    returns (bool isError);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenType`|`uint256`||
|`token`|`address`| The collection address of the token being transferred.|
|`from`|`address`|  The address of the token owner.|
|`to`|`address`|    The address of the token receiver.|
|`id`|`uint256`|    The token id being transferred.|
|`<none>`|`uint256`||


### _validateTransfer

Apply the collection transfer policy to a transfer operation of a creator token.

*If the caller is self (Permit-C Processor) it means we have already applied operator validation in the
_beforeTransferFrom callback.  In this case, the security policy was already applied and the operator
that used the Permit-C processor passed the security policy check and transfer can be safely allowed.*

*The order of checking whitelisted accounts, authorized operator check and whitelisted codehashes
is very deliberate.  The order of operations is determined by the most frequently used settings that are
expected in the wild.*

*Throws when the collection has enabled account freezing mode and either the `from` or `to` addresses
are on the list of frozen accounts for the collection.*

*Throws when the collection is set to Level 9 - Soulbound Token.*

*Throws when the receiver has deployed code and isn't whitelisted, if ReceiverConstraints.NoCode is set
and the transfer is not approved by an authorizer for the collection.*

*Throws when the receiver has never verified a signature to prove they are an EOA and the receiver
isn't whitelisted, if the ReceiverConstraints.EOA is set and the transfer is not approved by an
authorizer for the collection..*

*Throws when `msg.sender` is blacklisted, if CallerConstraints.OperatorBlacklistEnableOTC is set, unless
`msg.sender` is also the `from` address or the transfer is approved by an authorizer for the collection.*

*Throws when `msg.sender` isn't whitelisted, if CallerConstraints.OperatorWhitelistEnableOTC is set, unless
`msg.sender` is also the `from` address or the transfer is approved by an authorizer for the collection.*

*Throws when neither `msg.sender` nor `from` are whitelisted, if
CallerConstraints.OperatorWhitelistDisableOTC is set and the transfer
is not approved by an authorizer for the collection.*

*<h4>Postconditions:</h4>
1. Transfer is allowed or denied based on the applied transfer policy.*


```solidity
function _validateTransfer(
    function(address,address,uint256) internal view returns(bool) _callerAuthorizedParam,
    address collection,
    address caller,
    address from,
    address to,
    uint256 tokenId
) internal view returns (bytes4, uint16);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_callerAuthorizedParam`|`function (address, address, uint256) internal view returns (bool)`||
|`collection`|`address`| The collection address of the token being transferred.|
|`caller`|`address`|     The address initiating the transfer.|
|`from`|`address`|       The address of the token owner.|
|`to`|`address`|         The address of the token receiver.|
|`tokenId`|`uint256`|    The token id being transferred.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes4`|The selector value for an error if the transfer is not allowed, `SELECTOR_NO_ERROR` if the transfer is allowed.|
|`<none>`|`uint16`||


### _revertCustomErrorSelectorAsm

*Internal function used to efficiently revert with a custom error selector.*


```solidity
function _revertCustomErrorSelectorAsm(bytes4 errorSelector) internal pure;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`errorSelector`|`bytes4`|The error selector to revert with.|


### _checkCollectionAllowsAuthorizerAndOperator

*Internal function used to check if authorization mode can be activated for a transfer.*

*Throws when the collection has not enabled authorization mode.*

*Throws when the wildcard operator is being set for a collection that does not
allow wildcard operators.*

*Throws when the authorizer is not in the list of approved authorizers for
the collection.*


```solidity
function _checkCollectionAllowsAuthorizerAndOperator(address collection, address operator, address authorizer)
    internal
    view;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`collection`|`address`| The collection address to activate authorization mode for a transfer.|
|`operator`|`address`|   The operator specified by the authorizer to allow transfers.|
|`authorizer`|`address`| The address of the authorizer making the call.|


### whenAuthorizerAndOperatorEnabledForCollection

*Modifier to apply the allowed authorizer and operator for collection checks.*

*Throws when the collection has not enabled authorization mode.*

*Throws when the wildcard operator is being set for a collection that does not
allow wildcard operators.*

*Throws when the authorizer is not in the list of approved authorizers for
the collection.*


```solidity
modifier whenAuthorizerAndOperatorEnabledForCollection(address collection, address operator, address authorizer);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`collection`|`address`| The collection address to activate authorization mode for a transfer.|
|`operator`|`address`|   The operator specified by the authorizer to allow transfers.|
|`authorizer`|`address`| The address of the authorizer making the call.|


### _setOperatorInTransientStorage

*Internal function for setting the authorized operator in storage for a token and collection.*


```solidity
function _setOperatorInTransientStorage(address operator, address collection, uint256 tokenId, bool allowAnyTokenId)
    internal
    whenAuthorizerAndOperatorEnabledForCollection(collection, operator, msg.sender);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`operator`|`address`|        The allowed operator for an authorized transfer.|
|`collection`|`address`|      The address of the collection that the operator is authorized for.|
|`tokenId`|`uint256`|         The id of the token that is authorized.|
|`allowAnyTokenId`|`bool`| Flag if the authorizer is enabling transfers for any token id|


### _callerAuthorizedCheckToken

*Internal function to check if a caller is an authorized operator for the token being transferred.*


```solidity
function _callerAuthorizedCheckToken(address collection, address caller, uint256 tokenId)
    internal
    view
    returns (bool isAuthorized);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`collection`|`address`|The collection address of the token being transferred.|
|`caller`|`address`|    The caller of the token transfer.|
|`tokenId`|`uint256`|   The id of the token being transferred.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`isAuthorized`|`bool`| True if the caller is authorized to transfer the token, false otherwise.|


### _callerAuthorizedCheckCollection

*Internal function to check if a caller is an authorized operator for the collection being transferred.*


```solidity
function _callerAuthorizedCheckCollection(address collection, address caller, uint256)
    internal
    view
    returns (bool isAuthorized);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`collection`|`address`|The collection address of the token being transferred.|
|`caller`|`address`|    The caller of the token transfer.|
|`<none>`|`uint256`||

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`isAuthorized`|`bool`| True if the caller is authorized to transfer the collection, false otherwise.|


### _callerAuthorized

*Internal function to check if a caller is an authorized operator.*

*This overload of `_callerAuthorized` checks a specific storage slot for the caller address.*


```solidity
function _callerAuthorized(address caller, uint256 slot) internal view returns (bool isAuthorized, uint256 slotValue);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`caller`|`address`|    The caller of the token transfer.|
|`slot`|`uint256`|      The storage slot to check for the caller address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`isAuthorized`|`bool`| True if the caller is authorized to transfer the token, false otherwise.|
|`slotValue`|`uint256`|    The transient storage value in `slot`, used to check for allow any token id flag if necessary.|


### _getTransientOperatorSlot

*Internal function used to compute the transient storage slot for the authorized
operator of a token in a collection.*


```solidity
function _getTransientOperatorSlot(address collection, uint256 tokenId) internal pure returns (uint256 operatorSlot);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`collection`|`address`|The collection address of the token being transferred.|
|`tokenId`|`uint256`|   The id of the token being transferred.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`operatorSlot`|`uint256`|The storage slot location for the authorized operator value.|


### _getTransientOperatorSlot

*Internal function used to compute the transient storage slot for the authorized operator of a collection.*


```solidity
function _getTransientOperatorSlot(address collection) internal pure returns (uint256 operatorSlot);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`collection`|`address`|The collection address of the token being transferred.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`operatorSlot`|`uint256`|The storage slot location for the authorized operator value.|


### _safeOwner

*A gas efficient, and fallback-safe way to call the owner function on a token contract.
This will get the owner if it exists - and when the function is unimplemented, the
presence of a fallback function will not result in halted execution.*


```solidity
function _safeOwner(address tokenAddress) internal view returns (address owner, bool isError);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenAddress`|`address`| The address of the token collection to get the owner of.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`owner`|`address`|  The owner of the token collection contract.|
|`isError`|`bool`|True if there was an error in retrieving the owner, false if the call was successful.|


### _safeHasRole

*A gas efficient, and fallback-safe way to call the hasRole function on a token contract.
This will check if the account `hasRole` if `hasRole` exists - and when the function is unimplemented, the
presence of a fallback function will not result in halted execution.*


```solidity
function _safeHasRole(address tokenAddress, bytes32 role, address account)
    internal
    view
    returns (bool hasRole, bool isError);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenAddress`|`address`| The address of the token collection to call hasRole on.|
|`role`|`bytes32`|         The role to check if the account has on the collection.|
|`account`|`address`|      The address of the account to check if they have a specified role.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`hasRole`|`bool`|The owner of the token collection contract.|
|`isError`|`bool`|True if there was an error in retrieving the owner, false if the call was successful.|


## Events
### CreatedList
*Emitted when a new list is created.*


```solidity
event CreatedList(uint256 indexed id, string name);
```

### AppliedListToCollection
*Emitted when a list is applied to a collection.*


```solidity
event AppliedListToCollection(address indexed collection, uint120 indexed id);
```

### ReassignedListOwnership
*Emitted when the ownership of a list is transferred to a new owner.*


```solidity
event ReassignedListOwnership(uint256 indexed id, address indexed newOwner);
```

### AccountFrozenForCollection
*Emitted when an account is added to the list of frozen accounts for a collection.*


```solidity
event AccountFrozenForCollection(address indexed collection, address indexed account);
```

### AccountUnfrozenForCollection
*Emitted when an account is removed from the list of frozen accounts for a collection.*


```solidity
event AccountUnfrozenForCollection(address indexed collection, address indexed account);
```

### AddedAccountToList
*Emitted when an address is added to a list.*


```solidity
event AddedAccountToList(uint8 indexed kind, uint256 indexed id, address indexed account);
```

### AddedCodeHashToList
*Emitted when a codehash is added to a list.*


```solidity
event AddedCodeHashToList(uint8 indexed kind, uint256 indexed id, bytes32 indexed codehash);
```

### RemovedAccountFromList
*Emitted when an address is removed from a list.*


```solidity
event RemovedAccountFromList(uint8 indexed kind, uint256 indexed id, address indexed account);
```

### RemovedCodeHashFromList
*Emitted when a codehash is removed from a list.*


```solidity
event RemovedCodeHashFromList(uint8 indexed kind, uint256 indexed id, bytes32 indexed codehash);
```

### SetTransferSecurityLevel
*Emitted when the security level for a collection is updated.*


```solidity
event SetTransferSecurityLevel(address indexed collection, uint8 level);
```

### SetAuthorizationModeEnabled
*Emitted when a collection updates its authorization mode.*


```solidity
event SetAuthorizationModeEnabled(
    address indexed collection, bool disabled, bool authorizersCannotSetWildcardOperators
);
```

### SetAccountFreezingModeEnabled
*Emitted when a collection turns account freezing on or off.*


```solidity
event SetAccountFreezingModeEnabled(address indexed collection, bool enabled);
```

### SetTokenType
*Emitted when a collection's token type is updated.*


```solidity
event SetTokenType(address indexed collection, uint16 tokenType);
```

## Errors
### CreatorTokenTransferValidator__ListDoesNotExist
*Thrown when attempting to set a list id that does not exist.*


```solidity
error CreatorTokenTransferValidator__ListDoesNotExist();
```

### CreatorTokenTransferValidator__ListOwnershipCannotBeTransferredToZeroAddress
*Thrown when attempting to transfer the ownership of a list to the zero address.*


```solidity
error CreatorTokenTransferValidator__ListOwnershipCannotBeTransferredToZeroAddress();
```

### CreatorTokenTransferValidator__CallerDoesNotOwnList
*Thrown when attempting to call a function that requires the caller to be the list owner.*


```solidity
error CreatorTokenTransferValidator__CallerDoesNotOwnList();
```

### CreatorTokenTransferValidator__CallerMustBeWhitelisted
*Thrown when validating a transfer for a collection using whitelists and the operator is not on the whitelist.*


```solidity
error CreatorTokenTransferValidator__CallerMustBeWhitelisted();
```

### CreatorTokenTransferValidator__CallerMustBeAnAuthorizer
*Thrown when authorizing a transfer for a collection using authorizers and the msg.sender is not in the authorizer list.*


```solidity
error CreatorTokenTransferValidator__CallerMustBeAnAuthorizer();
```

### CreatorTokenTransferValidator__CallerMustHaveElevatedPermissionsForSpecifiedNFT
*Thrown when attempting to call a function that requires owner or default admin role for a collection that the caller does not have.*


```solidity
error CreatorTokenTransferValidator__CallerMustHaveElevatedPermissionsForSpecifiedNFT();
```

### CreatorTokenTransferValidator__InvalidConstructorArgs
*Thrown when constructor args are not valid*


```solidity
error CreatorTokenTransferValidator__InvalidConstructorArgs();
```

### CreatorTokenTransferValidator__InvalidTransferSecurityLevel
*Thrown when setting the transfer security level to an invalid value.*


```solidity
error CreatorTokenTransferValidator__InvalidTransferSecurityLevel();
```

### CreatorTokenTransferValidator__OperatorIsBlacklisted
*Thrown when validating a transfer for a collection using blacklists and the operator is on the blacklist.*


```solidity
error CreatorTokenTransferValidator__OperatorIsBlacklisted();
```

### CreatorTokenTransferValidator__ReceiverMustNotHaveDeployedCode
*Thrown when validating a transfer for a collection that does not allow receiver to have code and the receiver has code.*


```solidity
error CreatorTokenTransferValidator__ReceiverMustNotHaveDeployedCode();
```

### CreatorTokenTransferValidator__ReceiverProofOfEOASignatureUnverified
*Thrown when validating a transfer for a collection that requires receivers be verified EOAs and the receiver is not verified.*


```solidity
error CreatorTokenTransferValidator__ReceiverProofOfEOASignatureUnverified();
```

### CreatorTokenTransferValidator__ReceiverAccountIsFrozen
*Thrown when a frozen account is the receiver of a transfer*


```solidity
error CreatorTokenTransferValidator__ReceiverAccountIsFrozen();
```

### CreatorTokenTransferValidator__SenderAccountIsFrozen
*Thrown when a frozen account is the sender of a transfer*


```solidity
error CreatorTokenTransferValidator__SenderAccountIsFrozen();
```

### CreatorTokenTransferValidator__TokenIsSoulbound
*Thrown when validating a transfer for a collection that is in soulbound token mode.*


```solidity
error CreatorTokenTransferValidator__TokenIsSoulbound();
```

### CreatorTokenTransferValidator__WildcardOperatorsCannotBeAuthorizedForCollection
*Thrown when an authorizer attempts to set a wildcard authorized operator on collections that don't allow wildcards*


```solidity
error CreatorTokenTransferValidator__WildcardOperatorsCannotBeAuthorizedForCollection();
```

### CreatorTokenTransferValidator__AuthorizationDisabledForCollection
*Thrown when attempting to set a authorized operator when authorization mode is disabled.*


```solidity
error CreatorTokenTransferValidator__AuthorizationDisabledForCollection();
```

### CreatorTokenTransferValidator__TokenTypesDoNotMatch
*Thrown when attempting to validate a permitted transfer where the permit type does not match the collection-defined token type.*


```solidity
error CreatorTokenTransferValidator__TokenTypesDoNotMatch();
```

## Structs
### List
*This struct is internally for the storage of account and codehash lists.*


```solidity
struct List {
    EnumerableSet.AddressSet enumerableAccounts;
    EnumerableSet.Bytes32Set enumerableCodehashes;
    mapping(address => bool) nonEnumerableAccounts;
    mapping(bytes32 => bool) nonEnumerableCodehashes;
}
```

### AccountList
*This struct is internally for the storage of account lists.*


```solidity
struct AccountList {
    EnumerableSet.AddressSet enumerableAccounts;
    mapping(address => bool) nonEnumerableAccounts;
}
```

