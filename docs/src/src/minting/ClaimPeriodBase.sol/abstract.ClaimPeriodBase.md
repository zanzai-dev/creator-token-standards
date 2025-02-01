# ClaimPeriodBase
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/minting/ClaimPeriodBase.sol)

**Inherits:**
[OwnablePermissions](/src/access/OwnablePermissions.sol/abstract.OwnablePermissions.md)

**Author:**
Limit Break, Inc.

In order to support multiple contracts with enforced claim periods, the claim period has been moved to this base contract.


## State Variables
### claimPeriodInitialized
*True if claims have been initalized, false otherwise.*


```solidity
bool private claimPeriodInitialized;
```


### claimPeriodClosingTimestamp
*The timestamp when the claim period closes - when this value is zero and claims are open, the claim period is open indefinitely*


```solidity
uint256 private claimPeriodClosingTimestamp;
```


## Functions
### openClaims

*Opens the claim period.  Claims can be closed with a custom amount of warning time using the closeClaims function.
Accepts a claimPeriodClosingTimestamp_ timestamp which will open the period ending at that time (in seconds)
NOTE: Use as high a window as possible to prevent gas wars for claiming
For an unbounded claim window, pass in type(uint256).max*


```solidity
function openClaims(uint256 claimPeriodClosingTimestamp_) external;
```

### closeClaims

*Closes claims at a specified timestamp.
Throws when the specified timestamp is not in the future.*


```solidity
function closeClaims(uint256 claimPeriodClosingTimestamp_) external;
```

### getClaimPeriodClosingTimestamp

*Returns the Claim Period Timestamp*


```solidity
function getClaimPeriodClosingTimestamp() external view returns (uint256);
```

### isClaimPeriodOpen

Returns true if the claim period has been opened, false otherwise


```solidity
function isClaimPeriodOpen() external view returns (bool);
```

### _isClaimPeriodOpen

*Returns true if claim period is open, false otherwise.*


```solidity
function _isClaimPeriodOpen() internal view returns (bool);
```

### _requireClaimsOpen

*Validates that the claim period is open.
Throws if claims are not open.*


```solidity
function _requireClaimsOpen() internal view;
```

### _onClaimPeriodOpening

*Hook to allow inheriting contracts to perform state validation when opening the claim period*


```solidity
function _onClaimPeriodOpening() internal virtual;
```

## Events
### ClaimPeriodClosing
*Emitted when a claim period is scheduled to be closed.*


```solidity
event ClaimPeriodClosing(uint256 claimPeriodClosingTimestamp);
```

### ClaimPeriodOpened
*Emitted when a claim period is scheduled to be opened.*


```solidity
event ClaimPeriodOpened(uint256 claimPeriodClosingTimestamp);
```

## Errors
### ClaimPeriodBase__ClaimsMustBeClosedToReopen

```solidity
error ClaimPeriodBase__ClaimsMustBeClosedToReopen();
```

### ClaimPeriodBase__ClaimPeriodIsNotOpen

```solidity
error ClaimPeriodBase__ClaimPeriodIsNotOpen();
```

### ClaimPeriodBase__ClaimPeriodMustBeClosedInTheFuture

```solidity
error ClaimPeriodBase__ClaimPeriodMustBeClosedInTheFuture();
```

