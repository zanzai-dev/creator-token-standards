# AdventureERC721CInitializable
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/erc721c/AdventureERC721C.sol)

**Inherits:**
[AdventureERC721Initializable](/src/adventures/AdventureERC721.sol/abstract.AdventureERC721Initializable.md), [CreatorTokenBase](/src/utils/CreatorTokenBase.sol/abstract.CreatorTokenBase.md), [AutomaticValidatorTransferApproval](/src/utils/AutomaticValidatorTransferApproval.sol/abstract.AutomaticValidatorTransferApproval.md)

**Author:**
Limit Break, Inc.

Initializable implementation of the AdventureERC721C contract to allow for EIP-1167 clones.


## Functions
### initializeERC721


```solidity
function initializeERC721(string memory name_, string memory symbol_) public override;
```

### isApprovedForAll

Overrides behavior of isApprovedFor all such that if an operator is not explicitly approved
for all, the contract owner can optionally auto-approve the 721-C transfer validator for transfers.


```solidity
function isApprovedForAll(address owner, address operator) public view virtual override returns (bool isApproved);
```

### supportsInterface


```solidity
function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool);
```

### getTransferValidationFunction

Returns the function selector for the transfer validator's validation function to be called

for transaction simulation.


```solidity
function getTransferValidationFunction() external pure returns (bytes4 functionSignature, bool isViewFunction);
```

### _beforeTokenTransfer

*Ties the adventure erc721 _beforeTokenTransfer hook to more granular transfer validation logic*


```solidity
function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize)
    internal
    virtual
    override;
```

### _afterTokenTransfer

*Ties the adventure erc721 _afterTokenTransfer hook to more granular transfer validation logic*


```solidity
function _afterTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize)
    internal
    virtual
    override;
```

### _tokenType


```solidity
function _tokenType() internal pure override returns (uint16);
```

