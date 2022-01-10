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
        label.textAlignment = .left
        label.textColor = .systemGray
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
        
        priceLabel.frame = CGRect(x: image.frame.maxX + padding.left,
                                  y: titleLabel.frame.maxY + DesignConstants.shared.padding.top,
                                  width: bounds.width - image.frame.width - padding.left - padding.left - padding.right,
                                  height: DesignConstants.shared.mediumFont.getFontHeight())
    }
    
    override func prepareForReuse() {
        image.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        super.prepareForReuse()
    }
}
