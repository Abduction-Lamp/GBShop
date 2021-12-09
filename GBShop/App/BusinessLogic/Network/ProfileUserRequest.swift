//
//  ProfileUserRequest.swift
//  GBShop
//
//  Created by Владимир on 30.11.2021.
//

import Foundation
import Alamofire

class ProfileUserRequest: AbstractRequestFactory {
    
    let errorParser: AbstractErrorParser
    let sessionManager: Session
    let queue: DispatchQueue
    
    let baseUrl = URL(string: "https://raw.githubusercontent.com/GeekBrainsTutorial/online-store-api/master/responses/")!

    init(errorParser: AbstractErrorParser,
         sessionManager: Session,
         queue: DispatchQueue = DispatchQueue.global(qos: .utility)) {
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
    }
}

extension ProfileUserRequest: ProfileUserRequestFactory {
    
    func register(user: Profile, password: String, completionHandler: @escaping (AFDataResponse<RegisterResult>) -> Void) {
        let path = "registerUser.json"
        let requestModel = Request(baseUrl: baseUrl, path: path, user: user, password: password)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func change(user: Profile, password: String, completionHandler: @escaping (AFDataResponse<ChangeUserResult>) -> Void) {
        let path = "changeUserData.json"
        let requestModel = Request(baseUrl: baseUrl, path: path, user: user, password: password)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
}

extension ProfileUserRequest {
    
    struct Request: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String
        let user: Profile
        let password: String
        var parameters: Parameters? {
            return [
                "id_user": user.id,
                "username": user.login,
                "password": password,
                "email": user.email,
                "gender": user.gender,
                "credit_card": user.creditCard,
                "bio": user.bio
            ]
        }
    }
}
