# StakerConstraints
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/utils/TransferPolicy.sol)

*Defines constraints for staking tokens in token wrapper contracts.*


```solidity
enum StakerConstraints {
    None,
    CallerIsTxOrigin,
    EOA
}
```

