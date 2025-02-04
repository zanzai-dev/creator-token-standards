// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./access/OwnableBasic.sol";
import "./erc721c/ERC721C.sol";
import "./interfaces/IContractMetadata.sol";
import "./minting/AirdropMint.sol";
import "./programmable-royalties/BasicRoyalties.sol";

/**
 * @title PaperSappy
 * @author ZanZai.
 * @notice Extension of ERC721C that adds basic royalties support.
 * @dev Pixl is going to 16$60.
 */
contract ZZTest is
    OwnableBasic,
    ERC721C,
    BasicRoyalties,
    AirdropMint,
    IContractMetadata
{
    // The number of tokens burned.
    uint256 private _burnCounter;

    // Base URI
    string internal _metadataURI = "";

    /// @notice Returns the contract metadata URI.
    string internal _contractURI;

    struct AirdropRequest {
        address recipient;
        uint256 amount;
    }

    constructor()
        ERC721OpenZeppelin("ZZ Test 4", "ZZT4")
        BasicRoyalties(0xe50440Db65E9D3580cc20Acac6BBC25A6656fBb8, 1000)
        AirdropMint(5000)
        MaxSupply(5000, 5000)
    {
        setTransferValidator(0x3203c3f64312AF9344e42EF8Aa45B97C9DFE4594);
    }

    function arf(uint8 _arfing) external pure returns (string memory) {
        if (_arfing > 10) {
            return "Big Arf Energy!!!!";
        }
        string memory arfs = "";
        for (uint256 i = 0; i < _arfing; ++i) {
            arfs = string.concat(arfs, "Arf! ");
        }

        return arfs;
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721C, ERC2981) returns (bool) {
        return
            ERC721C.supportsInterface(interfaceId) ||
            ERC2981.supportsInterface(interfaceId);
    }

    function contractURI() external view override returns (string memory) {
        return _contractURI;
    }

    function setContractURI(string memory _uri) external override {
        _requireCallerIsContractOwner();
        _setupContractURI(_uri);
    }

    function setBaseURI(string memory _baseUri) external {
        _requireCallerIsContractOwner();
        _setBaseURI(_baseUri);
    }

    function setDefaultRoyalty(address receiver, uint96 feeNumerator) public {
        _requireCallerIsContractOwner();
        _setDefaultRoyalty(receiver, feeNumerator);
    }

    function setTokenRoyalty(
        uint256 tokenId,
        address receiver,
        uint96 feeNumerator
    ) public {
        _requireCallerIsContractOwner();
        _setTokenRoyalty(tokenId, receiver, feeNumerator);
    }

    function burn(uint256 tokenId) external {
        _burn(tokenId);
        // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
        unchecked {
            _burnCounter++;
        }
    }

    /**
     * @dev Returns the total number of tokens in existence.
     * Burned tokens will reduce the count.
     */
    function totalSupply() external view returns (uint256) {
        unchecked {
            return mintedSupply() - _burnCounter;
        }
    }

    function _mintToken(address to, uint256 tokenId) internal virtual override {
        _safeMint(to, tokenId);
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return _metadataURI;
    }

    function _setBaseURI(string memory _baseUri) internal virtual {
        _metadataURI = _baseUri;
    }

    /// @dev Lets a contract admin set the URI for contract-level metadata.
    function _setupContractURI(string memory _uri) internal {
        string memory prevURI = _contractURI;
        _contractURI = _uri;

        emit ContractURIUpdated(prevURI, _uri);
    }
}
