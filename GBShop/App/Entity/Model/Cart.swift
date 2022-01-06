//
//  Cart.swift
//  GBShop
//
//  Created by Владимир on 16.12.2021.
//

import Foundation

struct Cart {
    let owner: Int
    var cart: [Product] = []
    var totalPrice: Decimal {
        var total = Decimal(0)
        cart.forEach { item in total += Decimal(item.price) }
        return total
    }
    
    init(owner: Int) {
        self.owner = owner
    }
}

extension Cart: Equatable {

    static func == (lhs: Self, rhs: Self) -> Bool { lhs.owner == rhs.owner }
}
