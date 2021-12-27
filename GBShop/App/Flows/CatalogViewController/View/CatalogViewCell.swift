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
        return label
    }()
    
    private(set) var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private(set) var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
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
        
        makeFramesLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
        priceLabel.text = nil
        imageView.image = nil
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
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(priceLabel)
        self.contentView.addSubview(buyButon)
        
        self.setNeedsLayout()
    }
    
    private func makeFramesLayout() {
        let font = UIFont(name: "NewYork-Regular", size: 17) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize)
        setFont(font: font)
        
        let padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let imagePadding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let bounds = self.contentView.bounds
        
        let widthButton: CGFloat = 44
        let heightButton: CGFloat = 41
        
        title.frame = CGRect(x: padding.left,
                             y: padding.top,
                             width: bounds.width - padding.left - padding.right,
                             height: font.lineHeight)
        buyButon.frame = CGRect(x: bounds.maxX - padding.right - widthButton,
                                y: bounds.maxY - padding.bottom - heightButton,
                                width: widthButton,
                                height: heightButton)
        priceLabel.frame = CGRect(x: padding.left,
                                  y: buyButon.frame.minY,
                                  width: bounds.width - padding.left - padding.right - buyButon.frame.width,
                                  height: heightButton)
        imageView.frame = CGRect(x: imagePadding.left,
                                 y: title.frame.maxY + imagePadding.top,
                                 width: bounds.width - imagePadding.left - imagePadding.right,
                                 height: buyButon.frame.minY - title.frame.minY - imagePadding.top - imagePadding.bottom)
    }
    
    private func setFont(font: UIFont) {
        title.font = font
        priceLabel.font = font
    }
}
