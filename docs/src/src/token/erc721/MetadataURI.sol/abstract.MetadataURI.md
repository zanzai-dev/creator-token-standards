# MetadataURI
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/token/erc721/MetadataURI.sol)

**Inherits:**
[OwnablePermissions](/src/access/OwnablePermissions.sol/abstract.OwnablePermissions.md)


## State Variables
### baseTokenURI
*Base token uri*


```solidity
string public baseTokenURI;
```


### suffixURI
*Token uri suffix/extension*


```solidity
string public suffixURI;
```


## Functions
### setBaseURI

Sets base URI


```solidity
function setBaseURI(string memory baseTokenURI_) public;
```

### setSuffixURI

Sets suffix URI


```solidity
function setSuffixURI(string memory suffixURI_) public;
```

## Events
### BaseURISet
*Emitted when base URI is set.*


```solidity
event BaseURISet(string baseTokenURI);
```

### SuffixURISet
*Emitted when suffix URI is set.*


```solidity
event SuffixURISet(string suffixURI);
```

