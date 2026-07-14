import Foundation
import UIKit
import SDWebImage

class ProductCell : UICollectionViewCell {
    
    var buttonTapped : (() -> Void)?
    
    private let productImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.secondarySystemGroupedBackground
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let productTitle : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .label
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let shipButton : UIButton = {
        var configuration = UIButton.Configuration.tinted()
        configuration.cornerStyle = .medium
        configuration.image = UIImage(systemName: "cart.badge.plus")
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10)
        configuration.baseForegroundColor = .systemBlue
        let button = UIButton(configuration: configuration)
        button.accessibilityLabel = "Add to cart"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    static let identifier = "ProductCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 18
        contentView.layer.cornerCurve = .continuous
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.masksToBounds = false
        
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

    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.image = nil
        productTitle.text = nil
        priceLabel.text = nil
    }
    private func setupViews(){
        contentView.addSubview(productImage)
        contentView.addSubview(productTitle)
        contentView.addSubview(priceLabel)
        contentView.addSubview(shipButton)
    }
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.62),
            
            productTitle.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 12),
            productTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            productTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            shipButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            shipButton.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            shipButton.leadingAnchor.constraint(greaterThanOrEqualTo: priceLabel.trailingAnchor, constant: 8),
        ])
    }
    
    func configure(product : Product) {
        let url = URL(string: product.thumbnail)
        productImage.sd_setImage(with: url)
        
        productTitle.text = product.title
        priceLabel.text = String(format: "$%.2f", product.price)
        accessibilityLabel = "\(product.title), \(priceLabel.text ?? "k")"
    }
}
