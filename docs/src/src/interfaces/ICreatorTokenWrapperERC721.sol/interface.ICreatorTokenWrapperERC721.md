# ICreatorTokenWrapperERC721
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/interfaces/ICreatorTokenWrapperERC721.sol)

**Inherits:**
[ICreatorToken](/src/interfaces/ICreatorToken.sol/interface.ICreatorToken.md)


## Functions
### stake


```solidity
function stake(uint256 tokenId) external payable;
```

### stakeTo


```solidity
function stakeTo(uint256 tokenId, address to) external payable;
```

### unstake


```solidity
function unstake(uint256 tokenId) external payable;
```

### canUnstake


```solidity
function canUnstake(uint256 tokenId) external view returns (bool);
```

### getStakerConstraints


```solidity
function getStakerConstraints() external view returns (StakerConstraints);
```

### getWrappedCollectionAddress


```solidity
function getWrappedCollectionAddress() external view returns (address);
```

## Events
### Staked

```solidity
event Staked(uint256 indexed tokenId, address indexed account);
```

### Unstaked

```solidity
event Unstaked(uint256 indexed tokenId, address indexed account);
```

### StakerConstraintsSet

```solidity
event StakerConstraintsSet(StakerConstraints stakerConstraints);
```

