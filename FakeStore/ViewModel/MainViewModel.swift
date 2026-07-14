import Foundation
import UIKit
import Combine

class MainViewModel : ObservableObject {
    
    @Published var productList : [Product] = []
    
    let service : ProductServiceProtocol
    
    init(service: ProductServiceProtocol) {
        self.service = service
    }
    
    func fetchProducts() async {
        do {
            let products = try await service.fetchData()
            self.productList = products
        }catch{
            print(error.localizedDescription)
        }
    }
    
    var numberOfItems : Int {
        productList.count
    }
    
}
