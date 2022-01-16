//
//  CartViewToolsFooter.swift
//  GBShop
//
//  Created by Владимир on 16.01.2022.
//

import UIKit

final class CartViewToolsFooter: UITableViewHeaderFooterView {
    static let reuseIdentifier = "CartViewToolsFooter"
    
    private(set) var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setBackgroundImage(UIImage(systemName: "trash.square"), for: .normal)
        button.tintColor = .systemRed.withAlphaComponent(0.7)
        button.contentMode = .scaleToFill
        return button
    }()
    
    private(set) var plusButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setBackgroundImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.tintColor = .systemBrown
        button.contentMode = .scaleToFill
        return button
    }()
    
    private(set) var minusButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setBackgroundImage(UIImage(systemName: "minus.circle"), for: .normal)
        button.tintColor = .systemBrown
        button.contentMode = .scaleToFill
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Initiation
    //
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .tertiarySystemGroupedBackground
        self.contentView.addSubview(deleteButton)
        self.contentView.addSubview(minusButton)
        self.contentView.addSubview(plusButton)
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
        super.prepareForReuse()
    }

    // MARK: - Configure Content
    //
    private func makeLayoutByFrame() {
        let bounds = self.contentView.bounds
        
        let imagePadding = DesignConstants.shared.imagePadding
        let padding = DesignConstants.shared.padding
        
        let widthButton: CGFloat = 33
        let heightButton: CGFloat = 30
        
        deleteButton.frame = CGRect(x: bounds.width - widthButton,
                                    y: padding.top,
                                    width: widthButton,
                                    height: heightButton)
        
        plusButton.frame = CGRect(x: deleteButton.frame.origin.x - imagePadding.right - imagePadding.right - widthButton,
                                  y: padding.top,
                                  width: widthButton,
                                  height: heightButton)
        
        minusButton.frame = CGRect(x: plusButton.frame.origin.x - padding.right - widthButton,
                                   y: padding.top,
                                   width: widthButton,
                                   height: heightButton)
    }
}
