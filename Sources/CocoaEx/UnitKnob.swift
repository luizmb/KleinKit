import Foundation

public class UnitKnob: Dimension {
    public static let fraction = UnitKnob(symbol: "", converter: UnitConverterLinear(coefficient: 1.0, constant: 0.0))
    public static let decibels = UnitKnob(symbol: "dB", converter: UnitConverterLinear(coefficient: 1.0 / 24.0, constant: 1.0))
    public static let decibelsMinus12Plus12 = UnitKnob(symbol: "dB", converter: UnitConverterLinear(coefficient: 1.0 / 24.0, constant: 0.5))
    public static let percent = UnitKnob(symbol: "%", converter: UnitConverterLinear(coefficient: 0.01, constant: 0.0))
    public static let zeroToTen = UnitKnob(symbol: "", converter: UnitConverterLinear(coefficient: 0.1, constant: 0.0))
    public static let int32Scale = UnitKnob(symbol: "", converter: UnitConverterLinear(coefficient: 1.0 / (2.0 * Double(Int32.max) + 2.0),
                                                                                    constant: 0.5))
    public static let midi = UnitKnob(symbol: "", converter: UnitConverterLinear(coefficient: 1.0 / 127.0, constant: 0.0))

    //    static let amplitudeRatio = UnitKnob(symbol: "", converter: UnitConverterLogarithmic(coefficient: 20, logBase: 10))
    //    static let powerRatio     = UnitKnob(symbol: "", converter: UnitConverterLogarithmic(coefficient: 10, logBase: 10))
    //    static let decibels       = UnitKnob(symbol: "dB", converter: UnitConverterLinear(coefficient: 1.0))

    override public static func baseUnit() -> UnitKnob {
        return self.fraction
    }
}

extension Int32 {
    public var knobInt32: Measurement<UnitKnob> {
        return Measurement<UnitKnob>(value: Double(self), unit: .int32Scale)
    }
}

extension Double {
    public var knobMidi: Measurement<UnitKnob> {
        return Measurement<UnitKnob>(value: self, unit: .midi)
    }

    public var knobPercent: Measurement<UnitKnob> {
        return Measurement<UnitKnob>(value: self, unit: .percent)
    }

    public var knobDecibels: Measurement<UnitKnob> {
        return Measurement<UnitKnob>(value: self, unit: .decibels)
    }

    public var knobFraction: Measurement<UnitKnob> {
        return Measurement<UnitKnob>(value: self, unit: .fraction)
    }
}
