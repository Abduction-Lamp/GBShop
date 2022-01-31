//
//  SectionResponse.swift
//  GBShop
//
//  Created by Владимир on 26.12.2021.
//

import Foundation

struct SectionResponse: AbstructResponse, Codable {
    let result: Int
    let message: String
    let section: Section?
}
