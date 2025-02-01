# SequentialMintBase
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/minting/SequentialMintBase.sol)

**Author:**
Limit Break, Inc.

*In order to support multiple sequential mint mix-ins in a single contract, the token id counter has been moved to this based contract.*


## State Variables
### nextTokenIdCounter
*The next token id that will be minted - if zero, the next minted token id will be 1*


```solidity
uint256 private nextTokenIdCounter;
```


## Functions
### _initializeNextTokenIdCounter

*Minting mixins must use this function to advance the next token id counter.*


```solidity
function _initializeNextTokenIdCounter() internal;
```

### _advanceNextTokenIdCounter

*Minting mixins must use this function to advance the next token id counter.*


```solidity
function _advanceNextTokenIdCounter(uint256 amount) internal;
```

### getNextTokenId

*Returns the next token id counter value*


```solidity
function getNextTokenId() public view returns (uint256);
```

