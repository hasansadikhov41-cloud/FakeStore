import Foundation

final class MainViewFactory {
    private let serviceLocator: ServiceLocator

    init(serviceLocator: ServiceLocator) {
        self.serviceLocator = serviceLocator
    }

    func makeMainViewController(coordinator: MainRouting) -> MainViewController {
        MainViewController(
            mainViewModel: serviceLocator.resolve(MainViewModel.self),
            coordinator: coordinator
        )
    }
}
