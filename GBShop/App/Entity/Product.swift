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
    let price: Double
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id_product"
        case name = "product_name"
        case price
        case description = "product_description"
    }
}
