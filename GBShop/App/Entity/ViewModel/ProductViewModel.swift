//
//  ProductViewModel.swift
//  GBShop
//
//  Created by Владимир on 29.12.2021.
//

import UIKit

struct ProductViewModel {
    
    typealias ProductCell<T> = (value: T, height: CGFloat)
    
    let category: String
    
    let titleCell: ProductCell<String>
    let imageCell: ProductCell<URL?>
    let descriptionCell: ProductCell<String>
    let priceCell: ProductCell<String>
    
    init(bounds: CGRect, title: String, category: String, imageURL: URL?, description: String, price: String) {
        titleCell.value = title
        titleCell.height = ceil(DesignConstants.shared.largeFont.lineHeight * 2)
        
        self.category = category
        
        imageCell.value = imageURL
        imageCell.height = bounds.width
        
        let design = DesignConstants.shared
        descriptionCell.value = description
        descriptionCell.height = description.calculationTextBlockSize(width: bounds.width - design.padding.left - design.padding.right,
                                                                      font: design.mediumFont).height
        priceCell.value = price
        priceCell.height = ceil(DesignConstants.shared.largeFont.lineHeight * 3)
    }
}