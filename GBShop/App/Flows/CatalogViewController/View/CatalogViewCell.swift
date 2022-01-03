//
//  CatalogViewCell.swift
//  GBShop
//
//  Created by Владимир on 25.12.2021.
//

import UIKit

final class CatalogViewCell: UICollectionViewCell {
    static let reuseIdentifier = "CatalogViewCell"
    
    private(set) var title: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemYellow.withAlphaComponent(0.4)
        label.textColor = .black
        label.textAlignment = .center
        label.font = DesignConstants.shared.mediumFont
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    private(set) var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private(set) var priceLabel: UILabel = {
        let label = UILabel()
        label.font = DesignConstants.shared.mediumFont
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .systemPurple.withAlphaComponent(0.1)
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    private(set) var buyButon: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setBackgroundImage(UIImage(systemName: "plus.app.fill"), for: .normal)
        button.tintColor = .systemGreen
        button.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeLayoutByFrame()
    }
    
    override func prepareForReuse() {
        title.text = nil
        priceLabel.text = nil
        imageView.image = nil
        super.prepareForReuse()
    }
    
    // MARK: - Configure Content
    //
    private func configureContent() {
        self.backgroundColor = .white
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 2
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = false
        
        self.contentView.addSubview(title)
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(priceLabel)
        self.contentView.addSubview(buyButon)
        
        self.setNeedsLayout()
    }
    
    private func makeLayoutByFrame() {
        let bounds = self.contentView.bounds
        
        let padding = DesignConstants.shared.padding
        let imagePadding = DesignConstants.shared.imagePadding
        let font = DesignConstants.shared.mediumFont
        
        let widthButton: CGFloat = 43
        let heightButton: CGFloat = 40
        
        title.frame = CGRect(x: padding.left,
                             y: padding.top,
                             width: bounds.width - padding.left - padding.right,
                             height: ceil(font.lineHeight))
        
        imageView.frame = CGRect(x: imagePadding.left,
                                 y: title.frame.maxY + imagePadding.top,
                                 width: bounds.width - imagePadding.left - imagePadding.right,
                                 height: bounds.width - imagePadding.left - imagePadding.right)
        
        buyButon.frame = CGRect(x: bounds.maxX - padding.right - widthButton,
                                y: bounds.maxY - padding.bottom - heightButton,
                                width: widthButton,
                                height: heightButton)
        
        priceLabel.frame = CGRect(x: padding.left,
                                  y: buyButon.frame.minY,
                                  width: bounds.width - padding.left - padding.right - buyButon.frame.width,
                                  height: heightButton)
    }
}
