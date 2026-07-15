import UIKit

protocol AppCoordinatorProtocol: AnyObject {
    func start()
    func showDetail(for product: Product)
}

final class AppCoordinator: AppCoordinatorProtocol {
    private let serviceLocator: AppServiceLocating
    private let navigationController: UINavigationController

    init(
        navigationController: UINavigationController,
        serviceLocator: AppServiceLocating
    ) {
        self.navigationController = navigationController
        self.serviceLocator = serviceLocator
    }

    func start() {
        let mainViewController = serviceLocator.makeMainViewController(coordinator: self)
        navigationController.setViewControllers([mainViewController], animated: false)
    }

    func showDetail(for product: Product) {
        let detailViewController = serviceLocator.makeDetailViewController(product: product)
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
