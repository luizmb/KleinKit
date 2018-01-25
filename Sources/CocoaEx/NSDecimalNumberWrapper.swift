import Foundation

public struct NSDecimalNumberWrapper: Decodable {
    public let decimalNumber: NSDecimalNumber

    public init(from decoder: Decoder) {
        guard let container = try? decoder.singleValueContainer() else {
            self.decimalNumber = .notANumber
            return
        }

        if let double = try? container.decode(Double.self) {
            self.decimalNumber = NSDecimalNumber(value: double)
            return
        }

        if let string = try? container.decode(String.self) {
            self.decimalNumber = NSDecimalNumber(string: string)
            return
        }

        self.decimalNumber = .notANumber
    }
}
