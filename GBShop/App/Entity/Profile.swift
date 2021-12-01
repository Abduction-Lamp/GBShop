//
//  Profile.swift
//  GBShop
//
//  Created by Владимир on 30.11.2021.
//

import Foundation

struct Profile: Codable {
    let id: Int
    let login: String
    let email: String
    let gender: String
    let creditCard: String
    let bio: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id_user"
        case login = "username"
        case email = "email"
        case gender = "gender"
        case creditCard = "credit_card"
        case bio = "bio"
    }
}
