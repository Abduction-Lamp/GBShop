//
//  Cart.swift
//  GBShop
//
//  Created by Владимир on 16.12.2021.
//

import Foundation

struct CartItem: Codable {
    let product: Product
    let quantity: Int
}

struct Cart: Codable {
    
    var items: [CartItem] = []
    
    var totalCartCount: Int {
        var total = 0
        items.forEach { total += $0.quantity }
        return total
    }
    
    var totalPrice: Double {
        var total: Double = 0
        items.forEach { total += $0.product.price * Double($0.quantity) }
        return total
    }
}
