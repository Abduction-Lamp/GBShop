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
}

extension UserRegisterResponse: CustomStringConvertible {
    
    var description: String {
        return  """
                result:  \(result)
                message: \(message)\n
                """
    }
}
