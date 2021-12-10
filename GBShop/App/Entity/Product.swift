//
//  Product.swift
//  GBShop
//
//  Created by Владимир on 06.12.2021.
//

import Foundation

struct Product: Codable {
    let id: Int
    let name: String
    let category: String
    let price: Double
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id_product"
        case name = "product_name"
        case category
        case price
        case description = "product_description"
    }
}

extension Product: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return  lhs.id == rhs.id &&
                lhs.name == rhs.name &&
                lhs.category == rhs.category &&
                lhs.price == rhs.price &&
                lhs.description == rhs.description
    }
}
