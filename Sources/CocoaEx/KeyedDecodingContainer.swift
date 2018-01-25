import Foundation

extension KeyedDecodingContainer {
    public enum RawValueKeys: CodingKey {
        case value
    }

    func decode<ContainerKey, Value>(_ type: Value.Type, forKey key: Key, at containerKey: ContainerKey) throws -> Value where Value: Decodable, ContainerKey: CodingKey {
        let rawValueContainer = try nestedContainer(keyedBy: ContainerKey.self, forKey: key)
        return try rawValueContainer.decode(type, forKey: containerKey)
    }

    func decodeValueContainer<Value>(_ type: Value.Type, forKey key: Key) throws -> Value where Value: Decodable {
        return try decode(type, forKey: key, at: RawValueKeys.value)
    }
}
