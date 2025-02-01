# ERC1155CInitializable
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/erc1155c/ERC1155C.sol)

**Inherits:**
[ERC1155OpenZeppelinInitializable](/src/token/erc1155/ERC1155OpenZeppelin.sol/abstract.ERC1155OpenZeppelinInitializable.md), [CreatorTokenBase](/src/utils/CreatorTokenBase.sol/abstract.CreatorTokenBase.md), [AutomaticValidatorTransferApproval](/src/utils/AutomaticValidatorTransferApproval.sol/abstract.AutomaticValidatorTransferApproval.md)

**Author:**
Limit Break, Inc.

Initializable implementation of ERC1155C to allow for EIP-1167 proxy clones.


## Functions
### initializeERC1155


```solidity
function initializeERC1155(string memory uri_) public override;
```

### isApprovedForAll

Overrides behavior of isApprovedFor all such that if an operator is not explicitly approved
for all, the contract owner can optionally auto-approve the 721-C transfer validator for transfers.


```solidity
function isApprovedForAll(address owner, address operator) public view virtual override returns (bool isApproved);
```

### supportsInterface

Indicates whether the contract implements the specified interface.

*Overrides supportsInterface in ERC165.*


```solidity
function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`interfaceId`|`bytes4`|The interface id|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|true if the contract implements the specified interface, false otherwise|


### getTransferValidationFunction

Returns the function selector for the transfer validator's validation function to be called

for transaction simulation.


```solidity
function getTransferValidationFunction() external pure returns (bytes4 functionSignature, bool isViewFunction);
```

### _beforeTokenTransfer

*Ties the open-zeppelin _beforeTokenTransfer hook to more granular transfer validation logic*


```solidity
function _beforeTokenTransfer(
    address,
    address from,
    address to,
    uint256[] memory ids,
    uint256[] memory amounts,
    bytes memory
) internal virtual override;
```

### _afterTokenTransfer

*Ties the open-zeppelin _afterTokenTransfer hook to more granular transfer validation logic*


```solidity
function _afterTokenTransfer(
    address,
    address from,
    address to,
    uint256[] memory ids,
    uint256[] memory amounts,
    bytes memory
) internal virtual override;
```

### _tokenType


```solidity
function _tokenType() internal pure override returns (uint16);
```

