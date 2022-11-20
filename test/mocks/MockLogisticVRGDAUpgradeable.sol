// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {LogisticVRGDAUpgradeable} from "../../src/LogisticVRGDAUpgradeable.sol";

contract MockLogisticVRGDAUpgradeable is LogisticVRGDAUpgradeable {
    function initialize(
        int256 _targetPrice,
        int256 _priceDecayPercent,
        int256 _maxSellable,
        int256 _timeScale
    ) external initializer {
        __LogisticVRGDA_init(_targetPrice, _priceDecayPercent, _maxSellable, _timeScale);
    }
}
