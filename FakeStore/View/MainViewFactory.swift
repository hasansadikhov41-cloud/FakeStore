import Foundation

final class MainViewFactory {
    private let viewModel: MainViewModel
    private let coordinator: AppCoordinatorProtocol

    init(viewModel: MainViewModel, coordinator: AppCoordinatorProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
    }

    func makeMainViewController() -> MainViewController {
        MainViewController(mainViewModel: viewModel, coordinator: coordinator)
    }
}
