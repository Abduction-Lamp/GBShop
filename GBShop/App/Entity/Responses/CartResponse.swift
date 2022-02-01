//
//  CartResponse.swift
//  GBShop
//
//  Created by Владимир on 16.12.2021.
//

import Foundation

struct CartResponse: AbstructResponse, Codable {
    let result: Int
    let message: String
    let cart: [CartItem]?
}

extension CartResponse: CustomStringConvertible {
    
    var description: String {
        var output = """
                     result:    \(result)
                     message:   \(message)\n
                     """
        if let cart = self.cart {
            cart.forEach { item in
                output += """
                          product: \(item.product.name) x \(item.quantity)\n
                          """
            }
        }
        return output
    }
}
