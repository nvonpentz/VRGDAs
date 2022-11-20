// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {LinearVRGDAUpgradeable} from "../../src/LinearVRGDAUpgradeable.sol";

contract MockLinearVRGDAUpgradeable is LinearVRGDAUpgradeable {
    function initialize(int256 _targetPrice, int256 _priceDecayPercent, int256 _perTimeUnit) external initializer {
        __LinearVRGDA_init(_targetPrice, _priceDecayPercent, _perTimeUnit);
    }
}
