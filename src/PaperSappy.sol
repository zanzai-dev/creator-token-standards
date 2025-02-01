//====================================================================================================
//====================================================================================================
//             ············································································
//             :      ____                         ____                                   :
//             :     |  _ \ __ _ _ __   ___ _ __  / ___|  __ _ _ __  _ __  _   _ ___      :
//             :     | |_) / _` | '_ \ / _ | '__| \___ \ / _` | '_ \| '_ \| | | / __|     :
//             :     |  __| (_| | |_) |  __| |     ___) | (_| | |_) | |_) | |_| \__ \     :
//             :     |_|   \__,_| .__/ \___|_|    |____/ \__,_| .__/| .__/ \__, |___/     :
//             :                |_|                           |_|   |_|    |___/          :
//             ············································································
//====================================================================================================
//====================================================================================================
//====================================================================================================
//=====================================================--=============================================
//===============================================-:.:+%@@%=.:=========================================
//=========================================-::-+#@@@@%*==#%@@#=:-=====================================
//==================================-::-=*%@@@@#+-:..     ..-*@@@#=::=================================
//============================-:.:=#@@@@@#+:...           .   ..-#@@@%=.:=============================
//=========================:-#@@@@@%+:.                      . .   .=%@@@*:-==========================
//=======================-:%@#=-...     .    .                        .:+@@--=========================
//======================:=@@=.                                          .+@#:=========================
//=====================:*@@:          .                                 . %@=-=======:-===============
//====================:#@#. . .                                           :@@:=====:*@@--=============
//==================:-@@=.  .    .                                  .:--...+@#:-=:-%@@@--=============
//=================:*@@:.   .                   .. .       .      .*@@@@@%:.=@@%=-@@@#:-=---==========
//================.#@#.           .                               +@@@@@@@@.  :#@@@#::.:*@@#:=========
//==============--@@+. .                  ..                      +@@@@@@@%.    .+@@%*@@@@%=:=========
//=============:+@@-.     .             .                         .+@@@@@#:       .-#@@%-:-===========
//============.#@#.                         ..-+=:  .  .           ...:...       .  ..#@=-============
//==========-:@@+.               .         .*@@@@@@+.      ..=#%*.                    -@#:============
//=========-+@@=.     . .                 .=@@@@@@@@-     .%@@@@@:.:##.               .%@:============
//=========:*@*        .  .        .      .-@@@@@@@%:     .-*%@@%==%@=.               .*@+:===========
//=========-=@@:                            -@@@@@%:    .:=:.-@@%@@%:.               ..=@%.===========
//==========:#@*.                           . ...       .#%%@@%-                     . :%@--==========
//==========--@%:                                                                      .*@*:==========
//===========.*@+.                .+#%%%%%:       .                        .            =@%:==========
//===========-:@%.          .   .#@@@@@@+.       .                                     .-@@=-=========
//============:*@+  .            :**+-...:=+:                        .                .+@@=:==========
//=============-@@.                  .-#@@@=.                         .              .#@#:============
//=============:*@* . .             .#@@@+.                   .    ..    .          -@@+:=============
//=============--@@:      .      .  .=#=.   .     .        .                      .+@@--==============
//==============:#@*.   .             .  .                   . . .  .            :%@*:================
//==============-:@%:                  ..                          .           .=@@+:=================
//===============.*@+..     .                              .                  .*@@:-==================
//================:@@=:.  .            . .                              ...:=*@@*:====================
//================--*@@@*-.                                       ..-=*#@@@@%#+--=====================
//===================-:=%@@%+.                      .       .:=#%@@@@@#=-::-==========================
//======================-.:#@@@*:..               .....-*%@@@@@%*-..:-================================
//==========================::+%@@#=:.       ..:-+#@@@@%#*=-::-=======================================
//=============================-:-*@@%*--=*#%@@@%#+--:--==============================================
//=================================-:=@@@@%+-.:--=====================================================
//====================================-::-============================================================
//====================================================================================================
//====================================================================================================

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
contract PaperSappy is OwnableBasic, ERC721C, BasicRoyalties, AirdropMint, IContractMetadata {

    uint256 internal _nextTokenId = 1;

    // Base URI
    string internal _metadataURI = "";

    /// @notice Returns the contract metadata URI.
    string public override contractURI;

    constructor()
        ERC721OpenZeppelin("ZZTest3", "ZT3")
        BasicRoyalties(0x1e90E7404c8cA3333D86bC81D586449a99a5791A, 100)
        AirdropMint(5)
        MaxSupply(10, 10)
    {
        setTransferValidator(0x3203c3f64312AF9344e42EF8Aa45B97C9DFE4594);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721C, ERC2981) returns (bool) {
        return
            ERC721C.supportsInterface(interfaceId) ||
            ERC2981.supportsInterface(interfaceId);
    }

    function burn(uint256 tokenId) external {
        _burn(tokenId);
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return _metadataURI;
    }

    function setBaseURI(string memory _baseUri) external {
        _requireCallerIsContractOwner();
        _setBaseURI(_baseUri);
    }

    function _setBaseURI(string memory _baseUri) internal virtual {
        _metadataURI = _baseUri;
    }

    function setContractURI(string memory _uri) external override {
        _requireCallerIsContractOwner();
        _setupContractURI(_uri);
    }

    /// @dev Lets a contract admin set the URI for contract-level metadata.
    function _setupContractURI(string memory _uri) internal {
        string memory prevURI = contractURI;
        contractURI = _uri;

        emit ContractURIUpdated(prevURI, _uri);
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
}
