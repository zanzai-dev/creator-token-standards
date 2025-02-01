# SignedApprovalMintBase
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/minting/SignedApprovalMint.sol)

**Inherits:**
[MaxSupplyBase](/src/minting/MaxSupply.sol/abstract.MaxSupplyBase.md), EIP712

**Author:**
Limit Break, Inc.

Base functionality for a contract mix-in that may optionally be used with extend ERC-721 tokens with Signed Approval minting capabilities, allowing an approved signer to issue a limited amount of mints.

*Inheriting contracts must implement `_mintToken`.*


## State Variables
### _signedClaimsDecommissioned
*Returns true if signed claims have been decommissioned, false otherwise.*


```solidity
bool private _signedClaimsDecommissioned;
```


### _approvalSigner
*The address of the signer for approved mints.*


```solidity
address private _approvalSigner;
```


### _remainingSignedMints
*The remaining amount of tokens mintable via signed approval minting.
NOTE: This is an aggregate of all signers, updating signer will not reset or modify this amount.*


```solidity
uint256 private _remainingSignedMints;
```


### addressMinted
*Mapping of addresses who have already minted*


```solidity
mapping(address => bool) private addressMinted;
```


## Functions
### claimSignedMint

Allows a user to claim/mint one or more tokens as approved by the approved signer
Throws when a signature is invalid.
Throws when the quantity provided does not match the quantity on the signature provided.
Throws when the address has already claimed a token.


```solidity
function claimSignedMint(bytes calldata signature, uint256 quantity) external;
```

### decommissionSignedApprovals

Decommissions signed approvals
This is a permanent decommissioning, once this is set, no further signatures can be claimed
Throws if caller is not owner
Throws if already decommissioned


```solidity
function decommissionSignedApprovals() external;
```

### setSigner

*Allows signer to update the signer address
This allows the signer to set new signer to address(0) to prevent future allowed mints
NOTE: Setting signer to address(0) is irreversible - approvals will be disabled permanently and all outstanding signatures will be invalid.
Throws when caller is not owner
Throws when current signer is address(0)*


```solidity
function setSigner(address newSigner) public;
```

### hasMintedBySignedApproval

Returns true if the provided account has already minted, false otherwise


```solidity
function hasMintedBySignedApproval(address account) public view returns (bool);
```

### approvalSigner

Returns the address of the approved signer


```solidity
function approvalSigner() public view returns (address);
```

### remainingSignedMints

Returns the remaining amount of tokens mintable via signed approvals.


```solidity
function remainingSignedMints() public view returns (uint256);
```

### signedClaimsDecommissioned

Returns true if signed claims have been decommissioned, false otherwise


```solidity
function signedClaimsDecommissioned() public view returns (bool);
```

### _requireSignedClaimsActive

*Internal function used to revert if signed claims are decommissioned.*


```solidity
function _requireSignedClaimsActive() internal view;
```

### _setSignerAndMaxSignedMintSupply


```solidity
function _setSignerAndMaxSignedMintSupply(address signer_, uint256 maxSignedMints_) internal;
```

## Events
### SignedClaimsDecommissioned
*Emitted when signatures are decommissioned*


```solidity
event SignedClaimsDecommissioned();
```

### SignedMintClaimed
*Emitted when a signed mint is claimed*


```solidity
event SignedMintClaimed(address indexed minter, uint256 startTokenId, uint256 endTokenId);
```

### SignerUpdated
*Emitted when a signer is updated*


```solidity
event SignerUpdated(address oldSigner, address newSigner);
```

## Errors
### SignedApprovalMint__AddressAlreadyMinted

```solidity
error SignedApprovalMint__AddressAlreadyMinted();
```

### SignedApprovalMint__InvalidSignature

```solidity
error SignedApprovalMint__InvalidSignature();
```

### SignedApprovalMint__MaxQuantityMustBeGreaterThanZero

```solidity
error SignedApprovalMint__MaxQuantityMustBeGreaterThanZero();
```

### SignedApprovalMint__MintExceedsMaximumAmountBySignedApproval

```solidity
error SignedApprovalMint__MintExceedsMaximumAmountBySignedApproval();
```

### SignedApprovalMint__SignedClaimsAreDecommissioned

```solidity
error SignedApprovalMint__SignedClaimsAreDecommissioned();
```

### SignedApprovalMint__SignerCannotBeInitializedAsAddressZero

```solidity
error SignedApprovalMint__SignerCannotBeInitializedAsAddressZero();
```

### SignedApprovalMint__SignerIsAddressZero

```solidity
error SignedApprovalMint__SignerIsAddressZero();
```

