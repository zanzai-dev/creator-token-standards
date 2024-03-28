// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "./mocks/ClonerMock.sol";
import "./mocks/ContractMock.sol";
import "./mocks/ERC721CMock.sol";
import "./interfaces/ITestCreatorToken.sol";
import "src/utils/TransferPolicy.sol";
import "src/utils/CreatorTokenTransferValidator.sol";
import "src/Constants.sol";
import "./utils/Events.sol";
import "./utils/Helpers.sol";

contract TransferValidatorTest is Events, Helpers {
    //using EnumerableSet for EnumerableSet.AddressSet;
    //using EnumerableSet for EnumerableSet.Bytes32Set;

    CreatorTokenTransferValidator public validator;

    address whitelistedOperator;

    function setUp() public virtual override {
        super.setUp();

        validator = new CreatorTokenTransferValidator(address(this), "", "");

        whitelistedOperator = vm.addr(2);

        // TODO: vm.prank(validatorDeployer);
        // TODO: validator.addOperatorToWhitelist(0, whitelistedOperator);
    }

    function testTransferSecurityLevelRecommended() public {
        (uint256 callerConstraints, uint256 receiverConstraints) = validator.transferSecurityPolicies(TRANSFER_SECURITY_LEVEL_RECOMMENDED);
        assertEq(TRANSFER_SECURITY_LEVEL_RECOMMENDED, 0);
        assertTrue(callerConstraints == CALLER_CONSTRAINTS_OPERATOR_WHITELIST_ENABLE_OTC);
        assertTrue(receiverConstraints == RECEIVER_CONSTRAINTS_NONE);
    }

    function testTransferSecurityLevelOne() public {
        (uint256 callerConstraints, uint256 receiverConstraints) = validator.transferSecurityPolicies(TRANSFER_SECURITY_LEVEL_ONE);
        assertEq(TRANSFER_SECURITY_LEVEL_ONE, 1);
        assertTrue(callerConstraints == CALLER_CONSTRAINTS_NONE);
        assertTrue(receiverConstraints == RECEIVER_CONSTRAINTS_NONE);
    }

    function testTransferSecurityLevelTwo() public {
        (uint256 callerConstraints, uint256 receiverConstraints) = validator.transferSecurityPolicies(TRANSFER_SECURITY_LEVEL_TWO);
        assertEq(TRANSFER_SECURITY_LEVEL_TWO, 2);
        assertTrue(callerConstraints == CALLER_CONSTRAINTS_OPERATOR_BLACKLIST_ENABLE_OTC);
        assertTrue(receiverConstraints == RECEIVER_CONSTRAINTS_NONE);
    }

    function testTransferSecurityLevelThree() public {
        (uint256 callerConstraints, uint256 receiverConstraints) = validator.transferSecurityPolicies(TRANSFER_SECURITY_LEVEL_THREE);
        assertEq(TRANSFER_SECURITY_LEVEL_THREE, 3);
        assertTrue(callerConstraints == CALLER_CONSTRAINTS_OPERATOR_WHITELIST_ENABLE_OTC);
        assertTrue(receiverConstraints == RECEIVER_CONSTRAINTS_NONE);
    }

    function testTransferSecurityLevelFour() public {
        (uint256 callerConstraints, uint256 receiverConstraints) = validator.transferSecurityPolicies(TRANSFER_SECURITY_LEVEL_FOUR);
        assertEq(TRANSFER_SECURITY_LEVEL_FOUR, 4);
        assertTrue(callerConstraints == CALLER_CONSTRAINTS_OPERATOR_WHITELIST_DISABLE_OTC);
        assertTrue(receiverConstraints == RECEIVER_CONSTRAINTS_NONE);
    }

    function testTransferSecurityLevelFive() public {
        (uint256 callerConstraints, uint256 receiverConstraints) = validator.transferSecurityPolicies(TRANSFER_SECURITY_LEVEL_FIVE);
        assertEq(TRANSFER_SECURITY_LEVEL_FIVE, 5);
        assertTrue(callerConstraints == CALLER_CONSTRAINTS_OPERATOR_WHITELIST_ENABLE_OTC);
        assertTrue(receiverConstraints == RECEIVER_CONSTRAINTS_NO_CODE);
    }

    function testTransferSecurityLevelSix() public {
        (uint256 callerConstraints, uint256 receiverConstraints) = validator.transferSecurityPolicies(TRANSFER_SECURITY_LEVEL_SIX);
        assertEq(TRANSFER_SECURITY_LEVEL_SIX, 6);
        assertTrue(callerConstraints == CALLER_CONSTRAINTS_OPERATOR_WHITELIST_ENABLE_OTC);
        assertTrue(receiverConstraints == RECEIVER_CONSTRAINTS_EOA);
    }

    function testTransferSecurityLevelSeven() public {
        (uint256 callerConstraints, uint256 receiverConstraints) = validator.transferSecurityPolicies(TRANSFER_SECURITY_LEVEL_SEVEN);
        assertEq(TRANSFER_SECURITY_LEVEL_SEVEN, 7);
        assertTrue(callerConstraints == CALLER_CONSTRAINTS_OPERATOR_WHITELIST_DISABLE_OTC);
        assertTrue(receiverConstraints == RECEIVER_CONSTRAINTS_NO_CODE);
    }

    function testTransferSecurityLevelEight() public {
        (uint256 callerConstraints, uint256 receiverConstraints) = validator.transferSecurityPolicies(TRANSFER_SECURITY_LEVEL_EIGHT);
        assertEq(TRANSFER_SECURITY_LEVEL_EIGHT, 8);
        assertTrue(callerConstraints == CALLER_CONSTRAINTS_OPERATOR_WHITELIST_DISABLE_OTC);
        assertTrue(receiverConstraints == RECEIVER_CONSTRAINTS_EOA);
    }

    function testTransferSecurityLevelNine() public {
        (uint256 callerConstraints, uint256 receiverConstraints) = validator.transferSecurityPolicies(TRANSFER_SECURITY_LEVEL_NINE);
        assertEq(TRANSFER_SECURITY_LEVEL_NINE, 9);
        assertTrue(callerConstraints == CALLER_CONSTRAINTS_SBT);
        assertTrue(receiverConstraints == RECEIVER_CONSTRAINTS_SBT);
    }

    function testCreateList(address listOwner, bytes32 nameBytes) public {
        _sanitizeAddress(listOwner);
        string memory name = string(abi.encodePacked(nameBytes));

        uint120 firstListId = 1;
        for (uint120 i = 0; i < 5; ++i) {
            uint120 expectedId = firstListId + i;

            vm.expectEmit(true, true, true, false);
            emit CreatedList(expectedId, name);

            vm.expectEmit(true, true, true, false);
            emit ReassignedListOwnership(expectedId, listOwner);

            vm.prank(listOwner);
            uint120 actualId = validator.createList(name);
            assertEq(actualId, expectedId);
            assertEq(validator.listOwners(actualId), listOwner);
        }
    }

    function testCreateListCopy(
        address listOwner, 
        address listCopyOwner, 
        bytes32 nameBytes, 
        bytes32 nameBytesCopy,
        address whitelistedAccount,
        address blacklistedAccount,
        address authorizerAccount
    ) public {
        _sanitizeAddress(listOwner);
        _sanitizeAddress(listCopyOwner);
        _sanitizeAddress(whitelistedAccount);
        _sanitizeAddress(blacklistedAccount);
        _sanitizeAddress(authorizerAccount);
        string memory name = string(abi.encodePacked(nameBytes));
        string memory nameCopy = string(abi.encodePacked(nameBytesCopy));

        bytes32[] memory whitelistedCodeHashes = new bytes32[](2);
        whitelistedCodeHashes[0] = keccak256(abi.encode(whitelistedAccount));
        whitelistedCodeHashes[1] = keccak256(abi.encode(whitelistedCodeHashes[0]));

        bytes32[] memory blacklistedCodeHashes = new bytes32[](2);
        blacklistedCodeHashes[0] = keccak256(abi.encode(blacklistedAccount));
        blacklistedCodeHashes[1] = keccak256(abi.encode(blacklistedCodeHashes[0]));

        vm.startPrank(listOwner);
        uint120 sourceListId = validator.createList(name);
        validator.addAccountToWhitelist(sourceListId, whitelistedAccount);
        validator.addAccountToWhitelist(sourceListId, address(uint160(uint256(keccak256(abi.encode(whitelistedAccount))))));
        validator.addAccountToBlacklist(sourceListId, blacklistedAccount);
        validator.addAccountToBlacklist(sourceListId, address(uint160(uint256(keccak256(abi.encode(blacklistedAccount))))));
        validator.addAccountToAuthorizers(sourceListId, authorizerAccount);
        validator.addAccountToAuthorizers(sourceListId, address(uint160(uint256(keccak256(abi.encode(authorizerAccount))))));
        validator.addCodeHashesToWhitelist(sourceListId, whitelistedCodeHashes);
        validator.addCodeHashesToBlacklist(sourceListId, blacklistedCodeHashes);
        vm.stopPrank();

        uint120 expectedCopyListId = validator.lastListId() + 1;

        vm.expectEmit(true, true, true, false);
        emit CreatedList(expectedCopyListId, name);

        vm.expectEmit(true, true, true, false);
        emit ReassignedListOwnership(expectedCopyListId, listCopyOwner);

        vm.prank(listCopyOwner);
        uint120 copyId = validator.createListCopy(nameCopy, sourceListId);

        assertEq(copyId, expectedCopyListId);
        assertEq(validator.listOwners(copyId), listCopyOwner);

        address[] memory sourceWhitelistedAccounts = validator.getWhitelistedAccounts(sourceListId);
        address[] memory sourceBlacklistedAccounts = validator.getBlacklistedAccounts(sourceListId);
        address[] memory sourceAuthorizerAccounts = validator.getAuthorizerAccounts(sourceListId);
        bytes32[] memory sourceWhitelistedCodeHashes = validator.getWhitelistedCodeHashes(sourceListId);
        bytes32[] memory sourceBlacklistedCodeHashes = validator.getBlacklistedCodeHashes(sourceListId);

        address[] memory copyWhitelistedAccounts = validator.getWhitelistedAccounts(copyId);
        address[] memory copyBlacklistedAccounts = validator.getBlacklistedAccounts(copyId);
        address[] memory copyAuthorizerAccounts = validator.getAuthorizerAccounts(copyId);
        bytes32[] memory copyWhitelistedCodeHashes = validator.getWhitelistedCodeHashes(copyId);
        bytes32[] memory copyBlacklistedCodeHashes = validator.getBlacklistedCodeHashes(copyId);

        assertEq(sourceWhitelistedAccounts.length, copyWhitelistedAccounts.length);
        assertEq(sourceBlacklistedAccounts.length, copyBlacklistedAccounts.length);
        assertEq(sourceAuthorizerAccounts.length, copyAuthorizerAccounts.length);
        assertEq(sourceWhitelistedCodeHashes.length, copyWhitelistedCodeHashes.length);
        assertEq(sourceBlacklistedCodeHashes.length, copyBlacklistedCodeHashes.length);

        for (uint256 i = 0; i < sourceWhitelistedAccounts.length; i++) {
            assertEq(sourceWhitelistedAccounts[i], copyWhitelistedAccounts[i]);
        }

        for (uint256 i = 0; i < sourceBlacklistedAccounts.length; i++) {
            assertEq(sourceBlacklistedAccounts[i], copyBlacklistedAccounts[i]);
        }

        for (uint256 i = 0; i < sourceAuthorizerAccounts.length; i++) {
            assertEq(sourceAuthorizerAccounts[i], copyAuthorizerAccounts[i]);
        }

        for (uint256 i = 0; i < sourceWhitelistedCodeHashes.length; i++) {
            assertEq(sourceWhitelistedCodeHashes[i], copyWhitelistedCodeHashes[i]);
        }

        for (uint256 i = 0; i < sourceBlacklistedCodeHashes.length; i++) {
            assertEq(sourceBlacklistedCodeHashes[i], copyBlacklistedCodeHashes[i]);
        }
    }

    function testRevertsWhenCopyingNonExistentList(uint120 sourceListId) public {
        uint120 lastKnownListId = validator.lastListId();
        sourceListId = uint120(bound(sourceListId, lastKnownListId + 1, type(uint120).max));

        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__ListDoesNotExist.selector);
        validator.createListCopy("test", sourceListId);
    }

    function testReassignOwnershipOfList(address originalListOwner, address newListOwner) public {
        _sanitizeAddress(originalListOwner);
        _sanitizeAddress(newListOwner);
        vm.assume(originalListOwner != newListOwner);

        vm.prank(originalListOwner);
        uint120 listId = validator.createList("test");

        vm.expectEmit(true, true, true, false);
        emit ReassignedListOwnership(listId, newListOwner);

        vm.prank(originalListOwner);
        validator.reassignOwnershipOfList(listId, newListOwner);
        assertEq(validator.listOwners(listId), newListOwner);
    }

    function testRevertsWhenReassigningOwnershipOfListToZero(address originalListOwner) public {
        _sanitizeAddress(originalListOwner);

        vm.prank(originalListOwner);
        uint120 listId = validator.createList("test");

        vm.expectRevert(
            CreatorTokenTransferValidator
                .CreatorTokenTransferValidator__ListOwnershipCannotBeTransferredToZeroAddress
                .selector
        );
        validator.reassignOwnershipOfList(listId, address(0));
    }

    function testRevertsWhenNonOwnerReassignsOwnershipOfList(
        address originalListOwner,
        address unauthorizedUser
    ) public {
        _sanitizeAddress(originalListOwner);
        _sanitizeAddress(unauthorizedUser);
        vm.assume(originalListOwner != unauthorizedUser);

        vm.prank(originalListOwner);
        uint120 listId = validator.createList("test");

        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerDoesNotOwnList.selector);
        vm.prank(unauthorizedUser);
        validator.reassignOwnershipOfList(listId, unauthorizedUser);
    }

    function testRenounceOwnershipOfList(address originalListOwner) public {
        _sanitizeAddress(originalListOwner);

        vm.prank(originalListOwner);
        uint120 listId = validator.createList("test");

        vm.expectEmit(true, true, true, false);
        emit ReassignedListOwnership(listId, address(0));

        vm.prank(originalListOwner);
        validator.renounceOwnershipOfList(listId);
        assertEq(validator.listOwners(listId), address(0));
    }

    function testRevertsWhenNonOwnerRenouncesOwnershipOfList(
        address originalListOwner,
        address unauthorizedUser
    ) public {
        _sanitizeAddress(originalListOwner);
        _sanitizeAddress(unauthorizedUser);
        vm.assume(originalListOwner != unauthorizedUser);

        vm.prank(originalListOwner);
        uint120 listId = validator.createList("test");

        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerDoesNotOwnList.selector);
        vm.prank(unauthorizedUser);
        validator.renounceOwnershipOfList(listId);
    }

    function testSetTransferSecurityLevelOfCollection(
        address collection,
        uint8 level,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        _sanitizeAddress(collection);

        level = uint8(bound(level, TRANSFER_SECURITY_LEVEL_RECOMMENDED, TRANSFER_SECURITY_LEVEL_NINE));

        vm.expectEmit(true, true, true, true);
        emit SetTransferSecurityLevel(collection, level);

        vm.expectEmit(true, true, true, true);
        emit SetAuthorizationModeEnabled(collection, enableAuthorizationMode, authorizersCanSetWildcardOperators);

        vm.expectEmit(true, true, true, true);
        emit SetAccountFreezingModeEnabled(collection, enableAccountFreezingMode);

        vm.prank(collection);
        validator.setTransferSecurityLevelOfCollection(
            collection, 
            level, 
            enableAuthorizationMode, 
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode);

        CollectionSecurityPolicyV3 memory policy = validator.getCollectionSecurityPolicy(collection);

        assertEq(policy.transferSecurityLevel, level);
        assertEq(policy.enableAuthorizationMode, enableAuthorizationMode);
        assertEq(policy.authorizersCanSetWildcardOperators, authorizersCanSetWildcardOperators);
        assertEq(policy.enableAccountFreezingMode, enableAccountFreezingMode);
    }

    function testRevertsWhenSecurityLevelOutOfRangeForSetTransferSecurityLevelOfCollection(
        address collection,
        uint8 level,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        _sanitizeAddress(collection);

        level = uint8(bound(level, TRANSFER_SECURITY_LEVEL_NINE + 1, type(uint8).max));

        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__InvalidTransferSecurityLevel.selector);
        vm.prank(collection);
        validator.setTransferSecurityLevelOfCollection(collection, level, enableAuthorizationMode, authorizersCanSetWildcardOperators, enableAccountFreezingMode);
    }

    function testRevertsWhenUnauthorizedUserCallsSetTransferSecurityLevelOfCollection(
        address collection,
        address unauthorizedUser,
        uint8 level,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        _sanitizeAddress(collection);
        _sanitizeAddress(unauthorizedUser);
        vm.assume(collection != unauthorizedUser);

        level = uint8(bound(level, TRANSFER_SECURITY_LEVEL_RECOMMENDED, TRANSFER_SECURITY_LEVEL_NINE));

        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerMustHaveElevatedPermissionsForSpecifiedNFT.selector);
        vm.prank(unauthorizedUser);
        validator.setTransferSecurityLevelOfCollection(collection, level, enableAuthorizationMode, authorizersCanSetWildcardOperators, enableAccountFreezingMode);
    }

    function testApplyListToCollection(address collection) public {
        _sanitizeAddress(collection);

        uint120 listId = validator.createList("test");

        vm.expectEmit(true, true, true, true);
        emit AppliedListToCollection(collection, listId);

        vm.prank(collection);
        validator.applyListToCollection(collection, listId);

        CollectionSecurityPolicyV3 memory policy = validator.getCollectionSecurityPolicy(collection);
        assertEq(policy.listId, listId);
    }

    function testRevertsWhenApplyingNonExistentListIdToCollection(address collection, uint120 listId) public {
        _sanitizeAddress(collection);
        listId = uint120(bound(listId, validator.lastListId() + 1, type(uint120).max));

        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__ListDoesNotExist.selector);
        vm.prank(collection);
        validator.applyListToCollection(collection, listId);
    }

    function testRevertsWhenUnauthorizedUserAppliesListToCollection(
        address collection,
        address unauthorizedUser,
        uint120 listId
    ) public {
        _sanitizeAddress(collection);
        _sanitizeAddress(unauthorizedUser);
        vm.assume(collection != unauthorizedUser);

        listId = uint120(bound(listId, 0, validator.lastListId()));

        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerMustHaveElevatedPermissionsForSpecifiedNFT.selector);
        vm.prank(unauthorizedUser);
        validator.applyListToCollection(collection, listId);
    }

    function testFreezeAccountsForCollection(address collection, uint256 numAccountsToFreeze, address[10] memory accounts) public {
        _sanitizeAddress(collection);
        numAccountsToFreeze = bound(numAccountsToFreeze, 1, 10);

        uint256 expectedNumAccountsFrozen = 0;
        address[] memory accountsToFreeze = new address[](numAccountsToFreeze);
        for (uint256 i = 0; i < numAccountsToFreeze; i++) {
            bool firstTimeAccount = true;
            for (uint256 j = 0; j < i; j++) {
                if (accountsToFreeze[j] == accounts[i]) {
                    firstTimeAccount = false;
                    break;
                }
            }

            accountsToFreeze[i] = accounts[i];

            if (firstTimeAccount) {
                expectedNumAccountsFrozen++;
                vm.expectEmit(true, true, true, true);
                emit AccountFrozenForCollection(collection, accounts[i]);
            }
        }

        vm.prank(collection);
        validator.freezeAccountsForCollection(collection, accountsToFreeze);

        for (uint256 i = 0; i < numAccountsToFreeze; i++) {
            assertTrue(validator.isAccountFrozenForCollection(collection, accountsToFreeze[i]));
        }

        address[] memory frozenAccounts = validator.getFrozenAccountsByCollection(collection);
        assertEq(frozenAccounts.length, expectedNumAccountsFrozen);
    }

    function testRevertsWhenUnauthorizedUserCallsFreezeAccountsForCollection(
        address collection,
        address unauthorizedUser,
        uint256 numAccountsToFreeze,
        address[10] memory accounts
    ) public {
        _sanitizeAddress(collection);
        _sanitizeAddress(unauthorizedUser);
        vm.assume(collection != unauthorizedUser);

        numAccountsToFreeze = bound(numAccountsToFreeze, 1, 10);

        address[] memory accountsToFreeze = new address[](numAccountsToFreeze);
        for (uint256 i = 0; i < numAccountsToFreeze; i++) {
            accountsToFreeze[i] = accounts[i];
        }

        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerMustHaveElevatedPermissionsForSpecifiedNFT.selector);
        vm.prank(unauthorizedUser);
        validator.freezeAccountsForCollection(collection, accountsToFreeze);
    }

    function testUnfreezeAccountsForCollection(address collection, uint256 numAccountsToUnfreeze, address[10] memory accounts) public {
        _sanitizeAddress(collection);
        numAccountsToUnfreeze = bound(numAccountsToUnfreeze, 1, 10);

        address[] memory preFrozenAccounts = new address[](10);
        for (uint256 i = 0; i < 10; i++) {
            preFrozenAccounts[i] = accounts[i];
        }

        vm.prank(collection);
        validator.freezeAccountsForCollection(collection, preFrozenAccounts);

        uint256 numPreFrozenAccounts = validator.getFrozenAccountsByCollection(collection).length;

        uint256 expectedNumAccountsUnfrozen = 0;
        address[] memory accountsToUnfreeze = new address[](numAccountsToUnfreeze);
        for (uint256 i = 0; i < numAccountsToUnfreeze; i++) {
            bool firstTimeAccount = true;
            for (uint256 j = 0; j < i; j++) {
                if (accountsToUnfreeze[j] == accounts[i]) {
                    firstTimeAccount = false;
                    break;
                }
            }

            accountsToUnfreeze[i] = accounts[i];

            if (firstTimeAccount) {
                expectedNumAccountsUnfrozen++;
                vm.expectEmit(true, true, true, true);
                emit AccountUnfrozenForCollection(collection, accounts[i]);
            }
        }

        vm.prank(collection);
        validator.unfreezeAccountsForCollection(collection, accountsToUnfreeze);

        for (uint256 i = 0; i < numAccountsToUnfreeze; i++) {
            assertFalse(validator.isAccountFrozenForCollection(collection, accountsToUnfreeze[i]));
        }

        address[] memory frozenAccounts = validator.getFrozenAccountsByCollection(collection);
        assertEq(frozenAccounts.length, numPreFrozenAccounts - expectedNumAccountsUnfrozen);
    }

    function testRevertsWhenUnauthorizedUserCallsUnfreezeAccountsForCollection(
        address collection,
        address unauthorizedUser,
        uint256 numAccountsToUnfreeze,
        address[10] memory accounts
    ) public {
        _sanitizeAddress(collection);
        _sanitizeAddress(unauthorizedUser);
        vm.assume(collection != unauthorizedUser);

        numAccountsToUnfreeze = bound(numAccountsToUnfreeze, 1, 10);

        address[] memory accountsToUnfreeze = new address[](numAccountsToUnfreeze);
        for (uint256 i = 0; i < numAccountsToUnfreeze; i++) {
            accountsToUnfreeze[i] = accounts[i];
        }

        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerMustHaveElevatedPermissionsForSpecifiedNFT.selector);
        vm.prank(unauthorizedUser);
        validator.unfreezeAccountsForCollection(collection, accountsToUnfreeze);
    }

    function testAddAccountToBlacklist(address listOwner, address account) public {
        _sanitizeAddress(listOwner);
        _sanitizeAddress(account);

        vm.prank(listOwner);
        uint120 listId = validator.createList("test");

        vm.expectEmit(true, true, true, true);
        emit AddedAccountToList(LIST_TYPE_BLACKLIST, listId, account);

        vm.prank(listOwner);
        validator.addAccountToBlacklist(listId, account);
        assertTrue(validator.isAccountBlacklisted(listId, account));
    }

    function testRevertsWhenUnauthorizedUserAddsAccountToBlacklist(
        address listOwner,
        address unauthorizedUser,
        address account
    ) public {
        _sanitizeAddress(listOwner);
        _sanitizeAddress(unauthorizedUser);
        _sanitizeAddress(account);
        vm.assume(listOwner != unauthorizedUser);

        vm.prank(listOwner);
        uint120 listId = validator.createList("test");

        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerDoesNotOwnList.selector);
        vm.prank(unauthorizedUser);
        validator.addAccountToBlacklist(listId, account);
    }

    function testAddAccountsToBlacklist(address listOwner, uint256 numAccountsToBlacklist, address[10] memory accounts) public {
        _sanitizeAddress(listOwner);
        numAccountsToBlacklist = bound(numAccountsToBlacklist, 0, 10);

        vm.prank(listOwner);
        uint120 listId = validator.createList("test");

        uint256 expectedNumAccountsBlacklisted = 0;
        address[] memory accountsToBlacklist = new address[](numAccountsToBlacklist);
        for (uint256 i = 0; i < numAccountsToBlacklist; i++) {
            bool firstTimeAccount = true;
            for (uint256 j = 0; j < i; j++) {
                if (accountsToBlacklist[j] == accounts[i]) {
                    firstTimeAccount = false;
                    break;
                }
            }

            accountsToBlacklist[i] = accounts[i];

            if (firstTimeAccount) {
                expectedNumAccountsBlacklisted++;
                vm.expectEmit(true, true, true, true);
                emit AddedAccountToList(LIST_TYPE_BLACKLIST, listId, accounts[i]);
            }
        }

        vm.prank(listOwner);
        validator.addAccountsToBlacklist(listId, accountsToBlacklist);

        for (uint256 i = 0; i < numAccountsToBlacklist; i++) {
            assertTrue(validator.isAccountBlacklisted(listId, accountsToBlacklist[i]));
        }

        address[] memory blacklistedAccounts = validator.getBlacklistedAccounts(listId);
        assertEq(blacklistedAccounts.length, expectedNumAccountsBlacklisted);
    }

    function testRevertsWhenUnauthorizedUserAddsAccountsToBlacklist(
        address listOwner,
        address unauthorizedUser,
        uint256 numAccountsToBlacklist,
        address[10] memory accounts
    ) public {
        _sanitizeAddress(listOwner);
        _sanitizeAddress(unauthorizedUser);
        vm.assume(listOwner != unauthorizedUser);

        numAccountsToBlacklist = bound(numAccountsToBlacklist, 1, 10);

        address[] memory accountsToBlacklist = new address[](numAccountsToBlacklist);
        for (uint256 i = 0; i < numAccountsToBlacklist; i++) {
            accountsToBlacklist[i] = accounts[i];
        }

        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerDoesNotOwnList.selector);
        vm.prank(unauthorizedUser);
        validator.addAccountsToBlacklist(0, accountsToBlacklist);
    }

    function testRemoveAccountFromBlacklist(address listOwner, address account) public {
        _sanitizeAddress(listOwner);
        _sanitizeAddress(account);

        vm.startPrank(listOwner);
        uint120 listId = validator.createList("test");
        validator.addAccountToBlacklist(listId, account);

        vm.expectEmit(true, true, true, true);
        emit RemovedAccountFromList(LIST_TYPE_BLACKLIST, listId, account);

        validator.removeAccountFromBlacklist(listId, account);
        assertFalse(validator.isAccountBlacklisted(listId, account));
        vm.stopPrank();
    }

    function testRevertsWhenUnauthorizedUserRemovesAccountFromBlacklist(
        address listOwner,
        address unauthorizedUser,
        address account
    ) public {
        _sanitizeAddress(listOwner);
        _sanitizeAddress(unauthorizedUser);
        _sanitizeAddress(account);
        vm.assume(listOwner != unauthorizedUser);

        vm.startPrank(listOwner);
        uint120 listId = validator.createList("test");
        validator.addAccountToBlacklist(listId, account);
        vm.stopPrank();

        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerDoesNotOwnList.selector);
        vm.prank(unauthorizedUser);
        validator.removeAccountFromBlacklist(listId, account);
    }

    function testRemoveAccountsFromBlacklist(address listOwner, uint256 numAccountsToRemove, address[10] memory accounts) public {
        _sanitizeAddress(listOwner);
        numAccountsToRemove = bound(numAccountsToRemove, 1, 10);

        vm.startPrank(listOwner);
        uint120 listId = validator.createList("test");

        address[] memory accountsToBlacklist = new address[](10);
        for (uint256 i = 0; i < 10; i++) {
            accountsToBlacklist[i] = accounts[i];
        }

        validator.addAccountsToBlacklist(listId, accountsToBlacklist);
        vm.stopPrank();

        uint256 numPreBlacklistedAccounts = validator.getBlacklistedAccounts(listId).length;

        uint256 expectedNumAccountsRemoved = 0;
        address[] memory accountsToRemove = new address[](numAccountsToRemove);
        for (uint256 i = 0; i < numAccountsToRemove; i++) {
            bool firstTimeAccount = true;
            for (uint256 j = 0; j < i; j++) {
                if (accountsToRemove[j] == accounts[i]) {
                    firstTimeAccount = false;
                    break;
                }
            }

            accountsToRemove[i] = accounts[i];

            if (firstTimeAccount) {
                expectedNumAccountsRemoved++;
                vm.expectEmit(true, true, true, true);
                emit RemovedAccountFromList(LIST_TYPE_BLACKLIST, listId, accounts[i]);
            }
        }

        vm.prank(listOwner);
        validator.removeAccountsFromBlacklist(listId, accountsToRemove);

        for (uint256 i = 0; i < numAccountsToRemove; i++) {
            assertFalse(validator.isAccountBlacklisted(listId, accountsToRemove[i]));
        }

        address[] memory blacklistedAccounts = validator.getBlacklistedAccounts(listId);
        assertEq(blacklistedAccounts.length, numPreBlacklistedAccounts - expectedNumAccountsRemoved);
    }

    function testRevertsWhenUnauthorizedUserRemovesAccountsFromBlacklist(
        address listOwner,
        address unauthorizedUser,
        uint256 numAccountsToRemove,
        address[10] memory accounts
    ) public {
        _sanitizeAddress(listOwner);
        _sanitizeAddress(unauthorizedUser);
        vm.assume(listOwner != unauthorizedUser);

        vm.prank(listOwner);
        uint120 listId = validator.createList("test");

        numAccountsToRemove = bound(numAccountsToRemove, 1, 10);

        address[] memory accountsToRemove = new address[](numAccountsToRemove);
        for (uint256 i = 0; i < numAccountsToRemove; i++) {
            accountsToRemove[i] = accounts[i];
        }

        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerDoesNotOwnList.selector);
        vm.prank(unauthorizedUser);
        validator.removeAccountsFromBlacklist(listId, accountsToRemove);
    }

    function testAddAccountToWhitelist(address listOwner, address account) public {
        _sanitizeAddress(listOwner);
        _sanitizeAddress(account);

        vm.prank(listOwner);
        uint120 listId = validator.createList("test");

        vm.expectEmit(true, true, true, true);
        emit AddedAccountToList(LIST_TYPE_WHITELIST, listId, account);

        vm.prank(listOwner);
        validator.addAccountToWhitelist(listId, account);
        assertTrue(validator.isAccountWhitelisted(listId, account));
    }

    function testRevertsWhenUnauthorizedUserAddsAccountToWhitelist(
        address listOwner,
        address unauthorizedUser,
        address account
    ) public {
        _sanitizeAddress(listOwner);
        _sanitizeAddress(unauthorizedUser);
        _sanitizeAddress(account);
        vm.assume(listOwner != unauthorizedUser);

        vm.prank(listOwner);
        uint120 listId = validator.createList("test");

        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerDoesNotOwnList.selector);
        vm.prank(unauthorizedUser);
        validator.addAccountToWhitelist(listId, account);
    }

    function testAddAccountsToWhitelist(address listOwner, uint256 numAccountsToWhitelist, address[10] memory accounts) public {
        _sanitizeAddress(listOwner);
        numAccountsToWhitelist = bound(numAccountsToWhitelist, 1, 10);

        vm.prank(listOwner);
        uint120 listId = validator.createList("test");

        uint256 expectedNumAccountsWhitelisted = 0;
        address[] memory accountsToWhitelist = new address[](numAccountsToWhitelist);
        for (uint256 i = 0; i < numAccountsToWhitelist; i++) {
            bool firstTimeAccount = true;
            for (uint256 j = 0; j < i; j++) {
                if (accountsToWhitelist[j] == accounts[i]) {
                    firstTimeAccount = false;
                    break;
                }
            }

            accountsToWhitelist[i] = accounts[i];

            if (firstTimeAccount) {
                expectedNumAccountsWhitelisted++;
                vm.expectEmit(true, true, true, true);
                emit AddedAccountToList(LIST_TYPE_WHITELIST, listId, accounts[i]);
            }
        }

        vm.prank(listOwner);
        validator.addAccountsToWhitelist(listId, accountsToWhitelist);

        for (uint256 i = 0; i < numAccountsToWhitelist; i++) {
            assertTrue(validator.isAccountWhitelisted(listId, accountsToWhitelist[i]));
        }

        address[] memory whitelistedAccounts = validator.getWhitelistedAccounts(listId);
        assertEq(whitelistedAccounts.length, expectedNumAccountsWhitelisted);
    }

    function testRevertsWhenUnauthorizedUserAddsAccountsToWhitelist(
        address listOwner,
        address unauthorizedUser,
        uint256 numAccountsToWhitelist,
        address[10] memory accounts
    ) public {
        _sanitizeAddress(listOwner);
        _sanitizeAddress(unauthorizedUser);
        vm.assume(listOwner != unauthorizedUser);

        numAccountsToWhitelist = bound(numAccountsToWhitelist, 1, 10);

        address[] memory accountsToWhitelist = new address[](numAccountsToWhitelist);
        for (uint256 i = 0; i < numAccountsToWhitelist; i++) {
            accountsToWhitelist[i] = accounts[i];
        }

        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerDoesNotOwnList.selector);
        vm.prank(unauthorizedUser);
        validator.addAccountsToWhitelist(0, accountsToWhitelist);
    }

    function testRemoveAccountFromWhitelist(address listOwner, address account) public {
        _sanitizeAddress(listOwner);
        _sanitizeAddress(account);

        vm.startPrank(listOwner);
        uint120 listId = validator.createList("test");
        validator.addAccountToWhitelist(listId, account);

        vm.expectEmit(true, true, true, true);
        emit RemovedAccountFromList(LIST_TYPE_WHITELIST, listId, account);

        validator.removeAccountFromWhitelist(listId, account);
        assertFalse(validator.isAccountWhitelisted(listId, account));
        vm.stopPrank();
    }

    function testRevertsWhenUnauthorizedUserRemovesAccountFromWhitelist(
        address listOwner,
        address unauthorizedUser,
        address account
    ) public {
        _sanitizeAddress(listOwner);
        _sanitizeAddress(unauthorizedUser);
        _sanitizeAddress(account);
        vm.assume(listOwner != unauthorizedUser);

        vm.startPrank(listOwner);
        uint120 listId = validator.createList("test");
        validator.addAccountToWhitelist(listId, account);
        vm.stopPrank();

        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerDoesNotOwnList.selector);
        vm.prank(unauthorizedUser);
        validator.removeAccountFromWhitelist(listId, account);
    }

    function testRemoveAccountsFromWhitelist(address listOwner, uint256 numAccountsToRemove, address[10] memory accounts) public {
        _sanitizeAddress(listOwner);
        numAccountsToRemove = bound(numAccountsToRemove, 1, 10);

        vm.startPrank(listOwner);
        uint120 listId = validator.createList("test");

        address[] memory accountsToWhitelist = new address[](10);
        for (uint256 i = 0; i < 10; i++) {
            accountsToWhitelist[i] = accounts[i];
        }

        validator.addAccountsToWhitelist(listId, accountsToWhitelist);
        vm.stopPrank();

        uint256 numPreWhitelistedAccounts = validator.getWhitelistedAccounts(listId).length;

        uint256 expectedNumAccountsRemoved = 0;
        address[] memory accountsToRemove = new address[](numAccountsToRemove);
        for (uint256 i = 0; i < numAccountsToRemove; i++) {
            bool firstTimeAccount = true;
            for (uint256 j = 0; j < i; j++) {
                if (accountsToRemove[j] == accounts[i]) {
                    firstTimeAccount = false;
                    break;
                }
            }

            accountsToRemove[i] = accounts[i];

            if (firstTimeAccount) {
                expectedNumAccountsRemoved++;
                vm.expectEmit(true, true, true, true);
                emit RemovedAccountFromList(LIST_TYPE_WHITELIST, listId, accounts[i]);
            }
        }

        vm.prank(listOwner);
        validator.removeAccountsFromWhitelist(listId, accountsToRemove);

        for (uint256 i = 0; i < numAccountsToRemove; i++) {
            assertFalse(validator.isAccountWhitelisted(listId, accountsToRemove[i]));
        }

        address[] memory whitelistedAccounts = validator.getWhitelistedAccounts(listId);
        assertEq(whitelistedAccounts.length, numPreWhitelistedAccounts - expectedNumAccountsRemoved);
    }

    function testRevertsWhenUnauthorizedUserRemovesAccountsFromWhitelist(
        address listOwner,
        address unauthorizedUser,
        uint256 numAccountsToRemove,
        address[10] memory accounts
    ) public {
        _sanitizeAddress(listOwner);
        _sanitizeAddress(unauthorizedUser);
        vm.assume(listOwner != unauthorizedUser);

        vm.prank(listOwner);
        uint120 listId = validator.createList("test");

        numAccountsToRemove = bound(numAccountsToRemove, 1, 10);

        address[] memory accountsToRemove = new address[](numAccountsToRemove);
        for (uint256 i = 0; i < numAccountsToRemove; i++) {
            accountsToRemove[i] = accounts[i];
        }

        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerDoesNotOwnList.selector);
        vm.prank(unauthorizedUser);
        validator.removeAccountsFromWhitelist(listId, accountsToRemove);
    }

    function testAddAccountToAuthorizerList(address listOwner, address account) public {
        _sanitizeAddress(listOwner);
        _sanitizeAddress(account);

        vm.prank(listOwner);
        uint120 listId = validator.createList("test");

        vm.expectEmit(true, true, true, true);
        emit AddedAccountToList(LIST_TYPE_AUTHORIZERS, listId, account);

        vm.prank(listOwner);
        validator.addAccountToAuthorizers(listId, account);
        assertTrue(validator.isAccountAuthorizer(listId, account));
    }

    function testRevertsWhenUnauthorizedUserAddsAccountToAuthorizerList(
        address listOwner,
        address unauthorizedUser,
        address account
    ) public {
        _sanitizeAddress(listOwner);
        _sanitizeAddress(unauthorizedUser);
        _sanitizeAddress(account);
        vm.assume(listOwner != unauthorizedUser);

        vm.prank(listOwner);
        uint120 listId = validator.createList("test");

        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerDoesNotOwnList.selector);
        vm.prank(unauthorizedUser);
        validator.addAccountToAuthorizers(listId, account);
    }

    function testAddAccountsToAuthorizerList(address listOwner, uint256 numAccountsToAuthorize, address[10] memory accounts) public {
        _sanitizeAddress(listOwner);
        numAccountsToAuthorize = bound(numAccountsToAuthorize, 1, 10);

        vm.prank(listOwner);
        uint120 listId = validator.createList("test");

        uint256 expectedNumAccountsAuthorized = 0;
        address[] memory accountsToAuthorize = new address[](numAccountsToAuthorize);
        for (uint256 i = 0; i < numAccountsToAuthorize; i++) {
            bool firstTimeAccount = true;
            for (uint256 j = 0; j < i; j++) {
                if (accountsToAuthorize[j] == accounts[i]) {
                    firstTimeAccount = false;
                    break;
                }
            }

            accountsToAuthorize[i] = accounts[i];

            if (firstTimeAccount) {
                expectedNumAccountsAuthorized++;
                vm.expectEmit(true, true, true, true);
                emit AddedAccountToList(LIST_TYPE_AUTHORIZERS, listId, accounts[i]);
            }
        }

        vm.prank(listOwner);
        validator.addAccountsToAuthorizers(listId, accountsToAuthorize);

        for (uint256 i = 0; i < numAccountsToAuthorize; i++) {
            assertTrue(validator.isAccountAuthorizer(listId, accountsToAuthorize[i]));
        }

        address[] memory authorizerAccounts = validator.getAuthorizerAccounts(listId);
        assertEq(authorizerAccounts.length, expectedNumAccountsAuthorized);
    }

    function testRevertsWhenUnauthorizedUserAddsAccountsToAuthorizerList(
        address listOwner,
        address unauthorizedUser,
        uint256 numAccountsToAuthorize,
        address[10] memory accounts
    ) public {
        _sanitizeAddress(listOwner);
        _sanitizeAddress(unauthorizedUser);
        vm.assume(listOwner != unauthorizedUser);

        numAccountsToAuthorize = bound(numAccountsToAuthorize, 1, 10);

        address[] memory accountsToAuthorize = new address[](numAccountsToAuthorize);
        for (uint256 i = 0; i < numAccountsToAuthorize; i++) {
            accountsToAuthorize[i] = accounts[i];
        }

        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerDoesNotOwnList.selector);
        vm.prank(unauthorizedUser);
        validator.addAccountsToAuthorizers(0, accountsToAuthorize);
    }

    function testRemoveAccountFromAuthorizerList(address listOwner, address account) public {
        _sanitizeAddress(listOwner);
        _sanitizeAddress(account);

        vm.startPrank(listOwner);
        uint120 listId = validator.createList("test");
        validator.addAccountToAuthorizers(listId, account);

        vm.expectEmit(true, true, true, true);
        emit RemovedAccountFromList(LIST_TYPE_AUTHORIZERS, listId, account);

        validator.removeAccountFromAuthorizers(listId, account);
        assertFalse(validator.isAccountAuthorizer(listId, account));
        vm.stopPrank();
    }

    function testRevertsWhenUnauthorizedUserRemovesAccountFromAuthorizerList(
        address listOwner,
        address unauthorizedUser,
        address account
    ) public {
        _sanitizeAddress(listOwner);
        _sanitizeAddress(unauthorizedUser);
        _sanitizeAddress(account);
        vm.assume(listOwner != unauthorizedUser);

        vm.startPrank(listOwner);
        uint120 listId = validator.createList("test");
        validator.addAccountToAuthorizers(listId, account);
        vm.stopPrank();

        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerDoesNotOwnList.selector);
        vm.prank(unauthorizedUser);
        validator.removeAccountFromAuthorizers(listId, account);
    }

    function testRemoveAccountsFromAuthorizerList(address listOwner, uint256 numAccountsToRemove, address[10] memory accounts) public {
        _sanitizeAddress(listOwner);
        numAccountsToRemove = bound(numAccountsToRemove, 1, 10);

        vm.startPrank(listOwner);
        uint120 listId = validator.createList("test");

        address[] memory accountsToAuthorize = new address[](10);
        for (uint256 i = 0; i < 10; i++) {
            accountsToAuthorize[i] = accounts[i];
        }

        validator.addAccountsToAuthorizers(listId, accountsToAuthorize);
        vm.stopPrank();

        uint256 numPreAuthorizedAccounts = validator.getAuthorizerAccounts(listId).length;

        uint256 expectedNumAccountsRemoved = 0;
        address[] memory accountsToRemove = new address[](numAccountsToRemove);
        for (uint256 i = 0; i < numAccountsToRemove; i++) {
            bool firstTimeAccount = true;
            for (uint256 j = 0; j < i; j++) {
                if (accountsToRemove[j] == accounts[i]) {
                    firstTimeAccount = false;
                    break;
                }
            }

            accountsToRemove[i] = accounts[i];

            if (firstTimeAccount) {
                expectedNumAccountsRemoved++;
                vm.expectEmit(true, true, true, true);
                emit RemovedAccountFromList(LIST_TYPE_AUTHORIZERS, listId, accounts[i]);
            }
        }

        vm.prank(listOwner);
        validator.removeAccountsFromAuthorizers(listId, accountsToRemove);

        for (uint256 i = 0; i < numAccountsToRemove; i++) {
            assertFalse(validator.isAccountAuthorizer(listId, accountsToRemove[i]));
        }

        address[] memory authorizerAccounts = validator.getAuthorizerAccounts(listId);
        assertEq(authorizerAccounts.length, numPreAuthorizedAccounts - expectedNumAccountsRemoved);
    }

    function testRevertsWhenUnauthorizedUserRemovesAccountsFromAuthorizerList(
        address listOwner,
        address unauthorizedUser,
        uint256 numAccountsToRemove,
        address[10] memory accounts
    ) public {
        _sanitizeAddress(listOwner);
        _sanitizeAddress(unauthorizedUser);
        vm.assume(listOwner != unauthorizedUser);

        vm.prank(listOwner);
        uint120 listId = validator.createList("test");

        numAccountsToRemove = bound(numAccountsToRemove, 1, 10);

        address[] memory accountsToRemove = new address[](numAccountsToRemove);
        for (uint256 i = 0; i < numAccountsToRemove; i++) {
            accountsToRemove[i] = accounts[i];
        }

        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerDoesNotOwnList.selector);
        vm.prank(unauthorizedUser);
        validator.removeAccountsFromAuthorizers(listId, accountsToRemove);
    }

    function testAddCodeHashesToBlacklist(address listOwner, uint256 numCodeHashesToBlacklist, bytes32[10] memory codeHashes) public {
        _sanitizeAddress(listOwner);
        numCodeHashesToBlacklist = bound(numCodeHashesToBlacklist, 1, 10);

        vm.prank(listOwner);
        uint120 listId = validator.createList("test");

        uint256 expectedNumCodeHashesBlacklisted = 0;
        bytes32[] memory codeHashesToBlacklist = new bytes32[](numCodeHashesToBlacklist);
        for (uint256 i = 0; i < numCodeHashesToBlacklist; i++) {
            bool firstTimeCodeHash = true;
            for (uint256 j = 0; j < i; j++) {
                if (codeHashesToBlacklist[j] == codeHashes[i]) {
                    firstTimeCodeHash = false;
                    break;
                }
            }

            codeHashesToBlacklist[i] = codeHashes[i];

            if (firstTimeCodeHash) {
                expectedNumCodeHashesBlacklisted++;
                vm.expectEmit(true, true, true, true);
                emit AddedCodeHashToList(LIST_TYPE_BLACKLIST, listId, codeHashes[i]);
            }
        }

        vm.prank(listOwner);
        validator.addCodeHashesToBlacklist(listId, codeHashesToBlacklist);

        for (uint256 i = 0; i < numCodeHashesToBlacklist; i++) {
            assertTrue(validator.isCodeHashBlacklisted(listId, codeHashesToBlacklist[i]));
        }

        bytes32[] memory blacklistedCodeHashes = validator.getBlacklistedCodeHashes(listId);
        assertEq(blacklistedCodeHashes.length, expectedNumCodeHashesBlacklisted);
    }

    function testRevertsWhenUnauthorizedUserAddsCodeHashesToBlacklist(
        address listOwner,
        address unauthorizedUser,
        uint256 numCodeHashesToBlacklist,
        bytes32[10] memory codeHashes
    ) public {
        _sanitizeAddress(listOwner);
        _sanitizeAddress(unauthorizedUser);
        vm.assume(listOwner != unauthorizedUser);

        numCodeHashesToBlacklist = bound(numCodeHashesToBlacklist, 1, 10);

        bytes32[] memory codeHashesToBlacklist = new bytes32[](numCodeHashesToBlacklist);
        for (uint256 i = 0; i < numCodeHashesToBlacklist; i++) {
            codeHashesToBlacklist[i] = codeHashes[i];
        }

        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerDoesNotOwnList.selector);
        vm.prank(unauthorizedUser);
        validator.addCodeHashesToBlacklist(0, codeHashesToBlacklist);
    }

    function testRemoveCodeHashesFromBlacklist(address listOwner, uint256 numCodeHashesToRemove, bytes32[10] memory codeHashes) public {
        _sanitizeAddress(listOwner);
        numCodeHashesToRemove = bound(numCodeHashesToRemove, 1, 10);

        vm.startPrank(listOwner);
        uint120 listId = validator.createList("test");

        bytes32[] memory codeHashesToBlacklist = new bytes32[](10);
        for (uint256 i = 0; i < 10; i++) {
            codeHashesToBlacklist[i] = codeHashes[i];
        }

        validator.addCodeHashesToBlacklist(listId, codeHashesToBlacklist);
        vm.stopPrank();

        uint256 numPreBlacklistedCodeHashes = validator.getBlacklistedCodeHashes(listId).length;

        uint256 expectedNumCodeHashesRemoved = 0;
        bytes32[] memory codeHashesToRemove = new bytes32[](numCodeHashesToRemove);
        for (uint256 i = 0; i < numCodeHashesToRemove; i++) {
            bool firstTimeCodeHash = true;
            for (uint256 j = 0; j < i; j++) {
                if (codeHashesToRemove[j] == codeHashes[i]) {
                    firstTimeCodeHash = false;
                    break;
                }
            }

            codeHashesToRemove[i] = codeHashes[i];

            if (firstTimeCodeHash) {
                expectedNumCodeHashesRemoved++;
                vm.expectEmit(true, true, true, true);
                emit RemovedCodeHashFromList(LIST_TYPE_BLACKLIST, listId, codeHashes[i]);
            }
        }

        vm.prank(listOwner);
        validator.removeCodeHashesFromBlacklist(listId, codeHashesToRemove);

        for (uint256 i = 0; i < numCodeHashesToRemove; i++) {
            assertFalse(validator.isCodeHashBlacklisted(listId, codeHashesToRemove[i]));
        }

        bytes32[] memory blacklistedCodeHashes = validator.getBlacklistedCodeHashes(listId);
        assertEq(blacklistedCodeHashes.length, numPreBlacklistedCodeHashes - expectedNumCodeHashesRemoved);
    }

    function testRevertsWhenUnauthorizedUserRemovesCodeHashesFromBlacklist(
        address listOwner,
        address unauthorizedUser,
        uint256 numCodeHashesToRemove,
        bytes32[10] memory codeHashes
    ) public {
        _sanitizeAddress(listOwner);
        _sanitizeAddress(unauthorizedUser);
        vm.assume(listOwner != unauthorizedUser);

        vm.prank(listOwner);
        uint120 listId = validator.createList("test");

        numCodeHashesToRemove = bound(numCodeHashesToRemove, 1, 10);

        bytes32[] memory codeHashesToRemove = new bytes32[](numCodeHashesToRemove);
        for (uint256 i = 0; i < numCodeHashesToRemove; i++) {
            codeHashesToRemove[i] = codeHashes[i];
        }

        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerDoesNotOwnList.selector);
        vm.prank(unauthorizedUser);
        validator.removeCodeHashesFromBlacklist(listId, codeHashesToRemove);
    }

    function testAddCodeHashesToWhitelist(address listOwner, uint256 numCodeHashesToWhitelist, bytes32[10] memory codeHashes) public {
        _sanitizeAddress(listOwner);
        numCodeHashesToWhitelist = bound(numCodeHashesToWhitelist, 1, 10);

        vm.prank(listOwner);
        uint120 listId = validator.createList("test");

        uint256 expectedNumCodeHashesWhitelisted = 0;
        bytes32[] memory codeHashesToWhitelist = new bytes32[](numCodeHashesToWhitelist);
        for (uint256 i = 0; i < numCodeHashesToWhitelist; i++) {
            bool firstTimeCodeHash = true;
            for (uint256 j = 0; j < i; j++) {
                if (codeHashesToWhitelist[j] == codeHashes[i]) {
                    firstTimeCodeHash = false;
                    break;
                }
            }

            codeHashesToWhitelist[i] = codeHashes[i];

            if (firstTimeCodeHash) {
                expectedNumCodeHashesWhitelisted++;
                vm.expectEmit(true, true, true, true);
                emit AddedCodeHashToList(LIST_TYPE_WHITELIST, listId, codeHashes[i]);
            }
        }

        vm.prank(listOwner);
        validator.addCodeHashesToWhitelist(listId, codeHashesToWhitelist);

        for (uint256 i = 0; i < numCodeHashesToWhitelist; i++) {
            assertTrue(validator.isCodeHashWhitelisted(listId, codeHashesToWhitelist[i]));
        }

        bytes32[] memory whitelistedCodeHashes = validator.getWhitelistedCodeHashes(listId);
        assertEq(whitelistedCodeHashes.length, expectedNumCodeHashesWhitelisted);
    }

    function testRevertsWhenUnauthorizedUserAddsCodeHashesToWhitelist(
        address listOwner,
        address unauthorizedUser,
        uint256 numCodeHashesToWhitelist,
        bytes32[10] memory codeHashes
    ) public {
        _sanitizeAddress(listOwner);
        _sanitizeAddress(unauthorizedUser);
        vm.assume(listOwner != unauthorizedUser);

        numCodeHashesToWhitelist = bound(numCodeHashesToWhitelist, 1, 10);

        bytes32[] memory codeHashesToWhitelist = new bytes32[](numCodeHashesToWhitelist);
        for (uint256 i = 0; i < numCodeHashesToWhitelist; i++) {
            codeHashesToWhitelist[i] = codeHashes[i];
        }

        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerDoesNotOwnList.selector);
        vm.prank(unauthorizedUser);
        validator.addCodeHashesToWhitelist(0, codeHashesToWhitelist);
    }

    function testRemoveCodeHashesFromWhitelist(address listOwner, uint256 numCodeHashesToRemove, bytes32[10] memory codeHashes) public {
        _sanitizeAddress(listOwner);
        numCodeHashesToRemove = bound(numCodeHashesToRemove, 1, 10);

        vm.startPrank(listOwner);
        uint120 listId = validator.createList("test");

        bytes32[] memory codeHashesToWhitelist = new bytes32[](10);
        for (uint256 i = 0; i < 10; i++) {
            codeHashesToWhitelist[i] = codeHashes[i];
        }

        validator.addCodeHashesToWhitelist(listId, codeHashesToWhitelist);
        vm.stopPrank();

        uint256 numPreWhitelistedCodeHashes = validator.getWhitelistedCodeHashes(listId).length;

        uint256 expectedNumCodeHashesRemoved = 0;
        bytes32[] memory codeHashesToRemove = new bytes32[](numCodeHashesToRemove);
        for (uint256 i = 0; i < numCodeHashesToRemove; i++) {
            bool firstTimeCodeHash = true;
            for (uint256 j = 0; j < i; j++) {
                if (codeHashesToRemove[j] == codeHashes[i]) {
                    firstTimeCodeHash = false;
                    break;
                }
            }

            codeHashesToRemove[i] = codeHashes[i];

            if (firstTimeCodeHash) {
                expectedNumCodeHashesRemoved++;
                vm.expectEmit(true, true, true, true);
                emit RemovedCodeHashFromList(LIST_TYPE_WHITELIST, listId, codeHashes[i]);
            }
        }

        vm.prank(listOwner);
        validator.removeCodeHashesFromWhitelist(listId, codeHashesToRemove);

        for (uint256 i = 0; i < numCodeHashesToRemove; i++) {
            assertFalse(validator.isCodeHashWhitelisted(listId, codeHashesToRemove[i]));
        }

        bytes32[] memory whitelistedCodeHashes = validator.getWhitelistedCodeHashes(listId);
        assertEq(whitelistedCodeHashes.length, numPreWhitelistedCodeHashes - expectedNumCodeHashesRemoved);
    }

    function testRevertsWhenUnauthorizedUserRemovesCodeHashesFromWhitelist(
        address listOwner,
        address unauthorizedUser,
        uint256 numCodeHashesToRemove,
        bytes32[10] memory codeHashes
    ) public {
        _sanitizeAddress(listOwner);
        _sanitizeAddress(unauthorizedUser);
        vm.assume(listOwner != unauthorizedUser);

        vm.prank(listOwner);
        uint120 listId = validator.createList("test");

        numCodeHashesToRemove = bound(numCodeHashesToRemove, 1, 10);

        bytes32[] memory codeHashesToRemove = new bytes32[](numCodeHashesToRemove);
        for (uint256 i = 0; i < numCodeHashesToRemove; i++) {
            codeHashesToRemove[i] = codeHashes[i];
        }

        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerDoesNotOwnList.selector);
        vm.prank(unauthorizedUser);
        validator.removeCodeHashesFromWhitelist(listId, codeHashesToRemove);
    }

    // Validation of Transfers Level 1

    struct FuzzedList {
        address whitelistedAddress;
        address whitelistedToAddress;
        address blacklistedAddress;
        address authorizerAddress;
        bytes32 whitelistedCode;
        bytes32 blacklistedCode;
    }

    function testAllowsAllTransfersAtLevelOne(
        FuzzedList memory fuzzedList,
        address collection,
        address caller,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        _sanitizeAccounts(collection, caller, from, to);

        _configureCollectionSecurity(
            collection, 
            fuzzedList, 
            TRANSFER_SECURITY_LEVEL_ONE, 
            enableAuthorizationMode, 
            authorizersCanSetWildcardOperators, 
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    // Validation of Transfers Level 2

    function testAllowsAllTransfersAtLevelTwoWhenCallerIsNotBlacklisted(
        FuzzedList memory fuzzedList,
        address collection,
        address caller,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(fuzzedList.blacklistedAddress != caller);

        _configureCollectionSecurity(
            collection, 
            fuzzedList, 
            TRANSFER_SECURITY_LEVEL_TWO, 
            enableAuthorizationMode, 
            authorizersCanSetWildcardOperators, 
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testRevertsAllTransfersAtLevelTwoWhenCallerIsBlacklistedAccount(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = fuzzedList.blacklistedAddress;

        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(caller != from);

        _configureCollectionSecurity(
            collection, 
            fuzzedList, 
            TRANSFER_SECURITY_LEVEL_TWO, 
            enableAuthorizationMode, 
            authorizersCanSetWildcardOperators, 
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount, 
            CreatorTokenTransferValidator.CreatorTokenTransferValidator__OperatorIsBlacklisted.selector
        );
    }

    function testRevertsAllTransfersAtLevelTwoWhenCallerIsBlacklistedCodeHash(
        FuzzedList memory fuzzedList,
        address collection,
        address caller,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(caller != from);

        _etchCodeToCaller(caller, fuzzedList.blacklistedCode);

        _configureCollectionSecurity(
            collection, 
            fuzzedList, 
            TRANSFER_SECURITY_LEVEL_TWO, 
            enableAuthorizationMode, 
            authorizersCanSetWildcardOperators, 
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount, 
            CreatorTokenTransferValidator.CreatorTokenTransferValidator__OperatorIsBlacklisted.selector
        );
    }

    // Validation of Transfers Level 3

    function testAllowsAllTransfersAtLevelThreeWhenCallerIsWhitelistedAccount(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = fuzzedList.whitelistedAddress;
        _sanitizeAccounts(collection, caller, from, to);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_THREE,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testAllowsAllTransfersAtLevelThreeWhenCallerIsWhitelistedCodeHash(
        FuzzedList memory fuzzedList,
        address collection,
        address caller,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        _sanitizeAccounts(collection, caller, from, to);

        _etchCodeToCaller(caller, fuzzedList.whitelistedCode);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_THREE,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testAllowsOTCTransfersAtLevelThree(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = from;
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(caller != fuzzedList.whitelistedAddress);
        vm.assume(caller != fuzzedList.whitelistedToAddress);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_THREE,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testRevertsAllTransfersAtLevelThreeWhenCallerIsNotWhitelistedAccount(
        FuzzedList memory fuzzedList,
        address collection,
        address caller,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(caller != from);
        vm.assume(caller != fuzzedList.whitelistedAddress);
        vm.assume(caller != fuzzedList.whitelistedToAddress);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_THREE,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerMustBeWhitelisted.selector
        );
    }

    // Validation of Transfers Level 4

    function testAllowsAllTransfersAtLevelFourWhenCallerIsWhitelistedAccount(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = fuzzedList.whitelistedAddress;
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(caller != from);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_FOUR,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testAllowsAllTransfersAtLevelFourWhenFromIsWhitelistedAccount(
        FuzzedList memory fuzzedList,
        address collection,
        address caller,
        address to,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address from = fuzzedList.whitelistedAddress;
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(caller != from);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_FOUR,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testAllowsAllTransfersAtLevelFourWhenCallerIsWhitelistedCodeHash(
        FuzzedList memory fuzzedList,
        address collection,
        address caller,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(caller != from);

        _etchCodeToCaller(caller, fuzzedList.whitelistedCode);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_FOUR,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testAllowsAllTransfersAtLevelFourWhenFromIsWhitelistedCodeHash(
        FuzzedList memory fuzzedList,
        address collection,
        address caller,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(caller != from);

        _etchCodeToCaller(from, fuzzedList.whitelistedCode);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_FOUR,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testRevertsOTCTransfersAtLevelFour(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = from;
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(caller != fuzzedList.whitelistedAddress);
        vm.assume(caller != fuzzedList.whitelistedToAddress);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_FOUR,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerMustBeWhitelisted.selector
        );
    }

    function testRevertsAllTransfersAtLevelFourWhenCallerIsNotWhitelistedAccount(
        FuzzedList memory fuzzedList,
        address collection,
        address caller,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(caller != fuzzedList.whitelistedAddress);
        vm.assume(caller != fuzzedList.whitelistedToAddress);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_FOUR,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerMustBeWhitelisted.selector
        );
    }

    // Validation of Transfers Level 5

    function testAllowsAllTransfersAtLevelFiveWhenCallerIsWhitelistedAccountAndReceiverHasNoCode(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = fuzzedList.whitelistedAddress;
        _sanitizeAccounts(collection, caller, from, to);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_FIVE,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testAllowsTransfersAtLevelFiveWhenReceiverHashCodeButAccountIsWhitelisted(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = fuzzedList.whitelistedAddress;
        address to = fuzzedList.whitelistedToAddress;
        _sanitizeAccounts(collection, caller, from, to);

        _etchCodeToCaller(to, fuzzedList.whitelistedCode);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_FIVE,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testAllowsTransfersAtLevelFiveWhenReceiverHashCodeButCodeHashIsWhitelisted(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = fuzzedList.whitelistedAddress;
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(to != fuzzedList.whitelistedAddress);
        vm.assume(to != fuzzedList.whitelistedToAddress);

        _etchCodeToCaller(to, fuzzedList.whitelistedCode);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_FIVE,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testRevertsTransfersAtLevelFiveWhenReceiverHasCode(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = fuzzedList.whitelistedAddress;
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(to != fuzzedList.whitelistedAddress);
        vm.assume(to != fuzzedList.whitelistedToAddress);

        _etchCodeToCaller(to, fuzzedList.blacklistedCode);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_FIVE,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            CreatorTokenTransferValidator.CreatorTokenTransferValidator__ReceiverMustNotHaveDeployedCode.selector
        );
    }

    function testAllowsAllTransfersAtLevelFiveWhenCallerIsWhitelistedAccount(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = fuzzedList.whitelistedAddress;
        address to = fuzzedList.whitelistedToAddress;
        _sanitizeAccounts(collection, caller, from, to);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_FIVE,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testAllowsAllTransfersAtLevelFiveWhenCallerIsWhitelistedCodeHash(
        FuzzedList memory fuzzedList,
        address collection,
        address caller,
        address from, 
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address to = fuzzedList.whitelistedToAddress;
        _sanitizeAccounts(collection, caller, from, to);

        _etchCodeToCaller(caller, fuzzedList.whitelistedCode);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_FIVE,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testAllowsOTCTransfersAtLevelFive(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = from;
        address to = fuzzedList.whitelistedToAddress;
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(caller != fuzzedList.whitelistedAddress);
        vm.assume(caller != fuzzedList.whitelistedToAddress);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_FIVE,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testRevertsAllTransfersAtLevelFiveWhenCallerIsNotWhitelistedAccount(
        FuzzedList memory fuzzedList,
        address collection,
        address caller,
        address from, 
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address to = fuzzedList.whitelistedToAddress;
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(caller != from);
        vm.assume(caller != fuzzedList.whitelistedAddress);
        vm.assume(caller != fuzzedList.whitelistedToAddress);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_FIVE,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerMustBeWhitelisted.selector
        );
    }

    // Validation of Transfers Level 6

    function testAllowsAllTransfersAtLevelSixWhenCallerIsWhitelistedAccountAndReceiverIsVerifiedEOA(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        uint160 toKey,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address to = _verifyEOA(toKey);
        address caller = fuzzedList.whitelistedAddress;
        _sanitizeAccounts(collection, caller, from, to);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_SIX,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testAllowsTransfersAtLevelSixWhenReceiverIsNotAVerifiedEOAButAccountIsWhitelisted(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = fuzzedList.whitelistedAddress;
        address to = fuzzedList.whitelistedToAddress;
        _sanitizeAccounts(collection, caller, from, to);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_SIX,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testAllowsTransfersAtLevelSixWhenReceiverIsNotVerifiedEOAButCodeHashIsWhitelisted(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = fuzzedList.whitelistedAddress;
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(to != fuzzedList.whitelistedAddress);
        vm.assume(to != fuzzedList.whitelistedToAddress);

        _etchCodeToCaller(to, fuzzedList.whitelistedCode);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_SIX,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testRevertsTransfersAtLevelSixWhenReceiverHasNotVerifiedThatTheyAreAnEOA(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = fuzzedList.whitelistedAddress;
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(to != fuzzedList.whitelistedAddress);
        vm.assume(to != fuzzedList.whitelistedToAddress);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_SIX,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            CreatorTokenTransferValidator.CreatorTokenTransferValidator__ReceiverProofOfEOASignatureUnverified.selector
        );
    }

    function testAllowsAllTransfersAtLevelSixWhenCallerIsWhitelistedAccount(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = fuzzedList.whitelistedAddress;
        address to = fuzzedList.whitelistedToAddress;
        _sanitizeAccounts(collection, caller, from, to);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_SIX,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testAllowsAllTransfersAtLevelSixWhenCallerIsWhitelistedCodeHash(
        FuzzedList memory fuzzedList,
        address collection,
        address caller,
        address from, 
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address to = fuzzedList.whitelistedToAddress;
        _sanitizeAccounts(collection, caller, from, to);

        _etchCodeToCaller(caller, fuzzedList.whitelistedCode);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_SIX,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testAllowsOTCTransfersAtLevelSix(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = from;
        address to = fuzzedList.whitelistedToAddress;
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(caller != fuzzedList.whitelistedAddress);
        vm.assume(caller != fuzzedList.whitelistedToAddress);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_SIX,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testRevertsAllTransfersAtLevelSixWhenCallerIsNotWhitelistedAccount(
        FuzzedList memory fuzzedList,
        address collection,
        address caller,
        address from, 
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address to = fuzzedList.whitelistedToAddress;
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(caller != from);
        vm.assume(caller != fuzzedList.whitelistedAddress);
        vm.assume(caller != fuzzedList.whitelistedToAddress);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_SIX,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerMustBeWhitelisted.selector
        );
    }

    // Validation of Transfers Level 7

    function testAllowsAllTransfersAtLevelSevenWhenCallerIsWhitelistedAccountAndReceiverHasNoCode(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = fuzzedList.whitelistedAddress;
        _sanitizeAccounts(collection, caller, from, to);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_SEVEN,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testAllowsTransfersAtLevelSevenWhenReceiverHashCodeButAccountIsWhitelisted(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = fuzzedList.whitelistedAddress;
        address to = fuzzedList.whitelistedToAddress;
        _sanitizeAccounts(collection, caller, from, to);

        _etchCodeToCaller(to, fuzzedList.whitelistedCode);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_SEVEN,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testAllowsTransfersAtLevelSevenWhenReceiverHashCodeButCodeHashIsWhitelisted(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = fuzzedList.whitelistedAddress;
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(to != fuzzedList.whitelistedAddress);
        vm.assume(to != fuzzedList.whitelistedToAddress);

        _etchCodeToCaller(to, fuzzedList.whitelistedCode);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_SEVEN,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testRevertsTransfersAtLevelSevenWhenReceiverHasCode(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = fuzzedList.whitelistedAddress;
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(to != fuzzedList.whitelistedAddress);
        vm.assume(to != fuzzedList.whitelistedToAddress);

        _etchCodeToCaller(to, fuzzedList.blacklistedCode);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_SEVEN,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            CreatorTokenTransferValidator.CreatorTokenTransferValidator__ReceiverMustNotHaveDeployedCode.selector
        );
    }

    function testAllowsAllTransfersAtLevelSevenWhenCallerIsWhitelistedAccount(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = fuzzedList.whitelistedAddress;
        address to = fuzzedList.whitelistedToAddress;
        _sanitizeAccounts(collection, caller, from, to);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_SEVEN,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testAllowsAllTransfersAtLevelSevenWhenCallerIsWhitelistedCodeHash(
        FuzzedList memory fuzzedList,
        address collection,
        address caller,
        address from, 
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address to = fuzzedList.whitelistedToAddress;
        _sanitizeAccounts(collection, caller, from, to);

        _etchCodeToCaller(caller, fuzzedList.whitelistedCode);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_SEVEN,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testRevertsOTCTransfersAtLevelSeven(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = from;
        address to = fuzzedList.whitelistedToAddress;
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(caller != fuzzedList.whitelistedAddress);
        vm.assume(caller != fuzzedList.whitelistedToAddress);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_SEVEN,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerMustBeWhitelisted.selector
        );
    }

    function testRevertsAllTransfersAtLevelSevenWhenCallerIsNotWhitelistedAccount(
        FuzzedList memory fuzzedList,
        address collection,
        address caller,
        address from, 
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address to = fuzzedList.whitelistedToAddress;
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(caller != from);
        vm.assume(caller != fuzzedList.whitelistedAddress);
        vm.assume(caller != fuzzedList.whitelistedToAddress);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_SEVEN,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerMustBeWhitelisted.selector
        );
    }

    // Validation of Transfers Level 8

    function testAllowsAllTransfersAtLevelEightWhenCallerIsWhitelistedAccountAndReceiverIsVerifiedEOA(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        uint160 toKey,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address to = _verifyEOA(toKey);
        address caller = fuzzedList.whitelistedAddress;
        _sanitizeAccounts(collection, caller, from, to);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_EIGHT,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testAllowsTransfersAtLevelEightWhenReceiverIsNotAVerifiedEOAButAccountIsWhitelisted(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = fuzzedList.whitelistedAddress;
        address to = fuzzedList.whitelistedToAddress;
        _sanitizeAccounts(collection, caller, from, to);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_EIGHT,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testAllowsTransfersAtLevelEightWhenReceiverIsNotVerifiedEOAButCodeHashIsWhitelisted(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = fuzzedList.whitelistedAddress;
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(to != fuzzedList.whitelistedAddress);
        vm.assume(to != fuzzedList.whitelistedToAddress);

        _etchCodeToCaller(to, fuzzedList.whitelistedCode);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_EIGHT,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testRevertsTransfersAtLevelEightWhenReceiverHasNotVerifiedThatTheyAreAnEOA(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = fuzzedList.whitelistedAddress;
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(to != fuzzedList.whitelistedAddress);
        vm.assume(to != fuzzedList.whitelistedToAddress);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_EIGHT,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            CreatorTokenTransferValidator.CreatorTokenTransferValidator__ReceiverProofOfEOASignatureUnverified.selector
        );
    }

    function testAllowsAllTransfersAtLevelEightWhenCallerIsWhitelistedAccount(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = fuzzedList.whitelistedAddress;
        address to = fuzzedList.whitelistedToAddress;
        _sanitizeAccounts(collection, caller, from, to);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_EIGHT,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testAllowsAllTransfersAtLevelEightWhenCallerIsWhitelistedCodeHash(
        FuzzedList memory fuzzedList,
        address collection,
        address caller,
        address from, 
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address to = fuzzedList.whitelistedToAddress;
        _sanitizeAccounts(collection, caller, from, to);

        _etchCodeToCaller(caller, fuzzedList.whitelistedCode);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_EIGHT,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testRevertsOTCTransfersAtLevelEight(
        FuzzedList memory fuzzedList,
        address collection,
        address from, 
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address caller = from;
        address to = fuzzedList.whitelistedToAddress;
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(caller != fuzzedList.whitelistedAddress);
        vm.assume(caller != fuzzedList.whitelistedToAddress);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_EIGHT,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerMustBeWhitelisted.selector
        );
    }

    function testRevertsAllTransfersAtLevelEightWhenCallerIsNotWhitelistedAccount(
        FuzzedList memory fuzzedList,
        address collection,
        address caller,
        address from, 
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        address to = fuzzedList.whitelistedToAddress;
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(caller != fuzzedList.whitelistedAddress);
        vm.assume(caller != fuzzedList.whitelistedToAddress);

        _configureCollectionSecurity(
            collection, 
            fuzzedList,
            TRANSFER_SECURITY_LEVEL_EIGHT,
            enableAuthorizationMode,
            authorizersCanSetWildcardOperators,
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            CreatorTokenTransferValidator.CreatorTokenTransferValidator__CallerMustBeWhitelisted.selector
        );
    }

    // Validation of Transfers Level 9

    function testRevertsAllTransfersAtLevelNine(
        FuzzedList memory fuzzedList,
        address collection,
        address caller,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        _sanitizeAccounts(collection, caller, from, to);

        _configureCollectionSecurity(
            collection, 
            fuzzedList, 
            TRANSFER_SECURITY_LEVEL_NINE, 
            enableAuthorizationMode, 
            authorizersCanSetWildcardOperators, 
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount, 
            CreatorTokenTransferValidator.CreatorTokenTransferValidator__TokenIsSoulbound.selector
        );
    }

    // All Security Levels

    function testAllowsAllTransfersWhereCallerIsTransferValidator(
        FuzzedList memory fuzzedList,
        address collection,
        address caller,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        uint8 transferSecurityLevel,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) public {
        _sanitizeAccounts(collection, caller, from, to);

        transferSecurityLevel = uint8(bound(transferSecurityLevel, TRANSFER_SECURITY_LEVEL_RECOMMENDED, TRANSFER_SECURITY_LEVEL_NINE));

        _freezeAccount(collection, from);
        _freezeAccount(collection, to);

        _configureCollectionSecurity(
            collection, 
            fuzzedList, 
            transferSecurityLevel, 
            enableAuthorizationMode, 
            authorizersCanSetWildcardOperators, 
            enableAccountFreezingMode
        );

        _validateTransfersWithExpectedRevert(
            collection, 
            address(validator),
            caller,
            from, 
            to, 
            tokenId, 
            amount,
            SELECTOR_NO_ERROR
        );
    }

    function testRevertsTransfersFromFrozenAccountsAtAllSecurityLevels(
        FuzzedList memory fuzzedList,
        address collection,
        address caller,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        uint8 transferSecurityLevel,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators
    ) public {
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(from != to);

        transferSecurityLevel = uint8(bound(transferSecurityLevel, TRANSFER_SECURITY_LEVEL_RECOMMENDED, TRANSFER_SECURITY_LEVEL_EIGHT));

        _configureCollectionSecurity(
            collection, 
            fuzzedList, 
            transferSecurityLevel, 
            enableAuthorizationMode, 
            authorizersCanSetWildcardOperators, 
            true
        );

        _freezeAccount(collection, from);

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount, 
            CreatorTokenTransferValidator.CreatorTokenTransferValidator__SenderAccountIsFrozen.selector
        );
    }

    function testRevertsTransfersToFrozenAccountsAtAllSecurityLevels(
        FuzzedList memory fuzzedList,
        address collection,
        address caller,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        uint8 transferSecurityLevel,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators
    ) public {
        _sanitizeAccounts(collection, caller, from, to);
        vm.assume(from != to);

        transferSecurityLevel = uint8(bound(transferSecurityLevel, TRANSFER_SECURITY_LEVEL_RECOMMENDED, TRANSFER_SECURITY_LEVEL_EIGHT));

        _configureCollectionSecurity(
            collection, 
            fuzzedList, 
            transferSecurityLevel, 
            enableAuthorizationMode, 
            authorizersCanSetWildcardOperators, 
            true
        );

        _freezeAccount(collection, to);

        _validateTransfersWithExpectedRevert(
            collection, 
            caller, 
            caller,
            from, 
            to, 
            tokenId, 
            amount, 
            CreatorTokenTransferValidator.CreatorTokenTransferValidator__ReceiverAccountIsFrozen.selector
        );
    }

    function _pickAWhitelistingSecurityLevel(uint8 number) internal view returns (uint8) {
        number = uint8(bound(number, 0, 6));
        if (number == 0) {
            return TRANSFER_SECURITY_LEVEL_RECOMMENDED;
        } else if (number == 1) {
            return TRANSFER_SECURITY_LEVEL_THREE;
        } else if (number == 2) {
            return TRANSFER_SECURITY_LEVEL_FOUR;
        } else if (number == 3) {
            return TRANSFER_SECURITY_LEVEL_FIVE;
        } else if (number == 4) {
            return TRANSFER_SECURITY_LEVEL_SIX;
        } else if (number == 5) {
            return TRANSFER_SECURITY_LEVEL_SEVEN;
        } else if (number == 6) {
            return TRANSFER_SECURITY_LEVEL_EIGHT;
        }
    }

    function _verifyEOA(uint160 toKey) internal returns (address to) {
        toKey = uint160(bound(toKey, 1, type(uint160).max));
        to = vm.addr(toKey);
        (uint8 v, bytes32 r, bytes32 s) =
            vm.sign(toKey, ECDSA.toEthSignedMessageHash(bytes(validator.MESSAGE_TO_SIGN())));
        vm.prank(to);
        validator.verifySignatureVRS(v, r, s);
    }

    function _sanitizeAccounts(
        address collection,
        address caller,
        address from,
        address to
    ) internal {
        _sanitizeAddress(collection);
        _sanitizeAddress(caller);
        _sanitizeAddress(from);
        _sanitizeAddress(to);
    }

    function _freezeAccount(
        address collection,
        address account
    ) internal {
        address[] memory accountsToFreeze = new address[](1);
        accountsToFreeze[0] = account;

        vm.startPrank(collection);
        validator.freezeAccountsForCollection(collection, accountsToFreeze);
        vm.stopPrank();
    }

    function _etchCodeToCaller(
        address caller,
        bytes32 code
    ) internal {
        bytes memory bytecode = abi.encode(code);
        vm.etch(caller, bytecode);
    }

    function _configureCollectionSecurity(
        address collection,
        FuzzedList memory fuzzedList,
        uint8 transferSecurityLevel,
        bool enableAuthorizationMode,
        bool authorizersCanSetWildcardOperators,
        bool enableAccountFreezingMode
    ) internal {
        vm.assume(fuzzedList.whitelistedCode != fuzzedList.blacklistedCode);
        vm.assume(fuzzedList.whitelistedAddress != fuzzedList.blacklistedAddress);
        vm.assume(fuzzedList.whitelistedToAddress != fuzzedList.blacklistedAddress);
        vm.assume(fuzzedList.whitelistedAddress != fuzzedList.whitelistedToAddress);
        vm.assume(fuzzedList.authorizerAddress != fuzzedList.whitelistedAddress);
        vm.assume(fuzzedList.authorizerAddress != fuzzedList.whitelistedToAddress);
        vm.assume(fuzzedList.authorizerAddress != fuzzedList.blacklistedAddress);

        vm.startPrank(collection);

        uint120 listId = validator.createList("test");

        validator.addAccountToWhitelist(listId, fuzzedList.whitelistedAddress);
        validator.addAccountToWhitelist(listId, fuzzedList.whitelistedToAddress);
        validator.addAccountToBlacklist(listId, fuzzedList.blacklistedAddress);
        validator.addAccountToAuthorizers(listId, fuzzedList.authorizerAddress);

        bytes memory whitelistedCode = abi.encode(fuzzedList.whitelistedCode);
        bytes memory blacklistedCode = abi.encode(fuzzedList.blacklistedCode);

        bytes32[] memory codeHashes = new bytes32[](1);
        codeHashes[0] = keccak256(whitelistedCode);
        validator.addCodeHashesToWhitelist(listId, codeHashes);
        codeHashes[0] = keccak256(blacklistedCode);
        validator.addCodeHashesToBlacklist(listId, codeHashes);

        validator.setTransferSecurityLevelOfCollection(
            collection, 
            transferSecurityLevel, 
            enableAuthorizationMode, 
            authorizersCanSetWildcardOperators, 
            enableAccountFreezingMode);

        validator.applyListToCollection(collection, listId);

        vm.stopPrank();
    }

    function _validateTransfersWithExpectedRevert(
        address collection,
        address caller,
        address origin,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bytes4 expectedRevertSelector
    ) internal {
        vm.startPrank(collection, origin);

        if (expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
        validator.applyCollectionTransferPolicy(caller, from, to);

        if (expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
        validator.validateTransfer(caller, from, to);

        if (expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
        validator.validateTransfer(caller, from, to, tokenId);

        if (expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
        validator.validateTransfer(caller, from, to, tokenId, amount);

        vm.stopPrank();
    }

    /*
// These Are Really Creator Token Tests

    function testGetTransferValidatorReturnsTransferValidatorAddressBeforeValidatorIsSet(address creator) public {
        vm.assume(creator != address(0));

        _sanitizeAddress(creator);
        ITestCreatorToken token = _deployNewToken(creator);
        assertEq(address(token.getTransferValidator()), token.DEFAULT_TRANSFER_VALIDATOR());
    }

    function testRevertsWhenSetTransferValidatorCalledWithContractThatDoesNotImplementRequiredInterface(address creator)
        public
    {
        vm.assume(creator != address(0));

        _sanitizeAddress(creator);
        ITestCreatorToken token = _deployNewToken(creator);

        vm.startPrank(creator);
        address invalidContract = address(new ContractMock());
        vm.expectRevert(CreatorTokenBase.CreatorTokenBase__InvalidTransferValidatorContract.selector);
        token.setTransferValidator(invalidContract);
        vm.stopPrank();
    }

    function testAllowsAlternativeValidatorsToBeSetIfTheyImplementRequiredInterface(address creator) public {
        vm.assume(creator != address(0));

        _sanitizeAddress(creator);
        ITestCreatorToken token = _deployNewToken(creator);

        vm.startPrank(creator);
        address alternativeValidator = address(new CreatorTokenTransferValidator(creator));
        token.setTransferValidator(alternativeValidator);
        vm.stopPrank();

        assertEq(address(token.getTransferValidator()), alternativeValidator);
    }

    function testAllowsValidatorToBeSetBackToZeroAddress(address creator) public {
        vm.assume(creator != address(0));

        _sanitizeAddress(creator);
        ITestCreatorToken token = _deployNewToken(creator);

        vm.startPrank(creator);
        address alternativeValidator = address(new CreatorTokenTransferValidator(creator));
        token.setTransferValidator(alternativeValidator);
        token.setTransferValidator(address(0));
        vm.stopPrank();

        assertEq(address(token.getTransferValidator()), address(0));
    }

    function testGetSecurityPolicyReturnsRecommendedPolicyWhenNoValidatorIsSet(address creator) public {
        vm.assume(creator != address(0));
        _sanitizeAddress(creator);
        ITestCreatorToken token = _deployNewToken(creator);

        CollectionSecurityPolicy memory securityPolicy = validator.getCollectionSecurityPolicy(address(token));
        assertEq(uint8(securityPolicy.transferSecurityLevel), uint8(TransferSecurityLevels.Recommended));
        assertEq(uint256(securityPolicy.operatorWhitelistId), 0);
        assertEq(uint256(securityPolicy.permittedContractReceiversId), 0);

        CollectionSecurityPolicy memory securityPolicy = validator.getCollectionSecurityPolicy(address(token));
        assertEq(uint8(securityPolicy.transferSecurityLevel), uint8(TransferSecurityLevels.Recommended));
        assertEq(uint256(securityPolicy.listId), 0);
    }

    function testGetSecurityPolicyReturnsEmptyPolicyWhenValidatorIsSetToZeroAddress(address creator) public {
        vm.assume(creator != address(0));
        _sanitizeAddress(creator);
        ITestCreatorToken token = _deployNewToken(creator);

        vm.prank(creator);
        token.setTransferValidator(address(0));

        CollectionSecurityPolicy memory securityPolicy = validator.getCollectionSecurityPolicy(address(token));
        assertEq(uint8(securityPolicy.transferSecurityLevel), uint8(TransferSecurityLevels.Recommended));
        assertEq(uint256(securityPolicy.operatorWhitelistId), 0);
        assertEq(uint256(securityPolicy.permittedContractReceiversId), 0);

        CollectionSecurityPolicy memory securityPolicy = validator.getCollectionSecurityPolicy(address(token));
        assertEq(uint8(securityPolicy.transferSecurityLevel), uint8(TransferSecurityLevels.Recommended));
        assertEq(uint256(securityPolicy.listId), 0);
    }

    function testGetSecurityPolicyReturnsExpectedSecurityPolicy(address creator, uint8 levelUint8) public {
        vm.assume(creator != address(0));
        vm.assume(levelUint8 >= 0 && levelUint8 <= 8);

        TransferSecurityLevels level = TransferSecurityLevels(levelUint8);

        _sanitizeAddress(creator);
        ITestCreatorToken token = _deployNewToken(creator);

        vm.startPrank(creator);
        uint120 listId = validator.createList("");
        token.setTransferValidator(address(validator));
        validator.setTransferSecurityLevelOfCollection(address(token), level);
        validator.applyListToCollection(address(token), listId);
        vm.stopPrank();

        CollectionSecurityPolicy memory securityPolicy = validator.getCollectionSecurityPolicy(address(token));
        assertTrue(securityPolicy.transferSecurityLevel == level);
        assertEq(uint256(securityPolicy.operatorWhitelistId), listId);
        assertEq(uint256(securityPolicy.permittedContractReceiversId), listId);

        CollectionSecurityPolicy memory securityPolicy = validator.getCollectionSecurityPolicy(address(token));
        assertTrue(securityPolicy.transferSecurityLevel == level);
        assertEq(uint256(securityPolicy.listId), listId);
    }

    function testSetCustomSecurityPolicy(address creator, uint8 levelUint8) public {
        vm.assume(creator != address(0));
        vm.assume(levelUint8 >= 0 && levelUint8 <= 8);

        TransferSecurityLevels level = TransferSecurityLevels(levelUint8);

        _sanitizeAddress(creator);
        ITestCreatorToken token = _deployNewToken(creator);

        vm.startPrank(creator);
        uint120 operatorWhitelistId = validator.createOperatorWhitelist("");
        token.setToCustomValidatorAndSecurityPolicy(address(validator), level, operatorWhitelistId);
        vm.stopPrank();

        assertEq(address(token.getTransferValidator()), address(validator));

        CollectionSecurityPolicy memory securityPolicy = validator.getCollectionSecurityPolicy(address(token));
        assertTrue(securityPolicy.transferSecurityLevel == level);
        assertEq(uint256(securityPolicy.operatorWhitelistId), operatorWhitelistId);
        assertEq(uint256(securityPolicy.permittedContractReceiversId), operatorWhitelistId);

        CollectionSecurityPolicy memory securityPolicy = validator.getCollectionSecurityPolicy(address(token));
        assertTrue(securityPolicy.transferSecurityLevel == level);
        assertEq(uint256(securityPolicy.listId), operatorWhitelistId);
    }

    function testSetTransferSecurityLevelOfCollection(address creator, uint8 levelUint8) public {
        vm.assume(creator != address(0));
        vm.assume(levelUint8 >= 0 && levelUint8 <= 6);

        TransferSecurityLevels level = TransferSecurityLevels(levelUint8);

        _sanitizeAddress(creator);
        ITestCreatorToken token = _deployNewToken(creator);

        vm.startPrank(creator);
        vm.expectEmit(true, false, false, true);
        emit SetTransferSecurityLevel(address(token), level);
        validator.setTransferSecurityLevelOfCollection(address(token), level);
        vm.stopPrank();

        CollectionSecurityPolicy memory securityPolicy = validator.getCollectionSecurityPolicy(address(token));
        assertTrue(securityPolicy.transferSecurityLevel == level);
    }

    function testSetOperatorWhitelistOfCollection(address creator) public {
        vm.assume(creator != address(0));

        _sanitizeAddress(creator);
        ITestCreatorToken token = _deployNewToken(creator);
        vm.startPrank(creator);

        uint120 listId = validator.createOperatorWhitelist("test");

        vm.expectEmit(true, true, true, false);
        emit AppliedListToCollection(address(token), listId);

        validator.setOperatorWhitelistOfCollection(address(token), listId);
        vm.stopPrank();

        CollectionSecurityPolicy memory securityPolicy = validator.getCollectionSecurityPolicy(address(token));
        assertTrue(securityPolicy.operatorWhitelistId == listId);
    }

    function testRevertsWhenSettingOperatorWhitelistOfCollectionToInvalidListId(address creator, uint120 listId)
        public
    {
        vm.assume(creator != address(0));
        vm.assume(listId > 1);

        _sanitizeAddress(creator);
        ITestCreatorToken token = _deployNewToken(creator);
        vm.prank(creator);
        vm.expectRevert(CreatorTokenTransferValidator.CreatorTokenTransferValidator__ListDoesNotExist.selector);
        validator.setOperatorWhitelistOfCollection(address(token), listId);
    }

    function testRevertsWhenUnauthorizedUserSetsOperatorWhitelistOfCollection(address creator, address unauthorizedUser)
        public
    {
        vm.assume(creator != address(0));
        vm.assume(unauthorizedUser != address(0));
        vm.assume(creator != unauthorizedUser);

        _sanitizeAddress(creator);
        ITestCreatorToken token = _deployNewToken(creator);

        vm.assume(unauthorizedUser != address(token));

        vm.startPrank(unauthorizedUser);
        uint120 listId = validator.createOperatorWhitelist("naughty list");

        vm.expectRevert(
            CreatorTokenTransferValidator
                .CreatorTokenTransferValidator__CallerMustHaveElevatedPermissionsForSpecifiedNFT
                .selector
        );
        validator.setOperatorWhitelistOfCollection(address(token), listId);
        vm.stopPrank();
    }

    function testIsApprovedForAllDefaultsToFalseForTransferValidator(address creator, address owner) public {
        _sanitizeAddress(creator);
        _sanitizeAddress(owner);
        vm.assume(creator != owner);

        ITestCreatorToken token = _deployNewToken(creator);
        vm.prank(creator);
        token.setTransferValidator(address(validator));

        assertFalse(token.isApprovedForAll(owner, address(validator)));
    }

    function testIsApprovedForAllReturnsTrueForTransferValidatorIfAutoApproveEnabledByCreator(address creator, address owner) public {
        _sanitizeAddress(creator);
        _sanitizeAddress(owner);
        vm.assume(creator != owner);

        ITestCreatorToken token = _deployNewToken(creator);
        vm.startPrank(creator);
        token.setTransferValidator(address(validator));
        token.setAutomaticApprovalOfTransfersFromValidator(true);
        vm.stopPrank();

        assertTrue(token.isApprovedForAll(owner, address(validator)));
    }

    function testIsApprovedForAllReturnsTrueForDefaultTransferValidatorIfAutoApproveEnabledByCreatorAndValidatorUninitialized(address creator, address owner) public {
        _sanitizeAddress(creator);
        _sanitizeAddress(owner);
        vm.assume(creator != owner);

        ITestCreatorToken token = _deployNewToken(creator);
        vm.startPrank(creator);
        token.setAutomaticApprovalOfTransfersFromValidator(true);
        vm.stopPrank();

        assertTrue(token.isApprovedForAll(owner, token.DEFAULT_TRANSFER_VALIDATOR()));
    }

    function testIsApprovedForAllReturnsTrueWhenUserExplicitlyApprovesTransferValidator(address creator, address owner) public {
        _sanitizeAddress(creator);
        _sanitizeAddress(owner);
        vm.assume(creator != owner);

        ITestCreatorToken token = _deployNewToken(creator);
        vm.prank(creator);
        token.setTransferValidator(address(validator));

        vm.prank(owner);
        token.setApprovalForAll(address(validator), true);

        assertTrue(token.isApprovedForAll(owner, address(validator)));
    }
    */
}
