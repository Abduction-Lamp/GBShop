//
//  EmptyCartViewCell.swift
//  GBShop
//
//  Created by Владимир on 09.01.2022.
//

import UIKit

final class EmptyCartViewCell: UITableViewHeaderFooterView {
    static let reuseIdentifier = "EmptyCartViewCell"
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textColor = .black
        label.textAlignment = .center
        label.font = DesignConstants.shared.largeFont
        label.text = "Сложите в корзину нужные товары"
        return label
    }()
    
    // MARK: - Initiation
    //
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .tertiarySystemGroupedBackground
        self.contentView.addSubview(titleLabel)
        self.setNeedsLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = contentView.bounds
        titleLabel.center = contentView.center
    }
}
