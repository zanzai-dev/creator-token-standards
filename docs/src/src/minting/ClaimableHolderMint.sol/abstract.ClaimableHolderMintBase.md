# ClaimableHolderMintBase
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/minting/ClaimableHolderMint.sol)

**Inherits:**
[ClaimPeriodBase](/src/minting/ClaimPeriodBase.sol/abstract.ClaimPeriodBase.md), [MaxSupplyBase](/src/minting/MaxSupply.sol/abstract.MaxSupplyBase.md)

**Author:**
Limit Break, Inc.

Base functionality of a contract mix-in that may optionally be used with extend ERC-721 tokens with sequential role-based minting capabilities.

*Inheriting contracts must implement `_mintToken`.*


## State Variables
### MAX_MINTS_PER_TRANSACTION
*The maximum amount of minted tokens from one batch submission.*


```solidity
uint256 private constant MAX_MINTS_PER_TRANSACTION = 300;
```


### MAX_ROOT_COLLECTIONS
*The maximum amount of Root Collections permitted*


```solidity
uint256 private constant MAX_ROOT_COLLECTIONS = 25;
```


### finalizedIneligibleTokens
*True if ineligible token lists have been finalized, false otherwise.*


```solidity
bool private finalizedIneligibleTokens;
```


### rootCollectionLookup
*Mapping from root collection address to claim details*


```solidity
mapping(address => ClaimableRootCollection) private rootCollectionLookup;
```


## Functions
### initializeIneligibleTokens

Accepts a list of slot and bitmaps to mark tokens ineligible for claim for the provided root collection address

*You can generate the inputs for `ineligibleTokenSlots` and `ineligibleTokenBitmaps` by using the helper function `getIneligibleTokensBitmap`*

*Params are memory to allow for initialization within constructors.
Throws when the root collections have not been initialized.
Throws when ineligible tokens have already been finalized.
Throws if the ineligible token slots & bitmap array lengths do not match.
Postconditions:
---------------
The ineligible token bitmaps are set on the root collection details.*


```solidity
function initializeIneligibleTokens(
    bool finalize,
    address rootCollectionAddress,
    uint256[] memory ineligibleTokenSlots,
    uint256[] memory ineligibleTokenBitmaps
) external;
```

### claimBatch

Allows a user to claim/mint one or more tokens pegged to their ownership of a list of specified token ids
Throws when an empty array of root collection token ids is provided.
Throws when the amount of claimed tokens exceeds the max claimable amount.
Throws when the claim period has not opened.
Throws when the claim period has closed.
Throws when the caller does not own the specified token id from the root collection.
Throws when the root token id has already been claimed.
Throws if safe mint receiver is not an EOA or a contract that can receive tokens.
Postconditions:
---------------
The root collection and token ID combinations are marked as claimed in the root collection's claimed token tracker.
`quantity` tokens are minted to the msg.sender, where `quantity` is the amount of tokens per claim * length of the rootCollectionTokenIds array.
`quantity` ClaimMinted events have been emitted, where `quantity` is the amount of tokens per claim * length of the rootCollectionTokenIds array.


```solidity
function claimBatch(address rootCollectionAddress, uint256[] calldata rootCollectionTokenIds) external;
```

### _claim

*Processes a claim for a Root Collection + Root Collection Token ID Combination
Throws when the caller does not own the specified token id from the root collection.
Throws when the root token id has already been claimed.
Throws if safe mint receiver is not an EOA or a contract that can receive tokens.
Postconditions:
---------------
The root collection and tokenID combination are marked as claimed in the root collection's claimed token tracker.
`quantity` tokens are minted to the msg.sender, where `quantity` is the amount of tokens per claim.
The nextTokenId counter is advanced by the `quantity` of tokens minted.
`quantity` ClaimMinted events have been emitted, where `quantity` is the amount of tokens per claim.*


```solidity
function _claim(ClaimableRootCollection storage rootCollectionDetails, uint256 rootCollectionTokenId) internal;
```

### computeIneligibleTokensBitmap

Helper function to return slots and formatted bitmap given an array of ineligible tokens

*Do not use this in any contract calls as there is unoptimized gas usage.  You should use this to*

*generate the input for `initializeIneligibleTokens`*

*`ineligibleTokenIds` must be a sorted list of token IDs to return the bitmap and slot arrays*


```solidity
function computeIneligibleTokensBitmap(uint256[] calldata ineligibleTokenIds)
    external
    pure
    returns (uint256[] memory, uint256[] memory);
```

### getTokensPerClaim

Returns the amount of tokens minted per claim for the provided root collection


```solidity
function getTokensPerClaim(address rootCollectionAddress) public view returns (uint256);
```

### isEligible

Returns true if the specified token id is eligible for claiming, false otherwise


```solidity
function isEligible(address rootCollectionAddress, uint256 tokenId) public view returns (bool);
```

### isClaimed

Returns true if the specified token id has been claimed


```solidity
function isClaimed(address rootCollectionAddress, uint256 tokenId) public view returns (bool);
```

### _isClaimed

*Returns whether or not the specified token id has been claimed/minted as well as the bitmap slot/offset/slot value of the token id*


```solidity
function _isClaimed(ClaimableRootCollection storage rootCollectionDetails, uint256 tokenId)
    internal
    view
    returns (bool claimed, uint256 slot, uint256 offset, uint256 slotValue);
```

### _getNumberOfTokenTrackerSlots

*Determines number of slots required to track minted tokens across the max supply*


```solidity
function _getNumberOfTokenTrackerSlots(uint256 maxSupply_) internal pure returns (uint256 tokenTrackerSlotsRequired);
```

### _requireInputArrayLengthsMatch

*Validates that the length of two input arrays matched.
Throws if the array lengths are mismatched.*


```solidity
function _requireInputArrayLengthsMatch(uint256 inputArray1Length, uint256 inputArray2Length) internal pure;
```

### _getRootCollectionDetailsSafe

*Safely gets a storage pointer to the details of a root collection.  Performs validation and throws if the value is not present in the mapping, preventing
the possibility of overwriting an unexpected storage slot.
Throws when the specified root collection address has not been explicitly set as a key in the mapping.*


```solidity
function _getRootCollectionDetailsSafe(address rootCollectionAddress)
    private
    view
    returns (ClaimableRootCollection storage);
```

### _onClaimPeriodOpening


```solidity
function _onClaimPeriodOpening() internal virtual override;
```

### _setRootCollections


```solidity
function _setRootCollections(
    address[] memory rootCollections_,
    uint256[] memory rootCollectionMaxSupplies_,
    uint256[] memory tokensPerClaimArray_
) internal;
```

## Events
### ClaimMinted
*Emitted when a holder claims a mint*


```solidity
event ClaimMinted(
    address indexed rootCollection, uint256 indexed rootCollectionTokenId, uint256 startTokenId, uint256 endTokenId
);
```

### RootCollectionInitialized
*Emitted when a root collection is initialized*


```solidity
event RootCollectionInitialized(address indexed rootCollection, uint256 maxSupply, uint256 tokensPerClaim);
```

### IneligibleTokensInitialized
*Emitted when a set of ineligible token slots and bitmaps are set for a root collection*


```solidity
event IneligibleTokensInitialized(
    address indexed rootCollectionAddress, uint256[] ineligibleTokenSlots, uint256[] ineligibleTokenBitmaps
);
```

## Errors
### ClaimableHolderMint__CallerDoesNotOwnRootTokenId

```solidity
error ClaimableHolderMint__CallerDoesNotOwnRootTokenId();
```

### ClaimableHolderMint__CollectionAddressIsNotAnERC721Token

```solidity
error ClaimableHolderMint__CollectionAddressIsNotAnERC721Token();
```

### ClaimableHolderMint__IneligibleTokenArrayMustBeInAscendingOrder

```solidity
error ClaimableHolderMint__IneligibleTokenArrayMustBeInAscendingOrder();
```

### ClaimableHolderMint__IneligibleTokensFinalized

```solidity
error ClaimableHolderMint__IneligibleTokensFinalized();
```

### ClaimableHolderMint__IneligibleTokensHaveNotBeenFinalized

```solidity
error ClaimableHolderMint__IneligibleTokensHaveNotBeenFinalized();
```

### ClaimableHolderMint__InputArrayLengthMismatch

```solidity
error ClaimableHolderMint__InputArrayLengthMismatch();
```

### ClaimableHolderMint__InvalidRootCollectionAddress

```solidity
error ClaimableHolderMint__InvalidRootCollectionAddress();
```

### ClaimableHolderMint__InvalidRootCollectionTokenId

```solidity
error ClaimableHolderMint__InvalidRootCollectionTokenId();
```

### ClaimableHolderMint__MaxSupplyOfRootTokenCannotBeZero

```solidity
error ClaimableHolderMint__MaxSupplyOfRootTokenCannotBeZero();
```

### ClaimableHolderMint__MustSpecifyAtLeastOneIneligibleToken

```solidity
error ClaimableHolderMint__MustSpecifyAtLeastOneIneligibleToken();
```

### ClaimableHolderMint__MustSpecifyAtLeastOneRootCollection

```solidity
error ClaimableHolderMint__MustSpecifyAtLeastOneRootCollection();
```

### ClaimableHolderMint__TokenIdAlreadyClaimed

```solidity
error ClaimableHolderMint__TokenIdAlreadyClaimed();
```

### ClaimableHolderMint__TokensPerClaimMustBeBetweenOneAndTen

```solidity
error ClaimableHolderMint__TokensPerClaimMustBeBetweenOneAndTen();
```

### ClaimableHolderMint__MaxNumberOfRootCollectionsExceeded

```solidity
error ClaimableHolderMint__MaxNumberOfRootCollectionsExceeded();
```

### ClaimableHolderMint__BatchSizeMustBeGreaterThanZero

```solidity
error ClaimableHolderMint__BatchSizeMustBeGreaterThanZero();
```

### ClaimableHolderMint__BatchSizeGreaterThanMaximum

```solidity
error ClaimableHolderMint__BatchSizeGreaterThanMaximum();
```

## Structs
### ClaimableRootCollection

```solidity
struct ClaimableRootCollection {
    bool isRootCollection;
    IERC721 rootCollection;
    uint256 maxSupply;
    uint256 tokensPerClaim;
    uint256[] claimedTokenTracker;
    mapping(uint256 => uint256) ineligibleTokenBitmaps;
}
```

