//
//  GetGoodByIdResult.swift
//  GBShop
//
//  Created by Владимир on 06.12.2021.
//

import Foundation

struct GetGoodByIdResult: Codable {
    let result: Int
    let name: String
    let price: Double
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case result
        case name = "product_name"
        case price = "product_price"
        case description = "product_description"
    }
}
