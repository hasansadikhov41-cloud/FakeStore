import Foundation

final class DetailViewFactory {
    func make(product: Product) -> DetailViewController {
        DetailViewController(product: product)
    }
}
