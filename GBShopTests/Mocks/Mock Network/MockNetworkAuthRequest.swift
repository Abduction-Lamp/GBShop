//
//  MockNetworkAuthRequest.swift
//  GBShopTests
//
//  Created by Владимир on 14.01.2022.
//

import XCTest
import Alamofire
@testable import GBShop

// MARK: - MockNetworkAuthRequest
//
class MockNetworkAuthRequest: AuthRequestFactory {
    
    let fake = FakeData()
    
    // MARK: LOGIN
    lazy var loginResponse = LoginResponse(result: 1, message: "success", user: fake.user, token: fake.token)
    
    lazy var loginResultSuccess: Result<LoginResponse, AFError> = .success(loginResponse)
    lazy var loginResultFailure: Result<LoginResponse, AFError> = .failure(.explicitlyCancelled)
    
    lazy var loginResponseSuccess = AFDataResponse<LoginResponse>(request: nil, response: nil, data: nil,  metrics: nil, serializationDuration: 1, result: loginResultSuccess)
    lazy var loginResponseFailure = AFDataResponse<LoginResponse>(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 1, result: loginResultFailure)
    
    // MARK: login()
    func login(login: String, password: String, completionHandler: @escaping (AFDataResponse<LoginResponse>) -> Void) {
        if (login == fake.user.login) && (password == fake.user.password) {
            completionHandler(loginResponseSuccess)
        } else {
            completionHandler(loginResponseFailure)
        }
    }

    
    // MARK: LOGOUT
    let logoutResultSuccess: Result<LogoutResponse, AFError> = .success(LogoutResponse(result: 1, message: "success"))
    let logoutResultFailure: Result<LogoutResponse, AFError> = .failure(.explicitlyCancelled)
    
    lazy var logoutResponseSuccess = AFDataResponse<LogoutResponse>(request: nil, response: nil,  data: nil, metrics: nil, serializationDuration: 1, result: logoutResultSuccess)
    lazy var logoutResponseFailure = AFDataResponse<LogoutResponse>(request: nil,  response: nil, data: nil, metrics: nil, serializationDuration: 1, result: logoutResultFailure)
    
    // MARK: logout()
    func logout(id: Int, token: String, completionHandler: @escaping (AFDataResponse<LogoutResponse>) -> Void) {
        if (id == fake.user.id) && (token == fake.token) {
            completionHandler(logoutResponseSuccess)
        } else {
            completionHandler(logoutResponseFailure)
        }
    }
}
