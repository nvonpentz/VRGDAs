// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {LogisticVRGDA} from "../../src/LogisticVRGDA.sol";

contract MockLogisticVRGDA {
    int256 internal immutable priceDecayPercent;
    int256 internal immutable timeScale;

    int256 public immutable targetPrice;
    int256 public immutable maxSellable;

    constructor(
        int256 _targetPrice,
        int256 _priceDecayPercent,
        int256 _maxSellable,
        int256 _timeScale
    ) {
        targetPrice = _targetPrice;
        priceDecayPercent = _priceDecayPercent;
        maxSellable = _maxSellable;
        timeScale = _timeScale;
    }

    function getTargetSaleTime(int256 sold) public view returns (int256) {
        return LogisticVRGDA.getTargetSaleTime(sold, maxSellable, timeScale);
    }

    function getVRGDAPrice(int256 timeSinceStart, uint256 sold) public view returns (uint256) {
        return
            LogisticVRGDA.getVRGDAPrice(
                timeSinceStart,
                targetPrice,
                priceDecayPercent,
                maxSellable,
                timeScale,
                sold
            );
    }
}
