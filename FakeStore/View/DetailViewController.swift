import Foundation
import UIKit
import SDWebImage

class DetailViewController : UIViewController {
    
    let product : Product
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil , bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageView : UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        
        setupConstraints()
        setupImage()
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
    private func setupImage(){
        guard let imageURL = product.images.first.flatMap(URL.init(string:)) else { return }
        imageView.sd_setImage(with: imageURL)
    }
}
