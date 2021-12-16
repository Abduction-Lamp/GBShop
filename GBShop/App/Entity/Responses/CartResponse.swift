//
//  CartResponse.swift
//  GBShop
//
//  Created by Владимир on 16.12.2021.
//

import Foundation

struct CartResponse: Codable {
    let result: Int
    let message: String
    let cart: [Product]?

    var description: String {
        var output = """
                     result:   \(result)
                     message:  \(message)\n
                     """
        if let cart = self.cart {
            
            cart.forEach { item in
                output += """
                          product:  id:          \(item.id)
                                    name:        \(item.name)
                                    category:    \(item.category)
                                    price:       \(item.price)
                                    description: \(item.description ?? "")\n
                          """
            }
        }
        return output
    }
}
