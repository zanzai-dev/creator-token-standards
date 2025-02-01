# AdventureBase
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/adventures/AdventureERC721.sol)

**Inherits:**
[AdventureWhitelist](/src/adventures/AdventureWhitelist.sol/abstract.AdventureWhitelist.md), [IAdventurous](/src/adventures/IAdventurous.sol/interface.IAdventurous.md)

**Author:**
Limit Break, Inc.

Base functionality of the AdventureERC721 token standard.


## State Variables
### MAX_CONCURRENT_QUESTS
Specifies an upper bound for the maximum number of simultaneous quests per adventure.


```solidity
uint256 private constant MAX_CONCURRENT_QUESTS = 100;
```


### TRANSFERRING_VIA_ERC721
*A value denoting a transfer originating from transferFrom or safeTransferFrom*


```solidity
uint256 internal constant TRANSFERRING_VIA_ERC721 = 1;
```


### TRANSFERRING_VIA_ADVENTURE
*A value denoting a transfer originating from adventureTransferFrom or adventureSafeTransferFrom*


```solidity
uint256 internal constant TRANSFERRING_VIA_ADVENTURE = 2;
```


### _maxSimultaneousQuests
*The most simultaneous quests the token may participate in at a time*


```solidity
uint256 private _maxSimultaneousQuests;
```


### transferType
*Specifies the type of transfer that is actively being used*


```solidity
uint256 internal transferType;
```


### blockingQuestCounts
*Maps each token id to the number of blocking quests it is currently entered into*


```solidity
mapping(uint256 => uint256) internal blockingQuestCounts;
```


### operatorAdventureApprovals
*Mapping from owner to operator approvals for special gameplay behavior*


```solidity
mapping(address => mapping(address => bool)) private operatorAdventureApprovals;
```


### activeQuestList
*Maps each token id to a mapping that can enumerate all active quests within an adventure*


```solidity
mapping(uint256 => mapping(address => uint32[])) public activeQuestList;
```


### activeQuestLookup
*Maps each token id to a mapping from adventure address to a mapping of quest ids to quest details*


```solidity
mapping(uint256 => mapping(address => mapping(uint32 => Quest))) public activeQuestLookup;
```


## Functions
### adventureTransferFrom

Transfers a player's token if they have opted into an authorized, whitelisted adventure.


```solidity
function adventureTransferFrom(address from, address to, uint256 tokenId) external override;
```

### adventureSafeTransferFrom

Safe transfers a player's token if they have opted into an authorized, whitelisted adventure.


```solidity
function adventureSafeTransferFrom(address from, address to, uint256 tokenId) external override;
```

### adventureBurn

Burns a player's token if they have opted into an authorized, whitelisted adventure.


```solidity
function adventureBurn(uint256 tokenId) external override;
```

### enterQuest

Enters a player's token into a quest if they have opted into an authorized, whitelisted adventure.


```solidity
function enterQuest(uint256 tokenId, uint256 questId) external override;
```

### exitQuest

Exits a player's token from a quest if they have opted into an authorized, whitelisted adventure.
For developers of adventure contracts that perform adventure burns, be aware that the adventure must exitQuest
before the adventure burn occurs, as _exitQuest emits the owner of the token, which would revert after burning.


```solidity
function exitQuest(uint256 tokenId, uint256 questId) external override;
```

### bootFromAllQuests

Admin-only ability to boot a token from all quests on an adventure.
This ability is only unlocked in the event that an adventure has been unwhitelisted, as early exiting
from quests can cause out of sync state between the ERC721 token contract and the adventure/quest.


```solidity
function bootFromAllQuests(uint256 tokenId, address adventure) external;
```

### userExitQuest

Gives the player the ability to exit a quest without interacting directly with the approved, whitelisted adventure
This ability is only unlocked in the event that an adventure has been unwhitelisted, as early exiting
from quests can cause out of sync state between the ERC721 token contract and the adventure/quest.


```solidity
function userExitQuest(uint256 tokenId, address adventure, uint256 questId) external;
```

### userExitAllQuests

Gives the player the ability to exit all quests on an adventure without interacting directly with the approved, whitelisted adventure
This ability is only unlocked in the event that an adventure has been unwhitelisted, as early exiting
from quests can cause out of sync state between the ERC721 token contract and the adventure/quest.


```solidity
function userExitAllQuests(uint256 tokenId, address adventure) external;
```

### setAdventuresApprovedForAll

Similar to [IERC721-setApprovalForAll](/lib/murky/lib/forge-std/src/interfaces/IERC1155.sol/interface.IERC1155.md#setapprovalforall), but for special in-game adventures only


```solidity
function setAdventuresApprovedForAll(address operator, bool approved) external;
```

### areAdventuresApprovedForAll

Similar to [IERC721-isApprovedForAll](/lib/murky/lib/forge-std/src/interfaces/IERC1155.sol/interface.IERC1155.md#isapprovedforall), but for special in-game adventures only


```solidity
function areAdventuresApprovedForAll(address owner_, address operator) public view returns (bool);
```

### getQuestCount

Returns the number of quests a token is actively participating in for a specified adventure


```solidity
function getQuestCount(uint256 tokenId, address adventure) public view override returns (uint256);
```

### getTimeOnQuest

Returns the amount of time a token has been participating in the specified quest


```solidity
function getTimeOnQuest(uint256 tokenId, address adventure, uint256 questId) public view override returns (uint256);
```

### isParticipatingInQuest

Returns whether or not a token is currently participating in the specified quest as well as the time it was started and the quest index


```solidity
function isParticipatingInQuest(uint256 tokenId, address adventure, uint256 questId)
    public
    view
    override
    returns (bool participatingInQuest, uint256 startTimestamp, uint256 index);
```

### getActiveQuests

Returns a list of all active quests for the specified token id and adventure


```solidity
function getActiveQuests(uint256 tokenId, address adventure)
    public
    view
    override
    returns (Quest[] memory activeQuests);
```

### maxSimultaneousQuests


```solidity
function maxSimultaneousQuests() public view virtual returns (uint256);
```

### _enterQuest

*Enters the specified quest for a token id.
Throws if the token is already participating in the specified quest.
Throws if the number of active quests exceeds the max allowable for the given adventure.
Emits a QuestUpdated event for off-chain processing.*


```solidity
function _enterQuest(uint256 tokenId, address adventure, uint256 questId) internal;
```

### _exitQuest

*Exits the specified quest for a token id.
Throws if the token is not currently participating on the specified quest.
Emits a QuestUpdated event for off-chain processing.*


```solidity
function _exitQuest(uint256 tokenId, address adventure, uint256 questId) internal;
```

### _exitAllQuests

*Removes the specified token id from all quests on the specified adventure*


```solidity
function _exitAllQuests(uint256 tokenId, address adventure, bool booted) internal;
```

### _requireCallerApprovedForAdventure

*Validates that the caller is approved for adventure on the specified token id
Throws when the caller has not been approved by the user.*


```solidity
function _requireCallerApprovedForAdventure(uint256 tokenId) internal view;
```

### _requireCallerOwnsToken

*Validates that the caller owns the specified token
Throws when the caller does not own the specified token.*


```solidity
function _requireCallerOwnsToken(uint256 tokenId) internal view;
```

### _validateMaxSimultaneousQuests

*Validates that the specified value of max simultaneous quests is in range [1-MAX_CONCURRENT_QUESTS]
Throws when `maxSimultaneousQuests_` is zero.
Throws when `maxSimultaneousQuests_` is more than MAX_CONCURRENT_QUESTS.*


```solidity
function _validateMaxSimultaneousQuests(uint256 maxSimultaneousQuests_) internal pure;
```

### _setMaxSimultaneousQuestsAndInitializeTransferType


```solidity
function _setMaxSimultaneousQuestsAndInitializeTransferType(uint256 maxSimultaneousQuests_) internal;
```

### _doBurn


```solidity
function _doBurn(uint256 tokenId) internal virtual;
```

### _doTransfer


```solidity
function _doTransfer(address from, address to, uint256 tokenId) internal virtual;
```

### _doSafeTransfer


```solidity
function _doSafeTransfer(address from, address to, uint256 tokenId, bytes memory data) internal virtual;
```

### _ownerOfToken


```solidity
function _ownerOfToken(uint256 tokenId) internal view virtual returns (address);
```

## Errors
### AdventureERC721__AdventureApprovalToCaller

```solidity
error AdventureERC721__AdventureApprovalToCaller();
```

### AdventureERC721__AlreadyOnQuest

```solidity
error AdventureERC721__AlreadyOnQuest();
```

### AdventureERC721__AnActiveQuestIsPreventingTransfers

```solidity
error AdventureERC721__AnActiveQuestIsPreventingTransfers();
```

### AdventureERC721__CallerNotApprovedForAdventure

```solidity
error AdventureERC721__CallerNotApprovedForAdventure();
```

### AdventureERC721__CallerNotTokenOwner

```solidity
error AdventureERC721__CallerNotTokenOwner();
```

### AdventureERC721__MaxSimultaneousQuestsCannotBeZero

```solidity
error AdventureERC721__MaxSimultaneousQuestsCannotBeZero();
```

### AdventureERC721__MaxSimultaneousQuestsExceeded

```solidity
error AdventureERC721__MaxSimultaneousQuestsExceeded();
```

### AdventureERC721__NotOnQuest

```solidity
error AdventureERC721__NotOnQuest();
```

### AdventureERC721__QuestIdOutOfRange

```solidity
error AdventureERC721__QuestIdOutOfRange();
```

### AdventureERC721__TooManyActiveQuests

```solidity
error AdventureERC721__TooManyActiveQuests();
```

