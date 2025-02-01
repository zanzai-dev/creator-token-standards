# EOARegistry
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/utils/EOARegistry.sol)

**Inherits:**
ERC165, [IEOARegistry](/src/interfaces/IEOARegistry.sol/interface.IEOARegistry.md)

**Author:**
Limit Break, Inc.

A registry that may be used globally by any smart contract that limits contract interactions to verified EOA addresses only.

*Take care and carefully consider whether or not to use this. Restricting operations to EOA only accounts can break Defi composability,
so if Defi composability is an objective, this is not a good option.  Be advised that in the future, EOA accounts might not be a thing
but this is yet to be determined.  See https://eips.ethereum.org/EIPS/eip-4337 for more information.*


## State Variables
### signedMessageHash
*A pre-cached signed message hash used for gas-efficient signature recovery*


```solidity
bytes32 private immutable signedMessageHash;
```


### MESSAGE_TO_SIGN
*The plain text message to sign for signature verification*


```solidity
string public constant MESSAGE_TO_SIGN = "EOA";
```


### eoaSignatureVerified
*Mapping of accounts that to signature verification status*


```solidity
mapping(address => bool) private eoaSignatureVerified;
```


## Functions
### constructor


```solidity
constructor();
```

### verifySignature

Allows a user to verify an ECDSA signature to definitively prove they are an EOA account.
Postconditions:
---------------
The verified signature mapping has been updated to `true` for the caller.


```solidity
function verifySignature(bytes calldata signature) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`signature`|`bytes`| The signature supplied as a bytes array by an EOA to verify their address is an EOA.|


### verifySignatureVRS

Allows a user to verify an ECDSA signature to definitively prove they are an EOA account.
This version is passed the v, r, s components of the signature, and is slightly more gas efficient than
calculating the v, r, s components on-chain.  Any user can submit a signature for any other user.
Postconditions:
---------------
The verified signature mapping has been updated to `true` for the caller.


```solidity
function verifySignatureVRS(uint8 v, bytes32 r, bytes32 s) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`v`|`uint8`| The signature v component supplied by an EOA to verify their address is an EOA.|
|`r`|`bytes32`| The signature r component supplied by an EOA to verify their address is an EOA.|
|`s`|`bytes32`| The signature s component supplied by an EOA to verify their address is an EOA.|


### isVerifiedEOA

Returns true if the specified account has verified a signature on this registry, false otherwise.


```solidity
function isVerifiedEOA(address account) public view override returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`account`|`address`| The address to check to see if it has verified as an EOA.|


### supportsInterface

*ERC-165 interface support*


```solidity
function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`interfaceId`|`bytes4`| The identifier of the interface to check if this contract supports it.|


## Events
### VerifiedEOASignature
*Emitted whenever a user verifies that they are an EOA by submitting their signature.*


```solidity
event VerifiedEOASignature(address indexed account);
```

