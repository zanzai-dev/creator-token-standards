# CollectionSecurityPolicyV3
[Git Source](https://github.com/zanzai-dev/creator-token-standards/blob/e3ca932d2edc594487078ba2c4da4e803f84d6a3/src/utils/TransferPolicy.sol)

*Defines the security policy for a token collection in Creator Token Standards V2.*

***transferSecurityLevel**: The transfer security level set for the collection.*

***listId**: The list id that contains the blacklist and whitelist to apply to the collection.*

***enableGraylisting**: If true, graylisting will be enabled for the collection.*


```solidity
struct CollectionSecurityPolicyV3 {
    bool disableAuthorizationMode;
    bool authorizersCannotSetWildcardOperators;
    uint8 transferSecurityLevel;
    uint120 listId;
    bool enableAccountFreezingMode;
    uint16 tokenType;
}
```

