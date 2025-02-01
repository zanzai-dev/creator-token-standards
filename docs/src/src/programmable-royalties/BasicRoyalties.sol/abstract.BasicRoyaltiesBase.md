# BasicRoyaltiesBase
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/programmable-royalties/BasicRoyalties.sol)

**Inherits:**
ERC2981

**Author:**
Limit Break, Inc.

*Base functionality of an NFT mix-in contract implementing the most basic form of programmable royalties.*


## Functions
### _setDefaultRoyalty


```solidity
function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual override;
```

### _setTokenRoyalty


```solidity
function _setTokenRoyalty(uint256 tokenId, address receiver, uint96 feeNumerator) internal virtual override;
```

## Events
### DefaultRoyaltySet

```solidity
event DefaultRoyaltySet(address indexed receiver, uint96 feeNumerator);
```

### TokenRoyaltySet

```solidity
event TokenRoyaltySet(uint256 indexed tokenId, address indexed receiver, uint96 feeNumerator);
```

