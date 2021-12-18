//
//  ProfileUserRequestFactory.swift
//  GBShop
//
//  Created by Владимир on 30.11.2021.
//

import Foundation
import Alamofire

protocol UserRequestFactory {
    func register(user: User, password: String, completionHandler: @escaping (AFDataResponse<UserRegisterResponse>) -> Void)
    func change(user: User, token: String, completionHandler: @escaping (AFDataResponse<UserDataChangeResponse>) -> Void)
}
