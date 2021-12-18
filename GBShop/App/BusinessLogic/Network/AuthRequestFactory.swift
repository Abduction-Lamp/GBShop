//
//  AuthRequestFactory.swift
//  GBShop
//
//  Created by Владимир on 30.11.2021.
//

import Foundation
import Alamofire

protocol AuthRequestFactory {
    func login(login: String, password: String, completionHandler: @escaping (AFDataResponse<LoginResponse>) -> Void)
    func logout(id: Int, token: String, completionHandler: @escaping (AFDataResponse<LogoutResponse>) -> Void)
}
