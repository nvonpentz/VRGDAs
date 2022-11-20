// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {ERC721Upgradeable} from "openzeppelin-contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";

import {toDaysWadUnsafe} from "solmate/utils/SignedWadMath.sol";

import {LinearVRGDAUpgradeable} from "../LinearVRGDAUpgradeable.sol";

/// @title Linear VRGDA NFT
/// @author transmissions11 <t11s@paradigm.xyz>
/// @author FrankieIsLost <frankie@paradigm.xyz>
/// @notice Example NFT sold using LinearVRGDAUpgradeable.
/// @dev This is an example. Do not use in production.
contract LinearNFTUpgradeable is ERC721Upgradeable, LinearVRGDAUpgradeable {
    /*//////////////////////////////////////////////////////////////
                              SALES STORAGE
    //////////////////////////////////////////////////////////////*/

    uint256 public totalSold; // The total number of tokens sold so far.

    uint256 public startTime = block.timestamp; // When VRGDA sales begun.

    /*//////////////////////////////////////////////////////////////
                               INITIALIZER
    //////////////////////////////////////////////////////////////*/
    function initialize() external initializer {
        __ERC721_init("Example Upgradeable Linear NFT", "LINEAR");
        __LinearVRGDA_init(
            69.42e18, // Target price.
            0.31e18, // Price decay percent.
            2e18 // Per time unit.
        );
    }

    /*//////////////////////////////////////////////////////////////
                              MINTING LOGIC
    //////////////////////////////////////////////////////////////*/

    function mint() external payable returns (uint256 mintedId) {
        unchecked {
            // Note: By using toDaysWadUnsafe(block.timestamp - startTime) we are establishing that 1 "unit of time" is 1 day.
            uint256 price = getVRGDAPrice(toDaysWadUnsafe(block.timestamp - startTime), mintedId = totalSold++);

            require(msg.value >= price, "UNDERPAID"); // Don't allow underpaying.

            _mint(msg.sender, mintedId); // Mint the NFT using mintedId.

            // Note: We do this at the end to avoid creating a reentrancy vector.
            // Refund the user any ETH they spent over the current price of the NFT.
            // Unchecked is safe here because we validate msg.value >= price above.
            SafeTransferLib.safeTransferETH(msg.sender, msg.value - price);
        }
    }

    /*//////////////////////////////////////////////////////////////
                                URI LOGIC
    //////////////////////////////////////////////////////////////*/

    function tokenURI(uint256) public pure override returns (string memory) {
        return "https://example.com";
    }
}
