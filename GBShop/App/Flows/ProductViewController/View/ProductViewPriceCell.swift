//
//  ProductViewPriceCell.swift
//  GBShop
//
//  Created by Владимир on 30.12.2021.
//

import UIKit

final class ProductViewPriceCell: UITableViewCell {
    static let reuseIdentifier = "ProductViewPriceCell"
    
    private(set) var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = DesignConstants.shared.mediumFont
        return label
    }()
    
    private(set) var buyButon: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitle("Купить", for: .normal)
        button.tintColor = .black
        button.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 5
        return button
    }()
    
    // MARK: - Initiation
    //
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(buyButon)
//        self.contentView.addSubview(priceLabel)
        self.contentView.backgroundColor = .white
        
        self.setNeedsLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.contentView.bounds
        let padding = DesignConstants.shared.padding
        var buttonSize = DesignConstants.shared.buttonSize
        buttonSize.width = 100
        
//        buyButon.frame = CGRect(x: bounds.width - padding.right - buttonSize.width,
//                                y: bounds.height - padding.bottom - buttonSize.height,
//                                width: buttonSize.width,
//                                height: buttonSize.height)
        
//        priceLabel.frame = CGRect(x: padding.left,
//                                  y: buyButon.frame.origin.y,
//                                  width: bounds.width - buyButon.frame.width - padding.left - padding.right - padding.right,
//                                  height: buyButon.frame.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        priceLabel.text = nil
    }
}
