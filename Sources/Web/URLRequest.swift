import Foundation

extension URLRequest {
    init(url urlString: String,
         httpMethod: String,
         urlParams: [String: String] = [:],
         headers: [String: String] = [:]) {

        let urlSuffix = urlParams.isEmpty ? "" : "?" +
            urlParams.map {
                [$0, $1].joined(separator: "=")
            }.joined(separator: "&")
        let url = URL(string: "\(urlString)\(urlSuffix)")!

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        headers.forEach { key, value in request.setValue(value, forHTTPHeaderField: key) }
        self = request
    }
}
