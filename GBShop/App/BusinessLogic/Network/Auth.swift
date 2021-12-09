//
//  Auth.swift
//  GBShop
//
//  Created by Владимир on 30.11.2021.
//

import Foundation
import Alamofire

class Auth: AbstractRequestFactory {
    let errorParser: AbstractErrorParser
    let sessionManager: Session
    let queue: DispatchQueue
    let baseUrl = URL(string: "https://salty-springs-77873.herokuapp.com/")!
    
    init(errorParser: AbstractErrorParser,
         sessionManager: Session,
         queue: DispatchQueue = DispatchQueue.global(qos: .utility)) {
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
    }
}

extension Auth: AuthRequestFactory {
    
    func login(login: String,
               password: String,
               completionHandler: @escaping(AFDataResponse<LoginResponse>) -> Void) {
        let requestModel = Login(baseUrl: baseUrl, login: login, password: password)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func logout(id: Int, token: String, completionHandler: @escaping (AFDataResponse<LogoutResponse>) -> Void) {
        let requestModel = Logout(baseUrl: baseUrl, id: id, token: token)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
}

extension Auth {
    
    struct Login: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "login"
        let login: String
        let password: String
        var parameters: Parameters? {
            return [
                "login": login,
                "password": password
            ]
        }
    }
    
    struct Logout: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "logout"
        let id: Int
        let token: String
        var parameters: Parameters? {
            return [
                "id": id,
                "token": token
            ]
        }
    }
}
