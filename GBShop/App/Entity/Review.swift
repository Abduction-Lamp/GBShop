//
//  Review.swift
//  GBShop
//
//  Created by Владимир on 12.12.2021.
//

import Foundation

struct Review: Codable {
    let id: Int
    let productId: Int
    let productName: String?
    let userId: Int
    let userLogin: String?
    let comment: String?
    let assessment: Int
    let date: TimeInterval

    enum CodingKeys: String, CodingKey {
        case id
        case productId = "product_id"
        case productName = "product_name"
        case userId = "user_id"
        case userLogin = "user_login"
        case comment
        case assessment
        case date
    }
}

extension Review: Equatable {

    static func == (lhs: Self, rhs: Self) -> Bool {
        return  lhs.id == rhs.id &&
                lhs.productId == rhs.productId &&
                lhs.productName == rhs.productName &&
                lhs.userId == rhs.userId &&
                lhs.userLogin == rhs.userLogin &&
                lhs.comment == rhs.comment &&
                lhs.assessment == rhs.assessment &&
                lhs.date == rhs.date
    }
}
