// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {VRGDAUpgradeable} from "./base/VRGDAUpgradeable.sol";
import {VRGDA as LibVRGDA} from "./libs/VRGDA.sol";

/// @title Linear Variable Rate Gradual Dutch Auction
/// @author transmissions11 <t11s@paradigm.xyz>
/// @author FrankieIsLost <frankie@paradigm.xyz>
/// @notice VRGDA with a linear issuance curve.
abstract contract LinearVRGDAUpgradeable is VRGDAUpgradeable {
    /*//////////////////////////////////////////////////////////////
                           PRICING PARAMETERS
    //////////////////////////////////////////////////////////////*/

    /// @dev The total number of tokens to target selling every full unit of time.
    /// @dev Represented as an 18 decimal fixed point number.
    int256 internal perTimeUnit;

    /// @notice Sets pricing parameters for the VRGDA.
    /// @param _targetPrice The target price for a token if sold on pace, scaled by 1e18.
    /// @param _priceDecayPercent The percent price decays per unit of time with no sales, scaled by 1e18.
    /// @param _perTimeUnit The number of tokens to target selling in 1 full unit of time, scaled by 1e18.
    function __LinearVRGDA_init(
        int256 _targetPrice,
        int256 _priceDecayPercent,
        int256 _perTimeUnit
    ) internal onlyInitializing {
        __LinearVRGDA_init_unchained(_targetPrice, _priceDecayPercent, _perTimeUnit);
    }

    function __LinearVRGDA_init_unchained(
        int256 _targetPrice,
        int256 _priceDecayPercent,
        int256 _perTimeUnit
    ) internal onlyInitializing {
        __VRGDA_init(_targetPrice, _priceDecayPercent);
        perTimeUnit = _perTimeUnit;
    }

    /*//////////////////////////////////////////////////////////////
                              PRICING LOGIC
    //////////////////////////////////////////////////////////////*/

    /// @dev Given a number of tokens sold, return the target time that number of tokens should be sold by.
    /// @param sold A number of tokens sold, scaled by 1e18, to get the corresponding target sale time for.
    /// @return The target time the tokens should be sold by, scaled by 1e18, where the time is
    /// relative, such that 0 means the tokens should be sold immediately when the VRGDA begins.
    function getTargetSaleTime(int256 sold) public view virtual override returns (int256) {
        return LibVRGDA.getTargetSaleTimeLinear(sold, perTimeUnit);
    }
}
