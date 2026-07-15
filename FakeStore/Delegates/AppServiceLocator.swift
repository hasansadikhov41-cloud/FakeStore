import Swinject

protocol ServiceLocator: AnyObject {
    func resolve<Service>(_ serviceType: Service.Type) -> Service
}

/// Registers the application's object graph. Resolve dependencies only in composition layers,
/// such as factories; never from view controllers or view models.
final class AppServiceLocator: ServiceLocator {
    private let container: Container

    init(container: Container = Container()) {
        self.container = container
        registerDependencies()
    }

    func resolve<Service>(_ serviceType: Service.Type) -> Service {
        guard let service = container.resolve(serviceType) else {
            preconditionFailure("\(serviceType) has not been registered.")
        }
        return service
    }

    private func registerDependencies() {
        container.register(ProductServiceProtocol.self) { _ in
            APIService()
        }
        .inObjectScope(.container)

        container.register(MainViewModel.self) { resolver in
            guard let productService = resolver.resolve(ProductServiceProtocol.self) else {
                preconditionFailure("ProductServiceProtocol has not been registered.")
            }
            return MainViewModel(productService: productService)
        }
    }
}
