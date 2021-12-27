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
         label.translatesAutoresizingMaskIntoConstraints = false
         label.textColor = .black
         label.font = UIFont(name: "NewYork-Regular", size: 18)
         label.layer.masksToBounds = false
         label.layer.shadowColor = UIColor.gray.cgColor
         label.layer.shadowOffset = .zero
         label.layer.shadowOpacity = 0.2
         label.layer.shadowRadius = 1
         label.sizeToFit()
         return label
     }()
    
    // MARK: Initialization
     override init(frame: CGRect) {
         super.init(frame: frame)

         addSubview(title)

         title.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
         title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
//         title.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
    }
}
