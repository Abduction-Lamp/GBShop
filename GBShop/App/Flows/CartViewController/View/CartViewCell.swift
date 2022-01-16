//
//  CartViewCell.swift
//  GBShop
//
//  Created by Владимир on 08.01.2022.
//

import UIKit

final class CartViewCell: UITableViewCell {
    static let reuseIdentifier = "CartViewCell"
    
    private(set) var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private(set) var titleLabel: UILabel = {
        let label = UILabel()
        label.font = DesignConstants.shared.largeFont
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    private(set) var priceLabel: UILabel = {
        let label = UILabel()
        label.font = DesignConstants.shared.mediumFont
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .systemGreen.withAlphaComponent(0.2)
        label.layer.cornerRadius = DesignConstants.shared.mediumFont.getFontHeight()/2
        label.layer.masksToBounds = true
        return label
    }()
    
    private(set) var multiplierLabel: UILabel = {
        let label = UILabel()
        label.font = DesignConstants.shared.mediumFont
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .systemYellow.withAlphaComponent(0.2)
        label.layer.cornerRadius = DesignConstants.shared.mediumFont.getFontHeight()/2
        label.layer.masksToBounds = true
        return label
    }()
    
    private(set) var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setBackgroundImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .systemRed
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    // MARK: - Initiation
    //
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(image)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(priceLabel)
        self.contentView.addSubview(multiplierLabel)
        
        self.contentView.backgroundColor = .white
        
        self.contentView.setNeedsLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding = DesignConstants.shared.imagePadding
        let bounds = self.contentView.bounds
        
        image.frame = CGRect(x: padding.left,
                             y: padding.top,
                             width: bounds.height - padding.top - padding.bottom,
                             height: bounds.height - padding.top - padding.bottom)
        
        titleLabel.frame = CGRect(x: image.frame.maxX + padding.left,
                                  y: padding.top,
                                  width: bounds.width - image.frame.width - padding.left - padding.left - padding.right,
                                  height: DesignConstants.shared.largeFont.getFontHeight())
        
        let widthPriceLabel = priceLabel.intrinsicContentSize.width + 16
        priceLabel.frame = CGRect(x: image.frame.maxX + padding.left,
                                  y: titleLabel.frame.maxY + DesignConstants.shared.padding.top,
                                  width: widthPriceLabel,
                                  height: DesignConstants.shared.mediumFont.getFontHeight())
        
        let widthMultiplierLabel = multiplierLabel.intrinsicContentSize.width + 16
        multiplierLabel.frame = CGRect(x: priceLabel.frame.maxX,
                                       y: titleLabel.frame.maxY + DesignConstants.shared.padding.top,
                                       width: widthMultiplierLabel,
                                       height: DesignConstants.shared.mediumFont.getFontHeight())
    }
    
    override func prepareForReuse() {
        image.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        super.prepareForReuse()
    }
}
