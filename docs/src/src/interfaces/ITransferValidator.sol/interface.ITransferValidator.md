# ITransferValidator
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/interfaces/ITransferValidator.sol)


## Functions
### applyCollectionTransferPolicy


```solidity
function applyCollectionTransferPolicy(address caller, address from, address to) external view;
```

### validateTransfer


```solidity
function validateTransfer(address caller, address from, address to) external view;
```

### validateTransfer


```solidity
function validateTransfer(address caller, address from, address to, uint256 tokenId) external view;
```

### validateTransfer


```solidity
function validateTransfer(address caller, address from, address to, uint256 tokenId, uint256 amount) external;
```

### beforeAuthorizedTransfer


```solidity
function beforeAuthorizedTransfer(address operator, address token, uint256 tokenId) external;
```

### afterAuthorizedTransfer


```solidity
function afterAuthorizedTransfer(address token, uint256 tokenId) external;
```

### beforeAuthorizedTransfer


```solidity
function beforeAuthorizedTransfer(address operator, address token) external;
```

### afterAuthorizedTransfer


```solidity
function afterAuthorizedTransfer(address token) external;
```

### beforeAuthorizedTransfer


```solidity
function beforeAuthorizedTransfer(address token, uint256 tokenId) external;
```

### beforeAuthorizedTransferWithAmount


```solidity
function beforeAuthorizedTransferWithAmount(address token, uint256 tokenId, uint256 amount) external;
```

### afterAuthorizedTransferWithAmount


```solidity
function afterAuthorizedTransferWithAmount(address token, uint256 tokenId) external;
```

