# Constants
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/Constants.sol)

### RECEIVER_CONSTRAINTS_NONE
*Constant definitions for receiver constraints used by the transfer validator.*

*No constraints on the receiver of a token.*


```solidity
uint256 constant RECEIVER_CONSTRAINTS_NONE = 0;
```

### RECEIVER_CONSTRAINTS_NO_CODE
*Token receiver cannot have deployed code.*


```solidity
uint256 constant RECEIVER_CONSTRAINTS_NO_CODE = 1;
```

### RECEIVER_CONSTRAINTS_EOA
*Token receiver must be a verified EOA with the EOA Registry.*


```solidity
uint256 constant RECEIVER_CONSTRAINTS_EOA = 2;
```

### RECEIVER_CONSTRAINTS_SBT
*Token is a soulbound token and cannot be transferred.*


```solidity
uint256 constant RECEIVER_CONSTRAINTS_SBT = 3;
```

### CALLER_CONSTRAINTS_NONE
*Constant definitions for caller constraints used by the transfer validator.*

*No constraints on the caller of a token transfer.*


```solidity
uint256 constant CALLER_CONSTRAINTS_NONE = 0;
```

### CALLER_CONSTRAINTS_OPERATOR_BLACKLIST_ENABLE_OTC
*Caller of a token transfer must not be on the blacklist unless it is an OTC transfer.*


```solidity
uint256 constant CALLER_CONSTRAINTS_OPERATOR_BLACKLIST_ENABLE_OTC = 1;
```

### CALLER_CONSTRAINTS_OPERATOR_WHITELIST_ENABLE_OTC
*Caller of a token transfer must be on the whitelist unless it is an OTC transfer.*


```solidity
uint256 constant CALLER_CONSTRAINTS_OPERATOR_WHITELIST_ENABLE_OTC = 2;
```

### CALLER_CONSTRAINTS_OPERATOR_WHITELIST_DISABLE_OTC
*Caller of a token transfer must be on the whitelist.*


```solidity
uint256 constant CALLER_CONSTRAINTS_OPERATOR_WHITELIST_DISABLE_OTC = 3;
```

### CALLER_CONSTRAINTS_SBT
*Token is a soulbound token and cannot be transferred.*


```solidity
uint256 constant CALLER_CONSTRAINTS_SBT = 4;
```

### TRANSFER_SECURITY_LEVEL_RECOMMENDED
*Constant definitions for transfer security levels used by the transfer validator
to define what receiver and caller constraints are applied to a transfer.*

*Recommend Security Level -
Caller Constraints: Operator Whitelist
Receiver Constraints: None
OTC: Allowed*


```solidity
uint8 constant TRANSFER_SECURITY_LEVEL_RECOMMENDED = 0;
```

### TRANSFER_SECURITY_LEVEL_ONE
*Security Level One -
Caller Constraints: None
Receiver Constraints: None
OTC: Allowed*


```solidity
uint8 constant TRANSFER_SECURITY_LEVEL_ONE = 1;
```

### TRANSFER_SECURITY_LEVEL_TWO
*Security Level Two -
Caller Constraints: Operator Blacklist
Receiver Constraints: None
OTC: Allowed*


```solidity
uint8 constant TRANSFER_SECURITY_LEVEL_TWO = 2;
```

### TRANSFER_SECURITY_LEVEL_THREE
*Security Level Three -
Caller Constraints: Operator Whitelist
Receiver Constraints: None
OTC: Allowed*


```solidity
uint8 constant TRANSFER_SECURITY_LEVEL_THREE = 3;
```

### TRANSFER_SECURITY_LEVEL_FOUR
*Security Level Four -
Caller Constraints: Operator Whitelist
Receiver Constraints: None
OTC: Not Allowed*


```solidity
uint8 constant TRANSFER_SECURITY_LEVEL_FOUR = 4;
```

### TRANSFER_SECURITY_LEVEL_FIVE
*Security Level Five -
Caller Constraints: Operator Whitelist
Receiver Constraints: No Code
OTC: Allowed*


```solidity
uint8 constant TRANSFER_SECURITY_LEVEL_FIVE = 5;
```

### TRANSFER_SECURITY_LEVEL_SIX
*Security Level Six -
Caller Constraints: Operator Whitelist
Receiver Constraints: Verified EOA
OTC: Allowed*


```solidity
uint8 constant TRANSFER_SECURITY_LEVEL_SIX = 6;
```

### TRANSFER_SECURITY_LEVEL_SEVEN
*Security Level Seven -
Caller Constraints: Operator Whitelist
Receiver Constraints: No Code
OTC: Not Allowed*


```solidity
uint8 constant TRANSFER_SECURITY_LEVEL_SEVEN = 7;
```

### TRANSFER_SECURITY_LEVEL_EIGHT
*Security Level Eight -
Caller Constraints: Operator Whitelist
Receiver Constraints: Verified EOA
OTC: Not Allowed*


```solidity
uint8 constant TRANSFER_SECURITY_LEVEL_EIGHT = 8;
```

### TRANSFER_SECURITY_LEVEL_NINE
*Security Level Nine -
Soulbound Token, No Transfers Allowed*


```solidity
uint8 constant TRANSFER_SECURITY_LEVEL_NINE = 9;
```

### LIST_TYPE_BLACKLIST
*List type is a blacklist.*


```solidity
uint8 constant LIST_TYPE_BLACKLIST = 0;
```

### LIST_TYPE_WHITELIST
*List type is a whitelist.*


```solidity
uint8 constant LIST_TYPE_WHITELIST = 1;
```

### LIST_TYPE_AUTHORIZERS
*List type is authorizers.*


```solidity
uint8 constant LIST_TYPE_AUTHORIZERS = 2;
```

### SELECTOR_NO_ERROR
*Constant value for the no error selector.*


```solidity
bytes4 constant SELECTOR_NO_ERROR = bytes4(0x00000000);
```

