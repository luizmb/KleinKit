import Foundation

extension URLRequest {
    init(url urlString: String,
         httpMethod: String,
         urlParams: [String: String] = [:],
         headers: [String: String] = [:]) {

        let urlSuffix = urlParams.count == 0 ? "" : "?" + urlParams.map { k, v in "\(k)=\(v)" }.joined(separator: "&")
        let url = URL(string: "\(urlString)\(urlSuffix)")!

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        headers.forEach { k, v in request.setValue(v, forHTTPHeaderField: k) }
        self = request
    }
}
