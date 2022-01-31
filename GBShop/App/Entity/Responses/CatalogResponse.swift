//
//  CatalogResponse.swift
//  GBShop
//
//  Created by Владимир on 10.12.2021.
//

import Foundation

struct CatalogResponse: AbstructResponse, Codable {
    let result: Int
    let message: String
    let catalog: [Section]?
}

extension CatalogResponse: CustomStringConvertible {
    
    var description: String {
        let output = """
                     result:    \(result)
                     message:   \(message)\n
                     """
        return output
    }
}
