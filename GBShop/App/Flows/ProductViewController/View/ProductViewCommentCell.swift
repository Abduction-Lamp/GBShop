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
    
    private(set) var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setBackgroundImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .systemRed
        button.contentMode = .scaleAspectFit
        button.isHidden = true
        return button
    }()
    
    // MARK: - Initiation
    //
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(username)
        self.contentView.addSubview(date)
        self.contentView.addSubview(comment)
        self.contentView.addSubview(deleteButton)
        
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
        let imagePadding = DesignConstants.shared.imagePadding
        let mediumFont = DesignConstants.shared.mediumFont
        let smallFont = DesignConstants.shared.smallFont
        let widthDeleteButton = mediumFont.getFontHeight()
        let heightDeleteButton = mediumFont.getFontHeight()
        
        username.frame = CGRect(x: padding.left,
                                y: padding.top,
                                width: bounds.width - padding.left - padding.right - widthDeleteButton - padding.right,
                                height: heightDeleteButton)
        
        deleteButton.frame = CGRect(x: username.frame.maxX + padding.left,
                                    y: padding.top,
                                    width: widthDeleteButton,
                                    height: heightDeleteButton)
        
        date.frame = CGRect(x: username.frame.origin.x,
                            y: username.frame.maxY + padding.top,
                            width: bounds.width - imagePadding.left - imagePadding.right,
                            height: ceil(smallFont.lineHeight))
        
        comment.frame = CGRect(x: imagePadding.left,
                               y: date.frame.maxY + imagePadding.top,
                               width: bounds.width - imagePadding.left - imagePadding.right,
                               height: bounds.height - imagePadding.bottom - imagePadding.top - date.frame.maxY)
    }
    
    override func prepareForReuse() {
        username.text = nil
        date.text = nil
        comment.text = nil
        deleteButton.isHidden = true
        super.prepareForReuse()
    }
}
