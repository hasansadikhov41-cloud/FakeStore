import UIKit

protocol AppCoordinatorProtocol: AnyObject {
    func start()
}

protocol MainRouting: AnyObject {
    func showDetail(for product: Product)
}

final class AppCoordinator: AppCoordinatorProtocol, MainRouting {
    private let mainViewFactory: MainViewFactory
    private let detailViewFactory: DetailViewFactory
    private let navigationController: UINavigationController

    init(
        navigationController: UINavigationController,
        mainViewFactory: MainViewFactory,
        detailViewFactory: DetailViewFactory
    ) {
        self.navigationController = navigationController
        self.mainViewFactory = mainViewFactory
        self.detailViewFactory = detailViewFactory
    }

    func start() {
        let mainViewController = mainViewFactory.makeMainViewController(coordinator: self)
        navigationController.setViewControllers([mainViewController], animated: false)
    }

    func showDetail(for product: Product) {
        let detailViewController = detailViewFactory.make(product: product)
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
