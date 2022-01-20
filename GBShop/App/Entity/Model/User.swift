//
//  User.swift
//  GBShop
//
//  Created by Владимир on 30.11.2021.
//

import Foundation

struct User: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let gender: String
    let email: String
    let creditCard: String
    let login: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case gender
        case email
        case creditCard = "credit_card"
        case login
        case password
    }
}

extension User: Equatable {

    static func == (lhs: Self, rhs: Self) -> Bool {
        return  lhs.id == rhs.id &&
                lhs.login == rhs.login &&
                lhs.firstName == rhs.firstName &&
                lhs.lastName == rhs.lastName &&
                lhs.email == rhs.email &&
                lhs.gender == rhs.gender &&
                lhs.creditCard == rhs.creditCard &&
                lhs.password == rhs.password
    }
}

extension User: CustomStringConvertible {
    
    var description: String {
        """
        User (struct):
            id:         \(self.id)
            firstName:  \(self.firstName)
            lastName:   \(self.lastName)
            gender:     \(self.gender)
            email:      \(self.email)
            creditCard: \(self.creditCard)
            login:      \(self.login)
            password:   \(self.password)\n
        """
    }
}
