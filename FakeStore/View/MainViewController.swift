import Foundation
import UIKit
import Combine

class MainViewController : UIViewController {
    
    let mainViewModel : MainViewModel
    var cancellables = Set<AnyCancellable>()
    private weak var coordinator: AppCoordinatorProtocol?
    
    init(mainViewModel: MainViewModel, coordinator: AppCoordinatorProtocol) {
        self.mainViewModel = mainViewModel
        self.coordinator = coordinator
        super.init(nibName: nil , bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let collectionView : UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cView.backgroundColor = .clear
        cView.alwaysBounceVertical = true
        cView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 24, right: 0)
        cView.scrollIndicatorInsets = UIEdgeInsets(top: 12, left: 0, bottom: 24, right: 0)
        cView.translatesAutoresizingMaskIntoConstraints = false
        return cView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Discover"
        view.backgroundColor = UIColor.systemGroupedBackground
        configureNavigationBar()
        
        binding()
        setupViews()
        Task {
            await mainViewModel.fetchProducts()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let spacing: CGFloat = 16
            let padding: CGFloat = 20
            let columns: CGFloat = traitCollection.horizontalSizeClass == .regular ? 3 : 2
            
            let availableWidth = collectionView.bounds.width - (padding * 2) - (spacing * (columns - 1))
            let itemWidth = floor(availableWidth / columns)
            let itemHeight = itemWidth * 1.42
            
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.minimumInteritemSpacing = spacing
            layout.minimumLineSpacing = spacing
            layout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        }
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.backButtonDisplayMode = .minimal

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemGroupedBackground
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    private func setupViews() {
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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

extension MainViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return mainViewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
        let selectedProduct = mainViewModel.productList[indexPath.row]
        cell.configure(product: selectedProduct)
        cell.onShipButtonTapped = { [weak self] in
            self?.coordinator?.showDetail(for: selectedProduct)
        }
        return cell
    }
    
}
