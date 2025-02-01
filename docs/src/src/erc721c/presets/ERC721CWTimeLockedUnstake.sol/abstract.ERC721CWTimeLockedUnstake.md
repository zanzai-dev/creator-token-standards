# ERC721CWTimeLockedUnstake
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/erc721c/presets/ERC721CWTimeLockedUnstake.sol)

**Inherits:**
[ERC721CW](/src/erc721c/extensions/ERC721CW.sol/abstract.ERC721CW.md)

**Author:**
Limit Break, Inc.

Extension of ERC721C that enforces a time lock to unstake the wrapped token.


## State Variables
### timelockSeconds
*The amount of time the token is locked before unstaking is permitted.  This cannot be modified after contract creation.*


```solidity
uint256 private immutable timelockSeconds;
```


### stakedTimestamps
*Mapping of token ids to the timestamps when they were staked.*


```solidity
mapping(uint256 => uint256) private stakedTimestamps;
```


## Functions
### constructor


```solidity
constructor(uint256 timelockSeconds_, address wrappedCollectionAddress_, string memory name_, string memory symbol_)
    ERC721CW(wrappedCollectionAddress_)
    ERC721OpenZeppelin(name_, symbol_);
```

### getTimelockSeconds

Returns the timelock duration, in seconds.


```solidity
function getTimelockSeconds() external view returns (uint256);
```

### getStakedTimestamp

Returns the timestamp at which the specified token id was staked.


```solidity
function getStakedTimestamp(uint256 tokenId) external view returns (uint256);
```

### canUnstake

Unstakeable after timelock elapses


```solidity
function canUnstake(uint256 tokenId) public view virtual override returns (bool);
```

### _onStake

*Records the block timestamp when the token was staked.*


```solidity
function _onStake(uint256 tokenId, uint256 value) internal virtual override;
```

### _onUnstake

*Reverts if the unstaking timelock has not expired.*


```solidity
function _onUnstake(uint256 tokenId, uint256 value) internal virtual override;
```

## Errors
### ERC721CWTimeLockedUnstake__TimelockHasNotExpired

```solidity
error ERC721CWTimeLockedUnstake__TimelockHasNotExpired();
```

