# IPaymentSplitterInitializable
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/programmable-royalties/helpers/IPaymentSplitterInitializable.sol)


## Functions
### totalShares


```solidity
function totalShares() external view returns (uint256);
```

### totalReleased


```solidity
function totalReleased() external view returns (uint256);
```

### totalReleased


```solidity
function totalReleased(IERC20 token) external view returns (uint256);
```

### shares


```solidity
function shares(address account) external view returns (uint256);
```

### released


```solidity
function released(address account) external view returns (uint256);
```

### released


```solidity
function released(IERC20 token, address account) external view returns (uint256);
```

### payee


```solidity
function payee(uint256 index) external view returns (address);
```

### releasable


```solidity
function releasable(address account) external view returns (uint256);
```

### releasable


```solidity
function releasable(IERC20 token, address account) external view returns (uint256);
```

### initializePaymentSplitter


```solidity
function initializePaymentSplitter(address[] calldata payees, uint256[] calldata shares_) external;
```

### release


```solidity
function release(address payable account) external;
```

### release


```solidity
function release(IERC20 token, address account) external;
```

