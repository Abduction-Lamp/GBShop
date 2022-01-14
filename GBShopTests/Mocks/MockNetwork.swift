//
//  MockNetwork.swift
//  GBShopTests
//
//  Created by Владимир on 23.12.2021.
//

import XCTest
import Alamofire
@testable import GBShop

class MockNetworkRequest: RequestFactoryProtocol {
    
    func makeAuthRequestFatory() -> AuthRequestFactory {
        return MockNetworkAuthRequest()
    }
    func makeUserRequestFactory() -> UserRequestFactory {
        return MockNetworkUserRequest()
    }
}

class MockNetworkAuthRequest: AuthRequestFactory {
    
    // MARK: LOGIN
    let loginResultSuccess: Result<LoginResponse, AFError> = .success(LoginResponse(result: 1, message: "success", user: nil, token: nil))
    let loginResultFailure: Result<LoginResponse, AFError> = .failure(.explicitlyCancelled)
    
    lazy var loginResponseSuccess = AFDataResponse<LoginResponse>(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 1,
                                                             result: loginResultSuccess)
    lazy var loginResponseFailure = AFDataResponse<LoginResponse>(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 1,
                                                             result: loginResultFailure)
    
    // MARK: LOGOUT
    let logoutResultSuccess: Result<LogoutResponse, AFError> = .success(LogoutResponse(result: 1, message: "success"))
    let logoutResultFailure: Result<LogoutResponse, AFError> = .failure(.explicitlyCancelled)
    
    lazy var logoutResponseSuccess = AFDataResponse<LogoutResponse>(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 1,
                                                             result: logoutResultSuccess)
    lazy var logoutResponseFailure = AFDataResponse<LogoutResponse>(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 1,
                                                             result: logoutResultFailure)
    
    // MARK: -
    //
    func login(login: String, password: String, completionHandler: @escaping (AFDataResponse<LoginResponse>) -> Void) {
        if (login == "login") && (password == "password") {
            completionHandler(loginResponseSuccess)
        } else {
            completionHandler(loginResponseFailure)
        }
    }
    
    func logout(id: Int, token: String, completionHandler: @escaping (AFDataResponse<LogoutResponse>) -> Void) {
        if (id == 3) && (token == "") {
            completionHandler(logoutResponseSuccess)
        } else {
            completionHandler(logoutResponseFailure)
        }
    }
}

// MARK: -
//
//
//
class MockNetworkUserRequest: UserRequestFactory {
    
    static var fakeUser: User = User(id: 3,
                                     firstName: "firstName",
                                     lastName: "lastName",
                                     gender: "m",
                                     email: "email@email.ru",
                                     creditCard: "1111-1111-1111-1111",
                                     login: "login",
                                     password: "password")
    
    // MARK: register
    lazy var registerResultSuccess: Result<UserRegisterResponse, AFError> = .success(UserRegisterResponse(result: 1,
                                                                                                          message: "success",
                                                                                                          user: MockNetworkUserRequest.fakeUser,
                                                                                                          token: "token"))
    lazy var registerResultFailure: Result<UserRegisterResponse, AFError> = .failure(.explicitlyCancelled)
    
    lazy var registerResponseSuccess = AFDataResponse<UserRegisterResponse>(request: nil, response: nil, data: nil, metrics: nil,
                                                                            serializationDuration: 1,
                                                                            result: registerResultSuccess)
    lazy var registerResponseFailure = AFDataResponse<UserRegisterResponse>(request: nil, response: nil, data: nil, metrics: nil,
                                                                            serializationDuration: 1,
                                                                            result: registerResultFailure)
    
    // MARK: change
    lazy var changeResultSuccess: Result<UserDataChangeResponse, AFError> = .success(UserDataChangeResponse(result: 1,
                                                                                                            message: "success",
                                                                                                            user: MockNetworkUserRequest.fakeUser))
    lazy var changeResultFailure: Result<UserDataChangeResponse, AFError> = .failure(.explicitlyCancelled)
    
    lazy var changeResponseSuccess = AFDataResponse<UserDataChangeResponse>(request: nil, response: nil, data: nil, metrics: nil,
                                                                            serializationDuration: 1,
                                                                            result: changeResultSuccess)
    lazy var changeResponseFailure = AFDataResponse<UserDataChangeResponse>(request: nil, response: nil, data: nil, metrics: nil,
                                                                            serializationDuration: 1,
                                                                            result: changeResultFailure)
    
    // MARK: -
    //
    func register(user: User, completionHandler: @escaping (AFDataResponse<UserRegisterResponse>) -> Void) {
        if  (user.firstName == MockNetworkUserRequest.fakeUser.firstName) &&
            (user.lastName == MockNetworkUserRequest.fakeUser.lastName) &&
            (user.gender == MockNetworkUserRequest.fakeUser.gender) &&
            (user.email == MockNetworkUserRequest.fakeUser.email) &&
            (user.creditCard == MockNetworkUserRequest.fakeUser.creditCard) &&
            (user.login == MockNetworkUserRequest.fakeUser.login) &&
            (user.password == MockNetworkUserRequest.fakeUser.password) {
            completionHandler(registerResponseSuccess)
        } else {
            completionHandler(registerResponseFailure)
        }
    }
    
    func change(user: User, token: String, completionHandler: @escaping (AFDataResponse<UserDataChangeResponse>) -> Void) {
        if (user == MockNetworkUserRequest.fakeUser) && (token == "") {
            completionHandler(changeResponseSuccess)
        } else {
            completionHandler(changeResponseFailure)
        }
    }
}
