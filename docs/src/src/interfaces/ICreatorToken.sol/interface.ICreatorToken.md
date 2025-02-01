# ICreatorToken
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/interfaces/ICreatorToken.sol)


## Functions
### getTransferValidator


```solidity
function getTransferValidator() external view returns (address validator);
```

### setTransferValidator


```solidity
function setTransferValidator(address validator) external;
```

### getTransferValidationFunction


```solidity
function getTransferValidationFunction() external view returns (bytes4 functionSignature, bool isViewFunction);
```

## Events
### TransferValidatorUpdated

```solidity
event TransferValidatorUpdated(address oldValidator, address newValidator);
```

