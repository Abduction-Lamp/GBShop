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
        
        let design = DesignConstants.shared
        let width = bounds.width - design.cellPaddingForInsetGroupedStyle.left - design.cellPaddingForInsetGroupedStyle.right
        
        imageCell.value = imageURL
        imageCell.height = width
        
        let textBlockSize = description.calculationTextBlockSize(width: width - design.padding.left - design.padding.right,
                                                                 font: design.mediumFont)
        descriptionCell.value = description
        descriptionCell.height = textBlockSize.height + design.padding.top + design.padding.bottom
        
        priceCell.value = price
        priceCell.height = DesignConstants.shared.buttonSize.height + design.imagePadding.top + design.imagePadding.bottom
    }
    
    init(bounds: CGRect, product: Product) {
        var imageURL: URL?
        if let urlString = product.imageURL {
            imageURL = URL(string: urlString)
        }
        var priceString = String(format: "%.0f", product.price)
        priceString += " \u{20BD}"
        
        self.init(bounds: bounds,
                  title: product.name,
                  category: product.category,
                  imageURL: imageURL,
                  description: product.description ?? "",
                  price: priceString)
    }
}
