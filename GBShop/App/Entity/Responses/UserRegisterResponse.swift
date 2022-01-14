//
//  UserRegisterResponse.swift
//  GBShop
//
//  Created by Владимир on 30.11.2021.
//

import Foundation

struct UserRegisterResponse: Codable {
    let result: Int
    let message: String
    let user: User?
    let token: String?
}

extension UserRegisterResponse: CustomStringConvertible {
    
    var description: String {
        var output = """
                     result:    \(result)
                     message:   \(message)\n
                     """
        if let token = self.token {
            output +=   """
                        token:   \(token)\n
                        """
        }
        if let user = self.user {
            output +=   """
                        user:    id:         \(user.id)
                                 firstName:  \(user.firstName)
                                 lastName:   \(user.lastName)
                                 gender:     \(user.gender)
                                 email:      \(user.email)
                                 creditCard: \(user.creditCard)
                                 login:      \(user.login)
                                 password:   \(user.password)\n
                        """
        }
        return output
    }
}
