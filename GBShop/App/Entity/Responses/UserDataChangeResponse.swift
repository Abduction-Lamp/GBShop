//
//  UserDataChangeResponse.swift
//  GBShop
//
//  Created by Владимир on 30.11.2021.
//

import Foundation

struct UserDataChangeResponse: Codable {
    let result: Int
    let message: String
    let user: User?
}
