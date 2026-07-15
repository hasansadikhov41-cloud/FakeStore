import Foundation

enum StoreError : LocalizedError {
    case invalidResponse
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "The server returned unreadable product data."
        case .invalidResponse:
            return "The server returned an invalid response."
        }
    }
}

protocol ProductServiceProtocol {
    func fetchProducts() async throws -> [Product]
}

final class APIService: ProductServiceProtocol {
    private let session: URLSession
    private let endpoint: URL

    init(
        session: URLSession = .shared,
        endpoint: URL = URL(string: "https://dummyjson.com/products")!
    ) {
        self.session = session
        self.endpoint = endpoint
    }

    func fetchProducts() async throws -> [Product] {
        let (data, response) = try await session.data(from: endpoint)

        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode) else {
            throw StoreError.invalidResponse
        }

        do {
            let jsonData = try JSONDecoder().decode(Store.self, from: data)
            return jsonData.products
        } catch {
            throw StoreError.invalidData
        }
    }
}
