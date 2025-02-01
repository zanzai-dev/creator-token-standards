# IAdventure
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/adventures/IAdventure.sol)

**Inherits:**
IERC165

**Author:**
Limit Break, Inc.

The base interface that all `Adventure` contracts must conform to.

*All contracts that implement the adventure/quest system and interact with an {IAdventurous} token are required to implement this interface.*


## Functions
### questsLockTokens

*Returns whether or not quests on this adventure lock tokens.
Developers of adventure contract should ensure that this is immutable
after deployment of the adventure contract.  Failure to do so
can lead to error that deadlock token transfers.*


```solidity
function questsLockTokens() external view returns (bool);
```

### onQuestEntered

*A callback function that AdventureERC721 must invoke when a quest has been successfully entered.
Throws if the caller is not an expected AdventureERC721 contract designed to work with the Adventure.
Not permitted to throw in any other case, as this could lead to tokens being locked in quests.*


```solidity
function onQuestEntered(address adventurer, uint256 tokenId, uint256 questId) external;
```

### onQuestExited

*A callback function that AdventureERC721 must invoke when a quest has been successfully exited.
Throws if the caller is not an expected AdventureERC721 contract designed to work with the Adventure.
Not permitted to throw in any other case, as this could lead to tokens being locked in quests.*


```solidity
function onQuestExited(address adventurer, uint256 tokenId, uint256 questId, uint256 questStartTimestamp) external;
```

