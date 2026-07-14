import Foundation
import UIKit

protocol CoordinatorProtocol : AnyObject {
    var navigationController : UINavigationController {get set}
    
    func start()
}

class APPCoordinator : CoordinatorProtocol {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let service = APIService()
        let viewModel = MainViewModel(service: service)
        let viewController = MainViewController(mainViewModel: viewModel)
        
        navigationController.setViewControllers([viewController], animated: false)
    }
}
