# AdventureERC721Initializable
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/adventures/AdventureERC721.sol)

**Inherits:**
[AdventureBase](/src/adventures/AdventureERC721.sol/abstract.AdventureBase.md), [ERC721OpenZeppelinInitializable](/src/token/erc721/ERC721OpenZeppelin.sol/abstract.ERC721OpenZeppelinInitializable.md)

**Author:**
Limit Break, Inc.

Initializable AdventureERC721 implementation allowing for EIP-1167 clones.


## State Variables
### _maxSimultaneousQuestsInitialized

```solidity
bool private _maxSimultaneousQuestsInitialized;
```


## Functions
### initializeMaxSimultaneousQuestsAndTransferType


```solidity
function initializeMaxSimultaneousQuestsAndTransferType(uint256 maxSimultaneousQuests_) public;
```

### supportsInterface

*ERC-165 interface support*


```solidity
function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, IERC165) returns (bool);
```

### _doBurn


```solidity
function _doBurn(uint256 tokenId) internal virtual override;
```

### _doTransfer


```solidity
function _doTransfer(address from, address to, uint256 tokenId) internal virtual override;
```

### _doSafeTransfer


```solidity
function _doSafeTransfer(address from, address to, uint256 tokenId, bytes memory data) internal virtual override;
```

### _ownerOfToken


```solidity
function _ownerOfToken(uint256 tokenId) internal view virtual override returns (address);
```

### _beforeTokenTransfer

*By default, tokens that are participating in quests are transferrable.  However, if a token is participating
in a quest on an adventure that was designated as a token locker, the transfer will revert and keep the token
locked.*


```solidity
function _beforeTokenTransfer(address, address, uint256 firstTokenId, uint256 batchSize) internal virtual override;
```

## Errors
### AdventureERC721Initializable__AlreadyInitializedMaxSimultaneousQuestsAndTransferType

```solidity
error AdventureERC721Initializable__AlreadyInitializedMaxSimultaneousQuestsAndTransferType();
```

