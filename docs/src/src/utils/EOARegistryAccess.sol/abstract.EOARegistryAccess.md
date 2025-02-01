# EOARegistryAccess
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/utils/EOARegistryAccess.sol)

**Inherits:**
Ownable

**Author:**
Limit Break, Inc.

A contract mixin that provides access to an external EOA registry.
For use when a contract needs the ability to check if an address is a verified EOA.

*Take care and carefully consider whether or not to use this. Restricting operations to EOA only accounts can break Defi composability,
so if Defi composability is an objective, this is not a good option.  Be advised that in the future, EOA accounts might not be a thing
but this is yet to be determined.  See https://eips.ethereum.org/EIPS/eip-4337 for more information.*


## State Variables
### eoaRegistry
*Points to an external contract that implements the `IEOARegistry` interface.*


```solidity
IEOARegistry private eoaRegistry;
```


## Functions
### setEOARegistry

Allows contract owner to set the pointer to the EOA registry.
Throws when the specified address in non-zero and does not implement `IEOARegistry`.
Throws when caller is not the contract owner.
Postconditions:
---------------
The eoa registry address is set to the specified address.
An `EOARegistryUpdated` event has been emitted.


```solidity
function setEOARegistry(address eoaRegistry_) public onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`eoaRegistry_`|`address`|The address of the EOA Registry to set for verified EOA lookups.|


### getEOARegistry

Returns the address of the EOA registry.


```solidity
function getEOARegistry() public view returns (IEOARegistry);
```

## Events
### EOARegistryUpdated
*Emitted whenever the contract owner changes the EOA registry*


```solidity
event EOARegistryUpdated(address oldRegistry, address newRegistry);
```

## Errors
### InvalidEOARegistryContract
*Thrown when the EOA Registry address being set does not implement the `IEOARegistry` interface.*


```solidity
error InvalidEOARegistryContract();
```

