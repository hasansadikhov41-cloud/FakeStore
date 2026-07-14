import Foundation

enum StoreError : LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Error about invalid URL"
        case .invalidData:
            return "Error about invalid Data"
        case .invalidResponse:
            return "Error about invalid Response"
        }
    }
}

protocol ProductServiceProtocol : AnyObject {
    
    func fetchData() async throws -> [Product]
    
}

class APIService : ProductServiceProtocol {
    
    func fetchData() async throws -> [Product] {
        
        guard let url = URL(string: "https://dummyjson.com/products") else { throw StoreError.invalidURL }
        
        let (data , response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse , (200...299).contains(response.statusCode) else { throw StoreError.invalidResponse}
        do {
            let jsonData = try JSONDecoder().decode(Store.self , from: data)
            return jsonData.products
        }catch{
            throw StoreError.invalidData
        }
    }
    
}
