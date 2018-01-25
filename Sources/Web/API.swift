import Foundation

public protocol API {
    func request(_ endpoint: URLEndpoint, completion: @escaping (Result<Data>) -> ()) -> CancelableTask
}
