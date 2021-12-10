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
    
    
    // MARK: - Description
    //
    var description: String {
        var output =    """
                        result:  \(result)
                        message: \(message)
                        
                        """
        if let user = self.user {
            output +=   """
                        user:    id:         \(user.id)
                                 login:      \(user.login)
                                 firstName:  \(user.firstName)
                                 lastName:   \(user.lastName)
                                 email:      \(user.email)
                                 gender:     \(user.gender)
                                 creditCard: \(user.creditCard)
                        
                        """
        }
        return output
    }

}
