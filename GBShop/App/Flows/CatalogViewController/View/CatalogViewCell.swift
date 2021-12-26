//
//  CatalogViewCell.swift
//  GBShop
//
//  Created by Владимир on 25.12.2021.
//

import UIKit

final class CatalogViewCell: UICollectionViewCell {
    static let reuseIdentifier = "CatalogViewCell"
    
    private let padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    private var titleSize: CGSize = .zero
    
    private(set) var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NewYork-Regular", size: 17)
        label.textColor = .black
        label.backgroundColor = .systemYellow.withAlphaComponent(0.4)
        label.textAlignment = .center
        label.text = nil
        return label
    }()
    
    private(set) var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NewYork-Regular", size: 17)
        label.textColor = .black
        label.textAlignment = .center
        label.text = nil
        return label
    }()
    
    private(set) var buyButon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setBackgroundImage(UIImage(systemName: "plus.app.fill"), for: .normal)
        button.tintColor = .systemGreen
        button.contentMode = .scaleAspectFill
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        title.text = nil
        priceLabel.text = nil
    }
    
    // MARK: - Configure Content
    //
    private func configureContent() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 2
        
        self.contentView.addSubview(title)
        self.contentView.addSubview(priceLabel)
        self.contentView.addSubview(buyButon)
        placesConstraint()
    }
    
    private func placesConstraint() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: padding.top),
            title.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: padding.left),
            title.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -padding.right),
            title.heightAnchor.constraint(equalToConstant: 25),
            
            priceLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -padding.bottom),
            priceLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: padding.left),
            priceLabel.trailingAnchor.constraint(equalTo: buyButon.leadingAnchor, constant: -padding.right),
            priceLabel.heightAnchor.constraint(equalToConstant: 41),
            
            buyButon.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -padding.bottom),
            buyButon.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -padding.bottom),
            buyButon.widthAnchor.constraint(equalToConstant: 44),
            buyButon.heightAnchor.constraint(equalToConstant: 41)
        ])
    }
}
