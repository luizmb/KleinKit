import Foundation

extension Dictionary where Key == String, Value == Any {
    public struct FlattenStrategy {
        public enum KeyComposer {
            case ignoreParents
            case joined(separator: String)
            case custom(([String], String) -> String)

            public func compose(parents: [String], key: String) -> String {
                switch self {
                case .ignoreParents: return key
                case .joined(let separator): return (parents + [key]).joined(separator: separator)
                case .custom(let composer): return composer(parents, key)
                }
            }
        }

        public enum ValueComposer {
            case left
            case right
            case array
            case reversedArray
            case custom((Any, Any) -> Any)

            public func compose(left: Any, right: Any) -> Any {
                switch self {
                case .left: return left
                case .right: return right
                case .array: return [left, right]
                case .reversedArray: return [right, left]
                case .custom(let composer): return composer(left, right)
                }
            }
        }

        public enum ArrayKeyComposer {
            case brackets
            case surroundedBy(left: String, right: String)
            case custom(([String], String, Int) -> [String])

            public func compose(parents: [String], key: String, index: Int) -> [String] {
                switch self {
                case .brackets: return parents + ["\(key)[\(index)]"]
                case let .surroundedBy(left, right): return parents + ["\(key)\(left)\(index)\(right)"]
                case let .custom(composer): return composer(parents, key, index)
                }
            }
        }

        public let key: KeyComposer
        public let value: ValueComposer
        public let arrayKey: ArrayKeyComposer?

        public init(key: KeyComposer, value: ValueComposer, arrayKey: ArrayKeyComposer? = nil) {
            self.key = key
            self.value = value
            self.arrayKey = arrayKey
        }

        public static let `default`: FlattenStrategy = .init(key: .joined(separator: "."),
                                                             value: .array,
                                                             arrayKey: .brackets)
    }

    private func flatten(parents: [String], strategy: FlattenStrategy) -> [String: Any] {
        return self.reduce([:], { previous, keyValuePair in
            var flatDictionaryResult = previous
            let (key, value) = keyValuePair
            switch (value, strategy.arrayKey) {
            case let (child as [String: Any], _):
                flatDictionaryResult.merge(child.flatten(parents: parents + [key],
                                                         strategy: strategy),
                                           uniquingKeysWith: strategy.value.compose)
            case let (array as [[String: Any]], arrayKeyStrategy?):
                array.enumerated().forEach { index, child in
                    let arrayKey = arrayKeyStrategy.compose(parents: parents, key: key, index: index)
                    flatDictionaryResult.merge(child.flatten(parents: arrayKey,
                                                             strategy: strategy),
                                               uniquingKeysWith: strategy.value.compose)
                }
            default:
                flatDictionaryResult[strategy.key.compose(parents: parents, key: key)] = value
            }
            return flatDictionaryResult
        })
    }

    public func flatten(strategy: FlattenStrategy = .default) -> [String: Any] {
        return flatten(parents: [], strategy: strategy)
    }
}
