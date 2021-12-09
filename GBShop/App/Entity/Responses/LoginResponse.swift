//
//  LoginResponse.swift
//  GBShop
//
//  Created by Владимир on 30.11.2021.
//

import Foundation

struct LoginResponse: Codable {
    let result: Int
    let message: String
    let user: User?
    let token: String?
}
