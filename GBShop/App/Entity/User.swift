//
//  User.swift
//  GBShop
//
//  Created by Владимир on 30.11.2021.
//

import Foundation

struct User: Codable {
    let id: Int
    let login: String
    let firstName: String
    let lastName: String
    let email: String
    let gender: String
    let creditCard: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case gender
        case creditCard = "credit_card"
    }
}
