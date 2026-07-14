import Foundation
import UIKit
import Combine

class MainViewController : UIViewController {
    
    let mainViewModel : MainViewModel
    var cancellables = Set<AnyCancellable>()
    
    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
        super.init(nibName: nil , bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let collectionView : UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cView.backgroundColor = .white
        cView.translatesAutoresizingMaskIntoConstraints = false
        return cView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        binding()
        setupViews()
        Task {
            await mainViewModel.fetchProducts()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let spacing : CGFloat = 4
            let padding : CGFloat = 4
            
            let awaibleWidth = view.frame.width - (padding * 2) - spacing
            let itemWidth = awaibleWidth / 2
            let itemHeight = itemWidth * 1.4
            
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.minimumInteritemSpacing = spacing
            layout.minimumLineSpacing = spacing
            layout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        }
    }
    
    private func setupViews() {
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func binding(){
        mainViewModel.$productList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }.store(in: &cancellables)
    }
    
    
}

extension MainViewController : UICollectionViewDelegate {
    
}

extension MainViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return mainViewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
        let selectedProduct = mainViewModel.productList[indexPath.row]
        cell.configure(product: selectedProduct)
        return cell
    }
    
}
