# AdventureWhitelist
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/adventures/AdventureWhitelist.sol)

**Inherits:**
[OwnablePermissions](/src/access/OwnablePermissions.sol/abstract.OwnablePermissions.md)

**Author:**
Limit Break, Inc.

Implements the basic security features of the {IAdventurous} token standard for ERC721-compliant tokens.
This includes a whitelist for trusted Adventure contracts designed to interoperate with this token.


## State Variables
### whitelistedAdventureList
*Whitelist array for iteration*


```solidity
address[] public whitelistedAdventureList;
```


### whitelistedAdventures
*Whitelist mapping*


```solidity
mapping(address => AdventureDetails) public whitelistedAdventures;
```


## Functions
### isAdventureWhitelisted

Returns whether the specified account is a whitelisted adventure


```solidity
function isAdventureWhitelisted(address account) public view returns (bool);
```

### whitelistAdventure

Whitelists an adventure and specifies whether or not the quests in that adventure lock token transfers
Throws when the adventure is already in the whitelist.
Throws when the specified address does not implement the IAdventure interface.
Postconditions:
The specified adventure contract is in the whitelist.
An `AdventureWhitelistUpdate` event has been emitted.


```solidity
function whitelistAdventure(address adventure) external;
```

### unwhitelistAdventure

Removes an adventure from the whitelist
Throws when the adventure is not in the whitelist.
Postconditions:
The specified adventure contract is no longer in the whitelist.
An `AdventureWhitelistUpdate` event has been emitted.


```solidity
function unwhitelistAdventure(address adventure) external;
```

### _requireCallerIsWhitelistedAdventure

*Validates that the caller is a whitelisted adventure
Throws when the caller is not in the adventure whitelist.*


```solidity
function _requireCallerIsWhitelistedAdventure() internal view;
```

### _requireAdventureRemovedFromWhitelist

*Validates that the specified adventure has been removed from the whitelist
to prevent early backdoor exiting from adventures.
Throws when specified adventure is still whitelisted.*


```solidity
function _requireAdventureRemovedFromWhitelist(address adventure) internal view;
```

## Events
### AdventureWhitelistUpdated
*Emitted when the adventure whitelist is updated*


```solidity
event AdventureWhitelistUpdated(address indexed adventure, bool whitelisted);
```

## Errors
### AdventureWhitelist__AdventureIsStillWhitelisted

```solidity
error AdventureWhitelist__AdventureIsStillWhitelisted();
```

### AdventureWhitelist__AlreadyWhitelisted

```solidity
error AdventureWhitelist__AlreadyWhitelisted();
```

### AdventureWhitelist__ArrayIndexOverflowsUint128

```solidity
error AdventureWhitelist__ArrayIndexOverflowsUint128();
```

### AdventureWhitelist__CallerNotAWhitelistedAdventure

```solidity
error AdventureWhitelist__CallerNotAWhitelistedAdventure();
```

### AdventureWhitelist__InvalidAdventureContract

```solidity
error AdventureWhitelist__InvalidAdventureContract();
```

### AdventureWhitelist__NotWhitelisted

```solidity
error AdventureWhitelist__NotWhitelisted();
```

## Structs
### AdventureDetails

```solidity
struct AdventureDetails {
    bool isWhitelisted;
    uint128 arrayIndex;
}
```

