# CreatorTokenTransferValidatorConfiguration
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/utils/CreatorTokenTransferValidatorConfiguration.sol)

**Inherits:**
Ownable


## State Variables
### configurationInitialized

```solidity
bool configurationInitialized;
```


### nativeValueToCheckPauseState

```solidity
uint256 private nativeValueToCheckPauseState;
```


## Functions
### constructor


```solidity
constructor(address defaultOwner);
```

### setNativeValueToCheckPauseState


```solidity
function setNativeValueToCheckPauseState(uint256 _nativeValueToCheckPauseState) external onlyOwner;
```

### getNativeValueToCheckPauseState


```solidity
function getNativeValueToCheckPauseState() external view returns (uint256 _nativeValueToCheckPauseState);
```

## Errors
### CreatorTokenTransferValidatorConfiguration__ConfigurationNotInitialized

```solidity
error CreatorTokenTransferValidatorConfiguration__ConfigurationNotInitialized();
```

