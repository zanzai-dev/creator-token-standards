# IAdventurous
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/adventures/IAdventurous.sol)

**Inherits:**
IERC165

**Author:**
Limit Break, Inc.

The base interface that all `Adventurous` token contracts must conform to in order to support adventures and quests.

*All contracts that support adventures and quests are required to implement this interface.*


## Functions
### adventureTransferFrom

Transfers a player's token if they have opted into an authorized, whitelisted adventure.


```solidity
function adventureTransferFrom(address from, address to, uint256 tokenId) external;
```

### adventureSafeTransferFrom

Safe transfers a player's token if they have opted into an authorized, whitelisted adventure.


```solidity
function adventureSafeTransferFrom(address from, address to, uint256 tokenId) external;
```

### adventureBurn

Burns a player's token if they have opted into an authorized, whitelisted adventure.


```solidity
function adventureBurn(uint256 tokenId) external;
```

### enterQuest

Enters a player's token into a quest if they have opted into an authorized, whitelisted adventure.


```solidity
function enterQuest(uint256 tokenId, uint256 questId) external;
```

### exitQuest

Exits a player's token from a quest if they have opted into an authorized, whitelisted adventure.


```solidity
function exitQuest(uint256 tokenId, uint256 questId) external;
```

### getQuestCount

Returns the number of quests a token is actively participating in for a specified adventure


```solidity
function getQuestCount(uint256 tokenId, address adventure) external view returns (uint256);
```

### getTimeOnQuest

Returns the amount of time a token has been participating in the specified quest


```solidity
function getTimeOnQuest(uint256 tokenId, address adventure, uint256 questId) external view returns (uint256);
```

### isParticipatingInQuest

Returns whether or not a token is currently participating in the specified quest as well as the time it was started and the quest index


```solidity
function isParticipatingInQuest(uint256 tokenId, address adventure, uint256 questId)
    external
    view
    returns (bool participatingInQuest, uint256 startTimestamp, uint256 index);
```

### getActiveQuests

Returns a list of all active quests for the specified token id and adventure


```solidity
function getActiveQuests(uint256 tokenId, address adventure) external view returns (Quest[] memory activeQuests);
```

## Events
### AdventureApprovalForAll
*Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets, for special in-game adventures.*


```solidity
event AdventureApprovalForAll(address indexed tokenOwner, address indexed operator, bool approved);
```

### QuestUpdated
*Emitted when a token enters or exits a quest*


```solidity
event QuestUpdated(
    uint256 indexed tokenId,
    address indexed tokenOwner,
    address indexed adventure,
    uint256 questId,
    bool active,
    bool booted
);
```

