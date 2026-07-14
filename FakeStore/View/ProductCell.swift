import Foundation
import UIKit
import SDWebImage

class ProductCell : UICollectionViewCell {
    
    var buttonTapped : (() -> Void)?
    
    private let productImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let productTitle : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 10, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let shipButton : UIButton = {
        var configuration = UIButton.Configuration.glass()
        configuration.cornerStyle = .capsule
        
        configuration.image = UIImage(systemName: "cart.badge.plus")
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 18)
        configuration.baseForegroundColor = .darkGray
        let button = UIButton(configuration: configuration)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    static let identifier = "ProductCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 245/255, alpha: 1)
        
        shipButton.addTarget(self, action: #selector(buttonTapp), for: .touchUpInside)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func buttonTapp(){
        buttonTapped?()
    }
    private func setupViews(){
        contentView.addSubview(productImage)
        contentView.addSubview(productTitle)
        contentView.addSubview(priceLabel)
        contentView.addSubview(shipButton)
    }
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            productImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            productImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            productImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            
            productTitle.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 4),
            productTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            productTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            
            priceLabel.topAnchor.constraint(equalTo: productTitle.bottomAnchor, constant: 2),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            shipButton.topAnchor.constraint(equalTo: productTitle.bottomAnchor, constant: 1),
            shipButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor , constant: -1),
            shipButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),
        ])
    }
    
    func configure(product : Product) {
        let url = URL(string: product.thumbnail)
        productImage.sd_setImage(with: url)
        
        let price = String(product.price)
    
        productTitle.text = product.title
        priceLabel.text = price
    }
}
