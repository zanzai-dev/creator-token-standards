# MerkleWhitelistMintBase
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/minting/MerkleWhitelistMint.sol)

**Inherits:**
[ClaimPeriodBase](/src/minting/ClaimPeriodBase.sol/abstract.ClaimPeriodBase.md), [MaxSupplyBase](/src/minting/MaxSupply.sol/abstract.MaxSupplyBase.md)

**Author:**
Limit Break, Inc.

Base functionality of a contract mix-in that may optionally be used with extend ERC-721 tokens with merkle-proof based whitelist minting capabilities.

*Inheriting contracts must implement `_mintToken`.*

*The leaf nodes of the merkle tree contain the address and quantity of tokens that may be minted by that address.
Duplicate addresses are not permitted.  For instance, address(Bob) may only appear once in the merkle tree.
If address(Bob) appears more than once, Bob will be able to claim from only one of the leaves that contain his
address. In the event a mistake is made and duplicates are included in the merkle tree, the owner of the
contract may be able to de-duplicate the tree and submit a new root, provided
`_remainingNumberOfMerkleRootChanges` is greater than 0. The number of permitted merkle root changes is set
during contract construction/initialization, so take this into account when deploying your contracts.*


## State Variables
### _remainingNumberOfMerkleRootChanges
*The number of times the merkle root may be updated*


```solidity
uint256 private _remainingNumberOfMerkleRootChanges;
```


### _merkleRoot
*This is the root ERC-721 contract from which claims can be made*


```solidity
bytes32 private _merkleRoot;
```


### _remainingMerkleMints
*This is the current amount of tokens mintable via merkle whitelist claims*


```solidity
uint256 private _remainingMerkleMints;
```


### whitelistClaimed
*Mapping that tracks whether or not an address has claimed their whitelist mint*


```solidity
mapping(address => bool) private whitelistClaimed;
```


## Functions
### whitelistMint

Mints the specified quantity to the calling address if the submitted merkle proof successfully verifies the reserved quantity for the caller in the whitelist.
Throws when the claim period has not opened.
Throws when the claim period has closed.
Throws if a merkle root has not been set.
Throws if the caller has already successfully claimed.
Throws if the quantity minted plus amount already minted exceeds the maximum amount claimable via merkle root.
Throws if the submitted merkle proof does not successfully verify the reserved quantity for the caller.


```solidity
function whitelistMint(uint256 quantity, bytes32[] calldata merkleProof_) external;
```

### setMerkleRoot

Update the merkle root if the merkle root was marked as changeable during initialization
Throws if the `merkleRootChangable` boolean is false
Throws if provided merkle root is 0


```solidity
function setMerkleRoot(bytes32 merkleRoot_) external;
```

### getMerkleRoot

Returns the merkle root


```solidity
function getMerkleRoot() external view returns (bytes32);
```

### remainingMerkleMints

Returns the remaining amount of token mints via merkle claiming


```solidity
function remainingMerkleMints() external view returns (uint256);
```

### isWhitelistClaimed

Returns true if the account already claimed their whitelist mint, false otherwise


```solidity
function isWhitelistClaimed(address account) external view returns (bool);
```

### _setMaxMerkleMintsAndPermittedNumberOfMerkleRootChanges


```solidity
function _setMaxMerkleMintsAndPermittedNumberOfMerkleRootChanges(
    uint256 maxMerkleMints_,
    uint256 permittedNumberOfMerkleRootChanges_
) internal;
```

## Events
### MerkleRootUpdated
Emitted when a merkle root is updated


```solidity
event MerkleRootUpdated(bytes32 merkleRoot_);
```

## Errors
### MerkleWhitelistMint__AddressHasAlreadyClaimed

```solidity
error MerkleWhitelistMint__AddressHasAlreadyClaimed();
```

### MerkleWhitelistMint__CannotClaimMoreThanMaximumAmountOfMerkleMints

```solidity
error MerkleWhitelistMint__CannotClaimMoreThanMaximumAmountOfMerkleMints();
```

### MerkleWhitelistMint__InvalidProof

```solidity
error MerkleWhitelistMint__InvalidProof();
```

### MerkleWhitelistMint__MaxMintsMustBeGreaterThanZero

```solidity
error MerkleWhitelistMint__MaxMintsMustBeGreaterThanZero();
```

### MerkleWhitelistMint__MerkleRootCannotBeZero

```solidity
error MerkleWhitelistMint__MerkleRootCannotBeZero();
```

### MerkleWhitelistMint__MerkleRootHasNotBeenInitialized

```solidity
error MerkleWhitelistMint__MerkleRootHasNotBeenInitialized();
```

### MerkleWhitelistMint__MerkleRootImmutable

```solidity
error MerkleWhitelistMint__MerkleRootImmutable();
```

### MerkleWhitelistMint__PermittedNumberOfMerkleRootChangesMustBeGreaterThanZero

```solidity
error MerkleWhitelistMint__PermittedNumberOfMerkleRootChangesMustBeGreaterThanZero();
```

