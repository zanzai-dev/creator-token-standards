# Quest
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/adventures/Quest.sol)

**Author:**
Limit Break, Inc.

Quest data structure for {IAdventurous} contracts.


```solidity
struct Quest {
    bool isActive;
    uint32 questId;
    uint64 startTimestamp;
    uint32 arrayIndex;
}
```

