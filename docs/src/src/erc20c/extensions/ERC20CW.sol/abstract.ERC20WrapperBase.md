# ERC20WrapperBase
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/erc20c/extensions/ERC20CW.sol)

**Inherits:**
[WithdrawETH](/src/utils/WithdrawETH.sol/abstract.WithdrawETH.md), ReentrancyGuard, [ICreatorTokenWrapperERC20](/src/interfaces/ICreatorTokenWrapperERC20.sol/interface.ICreatorTokenWrapperERC20.md)

**Author:**
Limit Break, Inc.

Base functionality to extend ERC20-C contracts and add a staking feature used to wrap another ERC20 contract.
The wrapper token gives the developer access to the same set of controls present in the ERC20-C standard.
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

Allows holders of the wrapped ERC20 token to stake into this enhanced ERC20 token.
The out of the box enhancement is ERC20-C standard, but developers can extend the functionality of this
contract with additional powered up features.
Throws when staker constraints is `CallerIsTxOrigin` and the caller is not the tx.origin.
Throws when staker constraints is `EOA` and the caller has not verified their signature in the transfer
validator contract.
Throws when amount is zero.
Throws when caller does not have a balance greater than or equal to `amount` of the wrapped collection.
Throws when inheriting contract reverts in the _onStake function (for example, in a pay to stake scenario).
Throws when _mint function reverts (for example, when additional mint validation logic reverts).
Throws when safeTransferFrom function reverts (e.g. if this contract does not have approval to transfer token).
Postconditions:
---------------
The specified amount of the staker's token are now owned by this contract.
The staker has received the equivalent amount of wrapper token on this contract with the same id.
A `Staked` event has been emitted.


```solidity
function stake(uint256 amount) public payable virtual override nonReentrant;
```

### stakeTo

Allows holders of the wrapped ERC20 token to stake into this enhanced ERC20 token.
The out of the box enhancement is ERC20-C standard, but developers can extend the functionality of this
contract with additional powered up features.  This function allows a contract to stake on behalf of a user.
Throws when staker constraints is `CallerIsTxOrigin` and the `to` address is not the tx.origin.
Throws when staker constraints is `EOA` and the `to` address has not verified their signature in the transfer
validator contract.
Throws when amount is zero.
Throws when caller does not have a balance greater than or equal to `amount` of the wrapped collection.
Throws when inheriting contract reverts in the _onStake function (for example, in a pay to stake scenario).
Throws when _mint function reverts (for example, when additional mint validation logic reverts).
Throws when safeTransferFrom function reverts (e.g. if this contract does not have approval to transfer token).
Postconditions:
---------------
The specified amount of the staker's token are now owned by this contract.
The `to` address has received the equivalent amount of wrapper token on this contract with the same id.
A `Staked` event has been emitted.


```solidity
function stakeTo(uint256 amount, address to) public payable virtual override nonReentrant;
```

### unstake

Allows holders of this wrapper ERC20 token to unstake and receive the original wrapped tokens.
Throws when amount is zero.
Throws when caller does not have a balance greater than or equal to amount of this wrapper collection.
Throws when inheriting contract reverts in the _onUnstake function (for example, in a pay to unstake scenario).
Throws when _burn function reverts (for example, when additional burn validation logic reverts).
Throws when safeTransferFrom function reverts.
Postconditions:
---------------
The specified amount of wrapper token has been burned.
The specified amount of wrapped token with the same id has been transferred to the caller.
An `Unstaked` event has been emitted.


```solidity
function unstake(uint256 amount) public payable virtual override nonReentrant;
```

### canUnstake

Returns true if the specified token id and amount is available to be unstaked, false otherwise.

*This should be overridden in most cases by inheriting contracts to implement the proper constraints.
In the base implementation, tokens are available to be unstaked if the contract's balance of
the wrapped token is greater than or equal to amount.*


```solidity
function canUnstake(uint256 amount) public view virtual override returns (bool);
```

### getStakerConstraints

Returns the staker constraints that are currently in effect.


```solidity
function getStakerConstraints() public view override returns (StakerConstraints);
```

### getWrappedCollectionAddress

Returns the address of the wrapped ERC20 contract.


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
function _doTokenMint(address to, uint256 amount) internal virtual;
```

### _doTokenBurn


```solidity
function _doTokenBurn(address from, uint256 amount) internal virtual;
```

### _getBalanceOf


```solidity
function _getBalanceOf(address account) internal view virtual returns (uint256);
```

## Errors
### ERC20WrapperBase__AmountMustBeGreaterThanZero

```solidity
error ERC20WrapperBase__AmountMustBeGreaterThanZero();
```

### ERC20WrapperBase__CallerSignatureNotVerifiedInEOARegistry

```solidity
error ERC20WrapperBase__CallerSignatureNotVerifiedInEOARegistry();
```

### ERC20WrapperBase__InsufficientBalanceOfWrappedToken

```solidity
error ERC20WrapperBase__InsufficientBalanceOfWrappedToken();
```

### ERC20WrapperBase__InsufficientBalanceOfWrappingToken

```solidity
error ERC20WrapperBase__InsufficientBalanceOfWrappingToken();
```

### ERC20WrapperBase__DefaultImplementationOfStakeDoesNotAcceptPayment

```solidity
error ERC20WrapperBase__DefaultImplementationOfStakeDoesNotAcceptPayment();
```

### ERC20WrapperBase__DefaultImplementationOfUnstakeDoesNotAcceptPayment

```solidity
error ERC20WrapperBase__DefaultImplementationOfUnstakeDoesNotAcceptPayment();
```

### ERC20WrapperBase__InvalidERC20Collection

```solidity
error ERC20WrapperBase__InvalidERC20Collection();
```

### ERC20WrapperBase__SmartContractsNotPermittedToStake

```solidity
error ERC20WrapperBase__SmartContractsNotPermittedToStake();
```

