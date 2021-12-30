//
//  ProductViewDescriptionCell.swift
//  GBShop
//
//  Created by Владимир on 30.12.2021.
//

import UIKit

final class ProductViewDescriptionCell: UITableViewCell {
    static let reuseIdentifier = "ProductViewDescriptionCell"
    
    private(set) var textView: UITextView = {
        let text = UITextView()
        text.font = DesignConstants.shared.mediumFont
        text.textColor = .black
        return text
    }()
    
    // MARK: - Initiation
    //
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(textView)
        self.contentView.backgroundColor = .white
        
        self.setNeedsLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding = DesignConstants.shared.padding
        let bounds = self.contentView.bounds
        
        textView.frame = CGRect(x: padding.left,
                                y: padding.top,
                                width: bounds.width - padding.left - padding.right,
                                height: bounds.width - padding.top - padding.bottom)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textView.text = nil
    }
}
