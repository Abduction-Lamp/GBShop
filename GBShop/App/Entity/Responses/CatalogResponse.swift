//
//  CatalogResponse.swift
//  GBShop
//
//  Created by Владимир on 10.12.2021.
//

import Foundation

struct CatalogResponse: Codable {
    let result: Int
    let message: String
    let catalog: [Product]?

    var description: String {
        var output = """
                     result:   \(result)
                     message:  \(message)\n
                     """
        if let catalog = self.catalog {
            catalog.forEach { item in
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
