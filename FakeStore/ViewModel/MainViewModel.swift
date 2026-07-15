import Foundation
import Combine

@MainActor
final class MainViewModel: ObservableObject {
    enum LoadState: Equatable {
        case idle
        case loading
        case loaded
        case failed(message: String)
    }

    @Published private(set) var products: [Product] = []
    @Published private(set) var state: LoadState = .idle

    private let productService: ProductServiceProtocol

    init(productService: ProductServiceProtocol) {
        self.productService = productService
    }

    func loadProducts() async {
        guard state != .loading else { return }

        state = .loading
        do {
            products = try await productService.fetchProducts()
            state = .loaded
        } catch {
            state = .failed(message: error.localizedDescription)
        }
    }
}
