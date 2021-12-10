//
//  ProductResponse.swift
//  GBShop
//
//  Created by Владимир on 06.12.2021.
//

import Foundation

struct ProductResponse: Codable {
    let result: Int
    let message: String
    let product: Product?
    
    var description: String {
        var output = """
                     result:   \(result)
                     message:  \(message)
                     
                     """
        if let product = self.product {
            output += """
                      product:  id:          \(product.id)
                                name:        \(product.name)
                                category:    \(product.category)
                                price:       \(product.price)
                                description: \(product.description ?? "")
                      
                      """
        }
        return output
    }
}
