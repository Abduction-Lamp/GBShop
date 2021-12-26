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
    let catalog: [Section]?
}
