import Foundation

/// What the app needs from the network, as a protocol — so a test can supply
/// its own answers without a URLProtocol stub or a live server.
protocol APIClient: Sendable {
    func get<T: Decodable>(_ path: String, as type: T.Type) async throws -> T
}

enum APIError: Error, Equatable {
    case badStatus(Int)
    case invalidURL(String)
}

/// The real client. It knows about transport and nothing about the app.
struct HTTPAPIClient: APIClient {
    let baseURL: URL
    var session: URLSession = .shared
    var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    func get<T: Decodable>(_ path: String, as type: T.Type) async throws -> T {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            throw APIError.invalidURL(path)
        }
        let (data, response) = try await session.data(from: url)
        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            throw APIError.badStatus(http.statusCode)
        }
        return try decoder.decode(T.self, from: data)
    }
}
