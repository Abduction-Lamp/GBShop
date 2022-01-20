//
//  Catalog.swift
//  GBShop
//
//  Created by Владимир on 26.12.2021.
//

import Foundation

struct Section: Codable {
    let id: Int
    let title: String
    let items: [Product]
}

extension Section: Equatable {

    static func == (lhs: Self, rhs: Self) -> Bool {
        return  lhs.id == rhs.id
    }
}
