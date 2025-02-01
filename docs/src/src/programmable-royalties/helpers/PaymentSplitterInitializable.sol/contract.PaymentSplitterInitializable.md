# PaymentSplitterInitializable
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/programmable-royalties/helpers/PaymentSplitterInitializable.sol)

**Inherits:**
Context

*This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
that the Ether will be split in this way, since it is handled transparently by the contract.
The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
an amount proportional to the percentage of total shares they were assigned. The distribution of shares is set at the
time of contract deployment and can't be updated thereafter.
`PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the [release](/src/programmable-royalties/helpers/PaymentSplitterInitializable.sol/contract.PaymentSplitterInitializable.md#release)
function.
NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
to run tests before sending real value to this contract.*


## State Variables
### _paymentSplitterInitialized

```solidity
bool private _paymentSplitterInitialized;
```


### _totalShares

```solidity
uint256 private _totalShares;
```


### _totalReleased

```solidity
uint256 private _totalReleased;
```


### _shares

```solidity
mapping(address => uint256) private _shares;
```


### _released

```solidity
mapping(address => uint256) private _released;
```


### _payees

```solidity
address[] private _payees;
```


### _erc20TotalReleased

```solidity
mapping(IERC20 => uint256) private _erc20TotalReleased;
```


### _erc20Released

```solidity
mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
```


## Functions
### initializePaymentSplitter

*Initializes an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
the matching position in the `shares` array.
All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
duplicates in `payees`.*


```solidity
function initializePaymentSplitter(address[] calldata payees, uint256[] calldata shares_) external;
```

### receive

*The Ether received will be logged with [PaymentReceived](/src/programmable-royalties/helpers/PaymentSplitterInitializable.sol/contract.PaymentSplitterInitializable.md#paymentreceived) events. Note that these events are not fully
reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
reliability of the events, and not the actual splitting of Ether.
To learn more about this see the Solidity documentation for
https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
functions].*


```solidity
receive() external payable virtual;
```

### totalShares

*Getter for the total shares held by payees.*


```solidity
function totalShares() public view returns (uint256);
```

### totalReleased

*Getter for the total amount of Ether already released.*


```solidity
function totalReleased() public view returns (uint256);
```

### totalReleased

*Getter for the total amount of `token` already released. `token` should be the address of an IERC20
contract.*


```solidity
function totalReleased(IERC20 token) public view returns (uint256);
```

### shares

*Getter for the amount of shares held by an account.*


```solidity
function shares(address account) public view returns (uint256);
```

### released

*Getter for the amount of Ether already released to a payee.*


```solidity
function released(address account) public view returns (uint256);
```

### released

*Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
IERC20 contract.*


```solidity
function released(IERC20 token, address account) public view returns (uint256);
```

### payee

*Getter for the address of the payee number `index`.*


```solidity
function payee(uint256 index) public view returns (address);
```

### releasable

*Getter for the amount of payee's releasable Ether.*


```solidity
function releasable(address account) public view returns (uint256);
```

### releasable

*Getter for the amount of payee's releasable `token` tokens. `token` should be the address of an
IERC20 contract.*


```solidity
function releasable(IERC20 token, address account) public view returns (uint256);
```

### release

*Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
total shares and their previous withdrawals.*


```solidity
function release(address payable account) public virtual;
```

### release

*Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
contract.*


```solidity
function release(IERC20 token, address account) public virtual;
```

### _pendingPayment

*internal logic for computing the pending payment of an `account` given the token historical balances and
already released amounts.*


```solidity
function _pendingPayment(address account, uint256 totalReceived, uint256 alreadyReleased)
    private
    view
    returns (uint256);
```

### _addPayee

*Add a new payee to the contract.*


```solidity
function _addPayee(address account, uint256 shares_) private;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`account`|`address`|The address of the payee to add.|
|`shares_`|`uint256`|The number of shares owned by the payee.|


## Events
### PayeeAdded

```solidity
event PayeeAdded(address account, uint256 shares);
```

### PaymentReleased

```solidity
event PaymentReleased(address to, uint256 amount);
```

### ERC20PaymentReleased

```solidity
event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
```

### PaymentReceived

```solidity
event PaymentReceived(address from, uint256 amount);
```

