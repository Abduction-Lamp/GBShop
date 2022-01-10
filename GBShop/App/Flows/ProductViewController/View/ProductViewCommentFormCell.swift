//
//  ProductViewCommentFormCell.swift
//  GBShop
//
//  Created by Владимир on 05.01.2022.
//

import UIKit

final class ProductViewCommentFormCell: UITableViewHeaderFooterView {
    static let reuseIdentifier = "ProductViewCommentFormCell"
    
    private(set) var form: UITextView = {
        let text = UITextView()
        text.font = DesignConstants.shared.mediumFont
        text.layer.cornerRadius = 5
        text.layer.masksToBounds = true
        text.textColor = .black
        text.isEditable = true
        text.isScrollEnabled = true
        return text
    }()
    
    private(set) var addCommentButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitleColor(.systemGray2, for: .highlighted)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = DesignConstants.shared.mediumFont
        button.layer.cornerRadius = 5
        button.setTitle("Оставить отзыв", for: .normal)
        return button
    }()
    
    // MARK: - Initiation
    //
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .tertiarySystemGroupedBackground
        self.contentView.addSubview(form)
        self.contentView.addSubview(addCommentButton)
        self.setNeedsLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        makeLayoutByFrame()
    }

    override func prepareForReuse() {
        form.text = nil
        super.prepareForReuse()
    }

    // MARK: - Configure Content
    //
    private func makeLayoutByFrame() {
        let padding = DesignConstants.shared.imagePadding
        let buttonSize = CGSize(width: 200, height: 40)
        let bounds = self.contentView.bounds
        
        form.frame = CGRect(x: padding.top,
                            y: padding.left,
                            width: bounds.width - padding.left - padding.right,
                            height: bounds.height - padding.top - padding.bottom - buttonSize.height - padding.bottom)
        
        addCommentButton.frame = CGRect(x: bounds.width - padding.right - buttonSize.width,
                                        y: form.frame.maxY + padding.top,
                                        width: buttonSize.width,
                                        height: buttonSize.height)
    }
}
