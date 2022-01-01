//
//  ProductViewPriceCell.swift
//  GBShop
//
//  Created by Владимир on 30.12.2021.
//

import UIKit

final class ProductViewPriceCell: UITableViewCell {
    static let reuseIdentifier = "ProductViewPriceCell"
    
    private(set) var priceButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitleColor(.systemGray6, for: .highlighted)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = DesignConstants.shared.largeFont
        button.layer.cornerRadius = 5
        return button
    }()
    
    // MARK: - Initiation
    //
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(priceButton)
        self.contentView.backgroundColor = .white
        
        self.setNeedsLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.contentView.bounds
        let padding = DesignConstants.shared.imagePadding
        
        priceButton.frame = CGRect(x: padding.left,
                                   y: padding.top,
                                   width: bounds.width - padding.left - padding.right,
                                   height: bounds.height - padding.top - padding.bottom)
    }
    
    override func prepareForReuse() {
        priceButton.setTitle("", for: .normal)
        super.prepareForReuse()
    }
}
