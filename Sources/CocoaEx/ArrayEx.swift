//
//  ArrayEx.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import UIKit

extension Array {
    public subscript (safe index: Int) -> Element? {
        return index < count && index >= 0 ? self[index] : nil
    }
}

extension Array {
    static func containSameElements<T: Comparable>(_ array1: [T], _ array2: [T]) -> Bool {
        guard array1.count == array2.count else {
            return false
        }

        return array1.sorted() == array2.sorted()
    }
}

extension Array where Element: Hashable {
    func intersection<S>(_ other: S) -> [Element] where Element == S.Element, S: Sequence {
        let setSelf: Set<Element> = Set(self)
        return Array(setSelf.intersection(other))
    }

    func distinct() -> [Element] {
        return Array(Set(self))
    }
}
