// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "./mocks/ClonerMock.sol";
import "./mocks/ContractMock.sol";
import "./mocks/ERC721CMock.sol";
import "./mocks/ERC1155CMock.sol";
import "./interfaces/ITestCreatorToken.sol";
import "src/utils/TransferPolicy.sol";
import "src/utils/CreatorTokenTransferValidator.sol";
import "src/Constants.sol";
import "./utils/Events.sol";
import "./utils/Helpers.sol";
import "src/utils/EOARegistry.sol";
import "./TransferValidator.t.sol";
import "lib/PermitC/src/Constants.sol";

contract PermitTransferValidatorTest is TransferValidatorTest {
    
    struct PermitSignatureDetails {
        // Collection Address
        address token;
        // Token ID
        uint256 id;
        // An random value that can be used to invalidate the permit
        uint256 nonce;
        // Address permitted to transfer the tokens
        address operator;
        // Amount of tokens - For ERC721 this is always 1
        uint200 amount;
        // Expiration time of the permit
        uint48 expiration;
    }

    ERC721CMock erc721C;
    mapping(address => uint256) internal _accountPermitNonces;

    function setUp() public virtual override {
        super.setUp();

        erc721C = new ERC721CMock();
    }

    function _getAndIncrementAccountPermitNonce(address addr) internal returns(uint256 nextNonce) {
        nextNonce = _accountPermitNonces[addr]++;
    }

    function _mint721(address to, uint256 tokenId) internal virtual {
        erc721C.mint(to, tokenId);
    }

    function _sanitizeAccounts(
        address collection,
        address caller,
        address from,
        address to
    ) internal override returns (address sanitizedCollection, address sanitizedFrom, uint256 sanitizedFromKey) {
        (collection, from, sanitizedFromKey) = super._sanitizeAccounts(collection, caller, from, to);
        sanitizedCollection = address(erc721C);
        sanitizedFromKey = uint256(uint160(from));
        sanitizedFrom = vm.addr(sanitizedFromKey);
    }

    function _beforeAuthorizedTransferCallsWithExpectedRevert(
        address authorizer,
        address origin,
        address operator,
        address collection,
        uint256 tokenId,
        uint256 amount,
        bytes4 expectedRevertSelector
    ) internal override {
        amount = 1;

        vm.startPrank(authorizer, origin);

        if (expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
        validator.beforeAuthorizedTransfer(operator, collection, tokenId);

        if (expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
        validator.beforeAuthorizedTransfer(operator, collection);

        if (expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
        validator.beforeAuthorizedTransfer(collection, tokenId);

        if (expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
        validator.beforeAuthorizedTransferWithAmount(collection, tokenId, amount);

        vm.stopPrank();
    }

    function _validateTransfersWithExpectedRevert(
        address collection,
        address caller,
        address origin,
        uint256 fromKey,
        address from, 
        address to,
        uint256 tokenId,
        uint256 amount,
        bytes4 expectedRevertSelector
    ) internal override {
        amount = 1;
        _mint721(from, tokenId);
        erc721C.setTransferValidator(address(validator));

        vm.prank(from);
        erc721C.setApprovalForAll(address(validator), true);

        (PermitSignatureDetails memory permit, bytes memory signedPermit) = _getPermitAndSignature(fromKey, from, origin, tokenId);

        vm.startPrank(caller, origin);

        bool isError = validator.permitTransferFromERC721(permit.token, permit.id, permit.nonce, permit.expiration, from, to, signedPermit);
        assertEq(isError, expectedRevertSelector != 0x00000000);
        vm.stopPrank();

        if (expectedRevertSelector == bytes4(0x00000000)) {
            assertEq(erc721C.ownerOf(tokenId), to);
        } else {
            assertEq(erc721C.ownerOf(tokenId), from);
        }
    }

    function _getPermitAndSignature(
        uint256 fromKey, address from, address operator, uint256 tokenId
    ) internal returns (PermitSignatureDetails memory permit, bytes memory signedPermit) {
        permit = PermitSignatureDetails({
            token: address(erc721C),
            id: tokenId,
            amount: 1,
            nonce: _getAndIncrementAccountPermitNonce(from),
            operator: operator,
            expiration: uint48(block.timestamp + 1000)
        });

        uint256 masterNonce = validator.masterNonce(from);

        bytes32 permitDigest = ECDSA.toTypedDataHash(
            validator.domainSeparatorV4(),
            keccak256(
                abi.encode(
                    SINGLE_USE_PERMIT_TYPEHASH,
                    permit.token,
                    permit.id,
                    permit.amount,
                    permit.nonce,
                    permit.operator,
                    permit.expiration,
                    masterNonce
                )
            )
        );

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(fromKey, permitDigest);
        signedPermit = abi.encodePacked(r, s, v);
    }

}
