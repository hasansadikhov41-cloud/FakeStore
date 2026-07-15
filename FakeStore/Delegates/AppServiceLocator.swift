import Swinject

protocol AppServiceLocating {
    func makeMainViewController(coordinator: AppCoordinatorProtocol) -> MainViewController
    func makeDetailViewController(product: Product) -> DetailViewController
}

final class AppServiceLocator: AppServiceLocating {
    private let container: Container

    init(container: Container = Container()) {
        self.container = container
        registerDependencies()
    }

    private func registerDependencies() {
        container.register(ProductServiceProtocol.self) { _ in
            APIService()
        }.inObjectScope(.container)

        container.register(MainViewModel.self) { resolver in
            guard let service = resolver.resolve(ProductServiceProtocol.self) else {
                preconditionFailure("ProductServiceProtocol is not registered.")
            }
            return MainViewModel(service: service)
        }
    }

    func makeMainViewController(coordinator: AppCoordinatorProtocol) -> MainViewController {
        guard let viewModel = container.resolve(MainViewModel.self) else {
            preconditionFailure("MainViewModel is not registered.")
        }

        return MainViewFactory(viewModel: viewModel, coordinator: coordinator).makeMainViewController()
    }

    func makeDetailViewController(product: Product) -> DetailViewController {
        DetailViewFactory().make(product: product)
    }
}
