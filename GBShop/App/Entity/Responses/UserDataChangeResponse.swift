//
//  UserDataChangeResponse.swift
//  GBShop
//
//  Created by Владимир on 30.11.2021.
//

import Foundation

struct UserDataChangeResponse: AbstructResponse, Codable {
    let result: Int
    let message: String
    let user: User?
}

extension UserDataChangeResponse: CustomStringConvertible {
    
    var description: String {
        var output = """
                     result:    \(result)
                     message:   \(message)\n
                     """
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
