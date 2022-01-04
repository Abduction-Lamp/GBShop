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
        
        let padding = DesignConstants.shared.padding
        let imagePadding = DesignConstants.shared.imagePadding
        let cellPadding = DesignConstants.shared.cellPaddingForInsetGroupedStyle
        let mediumFont = DesignConstants.shared.mediumFont
        let largeFont = DesignConstants.shared.smallFont
        
        titleCell.value = title
        titleCell.height = ceil(largeFont.lineHeight * 2)
        
        self.category = category

        let widthCell = bounds.width - cellPadding.left - cellPadding.right
        let width = widthCell - padding.left - padding.right
        
        imageCell.value = imageURL
        imageCell.height = widthCell
        
        let textBlockSize = description.calculationTextBlockSize(width: width, font: mediumFont)
        descriptionCell.value = description
        descriptionCell.height = textBlockSize.height + padding.top + padding.bottom
        
        priceCell.value = price
        priceCell.height = DesignConstants.shared.buttonSize.height + imagePadding.top + imagePadding.bottom
    }
    
    init(bounds: CGRect, product: Product) {
        var imageURL: URL?
        if let urlString = product.imageURL {
            imageURL = URL(string: urlString)
        }
        let priceString = String(format: "%.0f \u{20BD}", product.price)
        self.init(bounds: bounds,
                  title: product.name,
                  category: product.category,
                  imageURL: imageURL,
                  description: product.description ?? "",
                  price: priceString)
    }
}

extension ProductViewModel: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return  lhs.titleCell.value == rhs.titleCell.value &&
                lhs.imageCell.value == rhs.imageCell.value &&
                lhs.descriptionCell.value == rhs.descriptionCell.value &&
                lhs.priceCell.value == rhs.priceCell.value
    }
}
