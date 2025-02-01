# ICreatorTokenWrapperERC1155
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/interfaces/ICreatorTokenWrapperERC1155.sol)

**Inherits:**
[ICreatorToken](/src/interfaces/ICreatorToken.sol/interface.ICreatorToken.md)


## Functions
### stake


```solidity
function stake(uint256 tokenId, uint256 amount) external payable;
```

### stakeTo


```solidity
function stakeTo(uint256 tokenId, uint256 amount, address to) external payable;
```

### unstake


```solidity
function unstake(uint256 tokenId, uint256 amount) external payable;
```

### canUnstake


```solidity
function canUnstake(uint256 tokenId, uint256 amount) external view returns (bool);
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
event Staked(uint256 indexed id, address indexed account, uint256 amount);
```

### Unstaked

```solidity
event Unstaked(uint256 indexed id, address indexed account, uint256 amount);
```

### StakerConstraintsSet

```solidity
event StakerConstraintsSet(StakerConstraints stakerConstraints);
```

