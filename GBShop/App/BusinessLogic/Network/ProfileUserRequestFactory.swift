//
//  ProfileUserRequestFactory.swift
//  GBShop
//
//  Created by Владимир on 30.11.2021.
//

import Foundation
import Alamofire

protocol ProfileUserRequestFactory {
    func register(user: User, password: String, completionHandler: @escaping (AFDataResponse<RegisterResult>) -> Void)
    func change(user: User, password: String, completionHandler: @escaping (AFDataResponse<ChangeUserResult>) -> Void)
}
