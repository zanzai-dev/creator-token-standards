# MetadataURIInitializable
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/token/erc721/MetadataURI.sol)

**Inherits:**
[MetadataURI](/src/token/erc721/MetadataURI.sol/abstract.MetadataURI.md)


## State Variables
### _uriInitialized

```solidity
bool private _uriInitialized;
```


## Functions
### initializeURI

*Initializes parameters of tokens with uri values.
These cannot be set in the constructor because this contract is optionally compatible with EIP-1167.*


```solidity
function initializeURI(string memory baseURI_, string memory suffixURI_) public;
```

## Errors
### MetadataURIInitializable__URIAlreadyInitialized

```solidity
error MetadataURIInitializable__URIAlreadyInitialized();
```

