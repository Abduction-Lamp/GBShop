//
//  ProductViewCommentCell.swift
//  GBShop
//
//  Created by Владимир on 03.01.2022.
//

import UIKit

final class ProductViewCommentCell: UITableViewCell {
    static let reuseIdentifier = "ProductViewCommentCell"
    
    private(set) var username: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemYellow.withAlphaComponent(0.1)
        label.textColor = .black
        label.textAlignment = .left
        label.font = DesignConstants.shared.mediumFont
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    private(set) var date: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .left
        label.font = DesignConstants.shared.smallFont
        return label
    }()
    
    private(set) var comment: UITextView = {
        let text = UITextView()
        text.font = DesignConstants.shared.mediumFont
        text.textColor = .black
        text.isEditable = false
        text.isScrollEnabled = false
        return text
    }()
    
    // MARK: - Initiation
    //
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(username)
        self.contentView.addSubview(date)
        self.contentView.addSubview(comment)
        self.contentView.backgroundColor = .white
        
        self.setNeedsLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.contentView.bounds
        let desing = DesignConstants.shared
        
        username.frame = CGRect(x: desing.padding.left,
                                y: desing.padding.top,
                                width: bounds.width - desing.padding.left - desing.padding.right,
                                height: desing.mediumFont.lineHeight)
        date.frame = CGRect(x: desing.imagePadding.left,
                            y: username.frame.maxY + desing.padding.top,
                            width: bounds.width - desing.imagePadding.left - desing.imagePadding.right,
                            height: desing.smallFont.lineHeight)
        comment.frame = CGRect(x: desing.imagePadding.left,
                               y: date.frame.maxY + desing.imagePadding.top,
                               width: bounds.width - desing.imagePadding.left - desing.imagePadding.right,
                               height: bounds.height - desing.imagePadding.bottom - desing.imagePadding.top - date.frame.maxY)

    }
    
    override func prepareForReuse() {
        username.text = nil
        date.text = nil
        comment.text = nil
        super.prepareForReuse()
    }
}
