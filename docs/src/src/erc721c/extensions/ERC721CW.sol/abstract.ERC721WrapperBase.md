# ERC721WrapperBase
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/erc721c/extensions/ERC721CW.sol)

**Inherits:**
[WithdrawETH](/src/utils/WithdrawETH.sol/abstract.WithdrawETH.md), [ICreatorTokenWrapperERC721](/src/interfaces/ICreatorTokenWrapperERC721.sol/interface.ICreatorTokenWrapperERC721.md)

**Author:**
Limit Break, Inc.

Base contract extending ERC721-C contracts and adding a staking feature used to wrap another ERC721 contract.
The wrapper token gives the developer access to the same set of controls present in the ERC721-C standard.
Holders opt-in to this contract by staking, and it is possible for holders to unstake at the developers' discretion.
The intent of this contract is to allow developers to upgrade existing NFT collections and provide enhanced features.
The base contract is intended to be inherited by either a constructable or initializable contract.

Creators also have discretion to set optional staker constraints should they wish to restrict staking to
EOA accounts only.


## State Variables
### stakerConstraints
*The staking constraints that will be used to determine if an address is eligible to stake tokens.*


```solidity
StakerConstraints private stakerConstraints;
```


## Functions
### setStakerConstraints

Allows the contract owner to update the staker constraints.

*Throws when caller is not the contract owner.
Postconditions:
---------------
The staker constraints have been updated.
A `StakerConstraintsSet` event has been emitted.*


```solidity
function setStakerConstraints(StakerConstraints stakerConstraints_) public;
```

### stake

Allows holders of the wrapped ERC721 token to stake into this enhanced ERC721 token.
The out of the box enhancement is ERC721-C standard, but developers can extend the functionality of this
contract with additional powered up features.
Throws when staker constraints is `CallerIsTxOrigin` and the caller is not the tx.origin.
Throws when staker constraints is `EOA` and the caller has not verified their signature in the transfer
validator contract.
Throws when caller does not own the token id on the wrapped collection.
Throws when inheriting contract reverts in the _onStake function (for example, in a pay to stake scenario).
Throws when _mint function reverts (for example, when additional mint validation logic reverts).
Throws when transferFrom function reverts (e.g. if this contract does not have approval to transfer token).
Postconditions:
---------------
The staker's token is now owned by this contract.
The staker has received a wrapper token on this contract with the same token id.
A `Staked` event has been emitted.


```solidity
function stake(uint256 tokenId) public payable virtual override;
```

### stakeTo

Allows holders of the wrapped ERC721 token to stake into this enhanced ERC721 token.
The out of the box enhancement is ERC721-C standard, but developers can extend the functionality of this
contract with additional powered up features.
Throws when staker constraints is `CallerIsTxOrigin` and the `to` address is not the tx.origin.
Throws when staker constraints is `EOA` and the `to` address has not verified their signature in the transfer
validator contract.
Throws when caller does not own the token id on the wrapped collection.
Throws when inheriting contract reverts in the _onStake function (for example, in a pay to stake scenario).
Throws when _mint function reverts (for example, when additional mint validation logic reverts).
Throws when transferFrom function reverts (e.g. if this contract does not have approval to transfer token).
Postconditions:
---------------
The staker's token is now owned by this contract.
The `to` address has received a wrapper token on this contract with the same token id.
A `Staked` event has been emitted.


```solidity
function stakeTo(uint256 tokenId, address to) public payable virtual override;
```

### unstake

Allows holders of this wrapper ERC721 token to unstake and receive the original wrapped token.
Throws when caller does not own the token id of this wrapper collection.
Throws when inheriting contract reverts in the _onUnstake function (for example, in a pay to unstake scenario).
Throws when _burn function reverts (for example, when additional burn validation logic reverts).
Throws when transferFrom function reverts (should not be the case, unless wrapped token has additional transfer validation logic).
Postconditions:
---------------
The wrapper token has been burned.
The wrapped token with the same token id has been transferred to the address that owned the wrapper token.
An `Unstaked` event has been emitted.


```solidity
function unstake(uint256 tokenId) public payable virtual override;
```

### canUnstake

Returns true if the specified token id is available to be unstaked, false otherwise.

*This should be overridden in most cases by inheriting contracts to implement the proper constraints.
In the base implementation, a token is available to be unstaked if the wrapped token is owned by this contract
and the wrapper token exists.*


```solidity
function canUnstake(uint256 tokenId) public view virtual override returns (bool);
```

### getStakerConstraints

Returns the staker constraints that are currently in effect.


```solidity
function getStakerConstraints() public view override returns (StakerConstraints);
```

### getWrappedCollectionAddress

Returns the address of the wrapped ERC721 contract.


```solidity
function getWrappedCollectionAddress() public view virtual override returns (address);
```

### _onStake

*Optional logic hook that fires during stake transaction.*


```solidity
function _onStake(uint256, uint256 value) internal virtual;
```

### _onUnstake

*Optional logic hook that fires during unstake transaction.*


```solidity
function _onUnstake(uint256, uint256 value) internal virtual;
```

### _validateWrappedCollectionAddress


```solidity
function _validateWrappedCollectionAddress(address wrappedCollectionAddress_) internal view;
```

### _requireAccountIsVerifiedEOA


```solidity
function _requireAccountIsVerifiedEOA(address account) internal view virtual;
```

### _doTokenMint


```solidity
function _doTokenMint(address to, uint256 tokenId) internal virtual;
```

### _doTokenBurn


```solidity
function _doTokenBurn(uint256 tokenId) internal virtual;
```

### _getOwnerOfToken


```solidity
function _getOwnerOfToken(uint256 tokenId) internal view virtual returns (address);
```

### _tokenExists


```solidity
function _tokenExists(uint256 tokenId) internal view virtual returns (bool);
```

## Errors
### ERC721WrapperBase__CallerNotOwnerOfWrappingToken

```solidity
error ERC721WrapperBase__CallerNotOwnerOfWrappingToken();
```

### ERC721WrapperBase__CallerNotOwnerOfWrappedToken

```solidity
error ERC721WrapperBase__CallerNotOwnerOfWrappedToken();
```

### ERC721WrapperBase__CallerSignatureNotVerifiedInEOARegistry

```solidity
error ERC721WrapperBase__CallerSignatureNotVerifiedInEOARegistry();
```

### ERC721WrapperBase__DefaultImplementationOfStakeDoesNotAcceptPayment

```solidity
error ERC721WrapperBase__DefaultImplementationOfStakeDoesNotAcceptPayment();
```

### ERC721WrapperBase__DefaultImplementationOfUnstakeDoesNotAcceptPayment

```solidity
error ERC721WrapperBase__DefaultImplementationOfUnstakeDoesNotAcceptPayment();
```

### ERC721WrapperBase__InvalidERC721Collection

```solidity
error ERC721WrapperBase__InvalidERC721Collection();
```

### ERC721WrapperBase__SmartContractsNotPermittedToStake

```solidity
error ERC721WrapperBase__SmartContractsNotPermittedToStake();
```

