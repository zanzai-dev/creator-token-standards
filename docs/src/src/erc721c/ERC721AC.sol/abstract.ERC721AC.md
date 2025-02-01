# ERC721AC
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/erc721c/ERC721AC.sol)

**Inherits:**
ERC721A, [CreatorTokenBase](/src/utils/CreatorTokenBase.sol/abstract.CreatorTokenBase.md), [AutomaticValidatorTransferApproval](/src/utils/AutomaticValidatorTransferApproval.sol/abstract.AutomaticValidatorTransferApproval.md)

**Author:**
Limit Break, Inc.

Extends Azuki's ERC721-A implementation with Creator Token functionality, which
allows the contract owner to update the transfer validation logic by managing a security policy in
an external transfer validation security policy registry.  See {CreatorTokenTransferValidator}.


## Functions
### constructor


```solidity
constructor(string memory name_, string memory symbol_) CreatorTokenBase() ERC721A(name_, symbol_);
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

### _beforeTokenTransfers

*Ties the erc721a _beforeTokenTransfers hook to more granular transfer validation logic*


```solidity
function _beforeTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity)
    internal
    virtual
    override;
```

### _afterTokenTransfers

*Ties the erc721a _afterTokenTransfer hook to more granular transfer validation logic*


```solidity
function _afterTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity)
    internal
    virtual
    override;
```

### _msgSenderERC721A


```solidity
function _msgSenderERC721A() internal view virtual override returns (address);
```

### _tokenType


```solidity
function _tokenType() internal pure override returns (uint16);
```

