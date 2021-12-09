//
//  ProfileUserRequest.swift
//  GBShop
//
//  Created by Владимир on 30.11.2021.
//

import Foundation
import Alamofire

class UserRequest: AbstractRequestFactory {
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

extension UserRequest: UserRequestFactory {
    
    func register(user: User, password: String, completionHandler: @escaping (AFDataResponse<UserRegisterResponse>) -> Void) {
        let requestModel = Register(baseUrl: baseUrl, user: user, password: password)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func change(user: User, token: String, completionHandler: @escaping (AFDataResponse<UserDataChangeResponse>) -> Void) {
        let requestModel = Change(baseUrl: baseUrl, user: user, token: token)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
}

extension UserRequest {
    
    struct Register: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path = "register"
        let user: User
        let password: String
        var parameters: Parameters? {
            return [
                "id": user.id,
                "login": user.login,
                "first_name": user.firstName,
                "last_name": user.lastName,
                "email": user.email,
                "gender": user.gender,
                "credit_card": user.creditCard,
                "password": password
            ]
        }
    }
    
    struct Change: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path = "change"
        let user: User
        let token: String
        var parameters: Parameters? {
            return [
                "id": user.id,
                "login": user.login,
                "first_name": user.firstName,
                "last_name": user.lastName,
                "email": user.email,
                "gender": user.gender,
                "credit_card": user.creditCard,
                "token": token
            ]
        }
    }
}
