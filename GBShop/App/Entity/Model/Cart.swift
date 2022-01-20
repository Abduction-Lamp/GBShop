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

extension CartItem: Equatable {
    static func == (lhs: CartItem, rhs: CartItem) -> Bool {
        return (lhs.product == rhs.product) && (lhs.quantity == rhs.quantity)
    }
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

extension Cart: Equatable {
    
    static func == (lhs: Cart, rhs: Cart) -> Bool {
        guard lhs.items.count == rhs.items.count else { return false }
        
        for index in 0 ..< lhs.items.count {
            if lhs.items[index] == rhs.items[index] {
                continue
            }
            return false
        }
        return true
    }
}
