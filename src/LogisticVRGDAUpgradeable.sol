// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {VRGDAUpgradeable} from "./base/VRGDAUpgradeable.sol";
import {VRGDA as LibVRGDA} from "./libs/VRGDA.sol";

/// @title Logistic Variable Rate Gradual Dutch Auction
/// @author transmissions11 <t11s@paradigm.xyz>
/// @author FrankieIsLost <frankie@paradigm.xyz>
/// @notice VRGDA with a logistic issuance curve.
contract LogisticVRGDAUpgradeable is VRGDAUpgradeable {
    /*//////////////////////////////////////////////////////////////
                           PRICING PARAMETERS
    //////////////////////////////////////////////////////////////*/

    /// @dev The maximum number of tokens of tokens to sell + 1. We add
    /// 1 because the logistic function will never fully reach its limit.
    /// @dev Represented as an 18 decimal fixed point number.
    int256 internal logisticLimit;

    /// @dev The maximum number of tokens of tokens to sell + 1 multiplied
    /// by 2. We could compute it on the fly each time but this saves gas.
    /// @dev Represented as a 36 decimal fixed point number.
    int256 internal logisticLimitDoubled;

    /// @dev Time scale controls the steepness of the logistic curve,
    /// which affects how quickly we will reach the curve's asymptote.
    /// @dev Represented as an 18 decimal fixed point number.
    int256 internal timeScale;

    /// @notice Sets pricing parameters for the VRGDA.
    /// @param _targetPrice The target price for a token if sold on pace, scaled by 1e18.
    /// @param _priceDecayPercent The percent price decays per unit of time with no sales, scaled by 1e18.
    /// @param _maxSellable The maximum number of tokens to sell, scaled by 1e18.
    /// @param _timeScale The steepness of the logistic curve, scaled by 1e18.
    function __LogisticVRGDA_init(
        int256 _targetPrice,
        int256 _priceDecayPercent,
        int256 _maxSellable,
        int256 _timeScale
    ) internal onlyInitializing {
        __LogisticVRGDA_init_unchained(_targetPrice, _priceDecayPercent, _maxSellable, _timeScale);
    }

    function __LogisticVRGDA_init_unchained(
        int256 _targetPrice,
        int256 _priceDecayPercent,
        int256 _maxSellable,
        int256 _timeScale
    ) internal onlyInitializing {
        __VRGDA_init(_targetPrice, _priceDecayPercent);
        // Add 1 wad to make the limit inclusive of _maxSellable.
        logisticLimit = _maxSellable + 1e18;

        // Scale by 2e18 to both double it and give it 36 decimals.
        logisticLimitDoubled = logisticLimit * 2e18;

        timeScale = _timeScale;
    }

    /*//////////////////////////////////////////////////////////////
                              PRICING LOGIC
    //////////////////////////////////////////////////////////////*/

    /// @dev Given a number of tokens sold, return the target time that number of tokens should be sold by.
    /// @param sold A number of tokens sold, scaled by 1e18, to get the corresponding target sale time for.
    /// @return The target time the tokens should be sold by, scaled by 1e18, where the time is
    /// relative, such that 0 means the tokens should be sold immediately when the VRGDA begins.
    function getTargetSaleTime(int256 sold) public view virtual override returns (int256) {
        return LibVRGDA.getTargetSaleTimeLogistic(sold, logisticLimit, timeScale);
    }
}
