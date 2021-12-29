//
//  CatalogHeaderView.swift
//  GBShop
//
//  Created by Владимир on 27.12.2021.
//

import UIKit

final class CatalogHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeader"
    
     private(set) var title: UILabel = {
         let label: UILabel = UILabel()
         label.textColor = .gray
         return label
     }()
    
    // MARK: Initialization
     override init(frame: CGRect) {
         super.init(frame: frame)

         self.addSubview(title)
         self.setNeedsLayout()
     }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let font = UIFont(name: "NewYork-Regular", size: 19) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize)
        title.font = font
        
        let padding = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 5)
        
        title.frame = CGRect(x: padding.left,
                             y: font.lineHeight - padding.bottom,
                             width: self.bounds.width - padding.left - padding.right,
                             height: font.lineHeight)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
    }
}
