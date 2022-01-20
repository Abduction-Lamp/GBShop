//
//  ProductViewTitleCell.swift
//  GBShop
//
//  Created by Владимир on 29.12.2021.
//

import UIKit

final class ProductViewTitleCell: UITableViewCell {
    static let reuseIdentifier = "ProductViewTitleCell"
    
    private(set) var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = DesignConstants.shared.largeFont
        return label
    }()
    
    // MARK: - Initiation
    //
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(titleLabel)
        self.contentView.backgroundColor = .white
        
        self.contentView.setNeedsLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding = DesignConstants.shared.padding
        let bounds = self.contentView.bounds
        let fontLineHeight: CGFloat = DesignConstants.shared.largeFont.getFontHeight()
        
        titleLabel.frame = CGRect(x: padding.left,
                                  y: bounds.maxY - padding.bottom - fontLineHeight,
                                  width: bounds.width - padding.left - padding.right,
                                  height: fontLineHeight)
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        super.prepareForReuse()
    }
}
