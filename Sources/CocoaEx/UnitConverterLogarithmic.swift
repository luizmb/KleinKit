import Foundation

class UnitConverterLogarithmic: UnitConverter, NSCopying {
    let coefficient: Double
    let logBase: Double

    init(coefficient: Double, logBase: Double) {
        self.coefficient = coefficient
        self.logBase = logBase
    }

    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }

    override func baseUnitValue(fromValue value: Double) -> Double {
        return coefficient * log(value) / log(logBase)
    }

    override func value(fromBaseUnitValue baseUnitValue: Double) -> Double {
        return exp(baseUnitValue * log(logBase) / coefficient)
    }
}

// https://chengwey.com/ios-10-by-tutorials-bi-ji-shi/
// float dBToVolume(float dB) {
//     return powf(10.0f, 0.05f * dB)
// }
//
// float VolumeTodB(float volume) {
//     return 20.0f * log10f(volume)
// }﻿
