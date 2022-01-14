//
//  LogoutResponse.swift
//  GBShop
//
//  Created by Владимир on 30.11.2021.
//

import Foundation

struct LogoutResponse: Codable {
    let result: Int
    let message: String
}

extension LogoutResponse: CustomStringConvertible {
    
    var description: String {
        return  """
                result:  \(result)
                message: \(message)\n
                """
    }
}
