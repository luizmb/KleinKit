import Foundation

public protocol URLEndpoint {
    func urlRequest(with baseUrl: String) -> URLRequest
}
