import Foundation

public enum FileError: Error {
    case notFound
}

public class DiskCache: RepositoryProtocol {
    public init() { }

    public func save(data: Data, filename: String) {
        guard let path = documentsFolder?.appendingPathComponent(filename) else { return }
        FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
    }

    public func load(filename: String) -> Result<Data> {
        guard let path = documentsFolder?.appendingPathComponent(filename),
            let data = FileManager.default.contents(atPath: path) else {
                return .failure(FileError.notFound)
        }

        return .success(data)
    }

    private var documentsFolder: String? {
        let file = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appendingPathComponent("CacheFolder")
        do {
            try FileManager.default.createDirectory(atPath: file, withIntermediateDirectories: true, attributes: nil)
            return file
        } catch {
            return nil
        }
    }
}
