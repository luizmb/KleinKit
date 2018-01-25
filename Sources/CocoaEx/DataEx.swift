//
//  DataEx.swift
//  KleinKit
//
//  Created by Luiz Rodrigo Martins Barbosa on 25.01.18.
//

import Foundation

extension Data {

    func range(_ start: Int, _ length: Int) -> Data {
        return self.subdata(in: start..<start+length)
    }

    func readValue<T>() -> T {
        return self.withUnsafeBytes { $0.pointee }
    }

    func readInt32() -> Int32 {
        return self.readValue()
    }

    func readUInt32() -> UInt32 {
        return self.readValue()
    }

    func readInt16() -> Int16 {
        return self.readValue()
    }

    func readUInt16() -> UInt16 {
        return self.readValue()
    }

    func readString() -> String {
        return String(data: self, encoding: .utf8) ?? ""
    }

    func readMirroredString() -> String {
        return String(readString().reversed())
    }

    func readPercentage() -> Float {
        let signedIntScale = readInt32()
        let percentage = 0.5 + Float(signedIntScale) / Float(UInt32.max)
        return percentage
    }

    func readVarint() -> Int32 {
        return self.range(0, 4).readVarint()
    }
}

extension Sequence where Element == UInt8 {
    func hex(withPrefix: Bool = true) -> [String] {
        return self.map { "\(withPrefix ? "0x" : "")\(String($0, radix: 16, uppercase: true).leftPadding(toLength: 2, withPad: "0"))" }
    }
}

extension Sequence where Element == UInt8 {
    func readVarint() -> Int32? {
        var position = 0
        var shift = 25
        var bitPattern: UInt32 = 0x0

        for byte in self {
            bitPattern = bitPattern | (UInt32(byte & 0x7F) << shift)

            if position == 3 {
                bitPattern = bitPattern | (UInt32(byte & 0x78) >> 3)
                break
            }

            position += 1
            shift -= 7
        }

        guard position == 3 else { return nil }
        return Int32(bitPattern: bitPattern)
    }
}
