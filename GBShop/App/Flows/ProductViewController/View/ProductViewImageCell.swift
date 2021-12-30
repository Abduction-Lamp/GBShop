//
//  ProductViewImageCell.swift
//  GBShop
//
//  Created by Владимир on 30.12.2021.
//

import UIKit

final class ProductViewImageCell: UITableViewCell {
    static let reuseIdentifier = "ProductViewImageCell"
    
    private(set) var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    // MARK: - Initiation
    //
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(image)
        self.contentView.backgroundColor = .white
        
        self.setNeedsLayout()
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
                             width: bounds.width - padding.left - padding.right,
                             height: bounds.width - padding.top - padding.bottom)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
    }
}
