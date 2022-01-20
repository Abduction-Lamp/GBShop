//
//  MockNetworkUserRequest.swift
//  GBShopTests
//
//  Created by Владимир on 14.01.2022.
//

import XCTest
import Alamofire
@testable import GBShop

// MARK: - MockNetworkUserRequest
//
class MockNetworkUserRequest: UserRequestFactory {
        
    let fake = FakeData()
    
    
    // MARK: REGISTER
    let userRegisterResponse = UserRegisterResponse(result: 1, message: "success", user: FakeData().user, token: FakeData().token)
    
    lazy var registerResultSuccess: Result<UserRegisterResponse, AFError> = .success(userRegisterResponse)
    lazy var registerResultFailure: Result<UserRegisterResponse, AFError> = .failure(.explicitlyCancelled)
    
    lazy var registerResponseSuccess = AFDataResponse<UserRegisterResponse>(request: nil,
                                                                            response: nil,
                                                                            data: nil,
                                                                            metrics: nil,
                                                                            serializationDuration: 1,
                                                                            result: registerResultSuccess)
    lazy var registerResponseFailure = AFDataResponse<UserRegisterResponse>(request: nil,
                                                                            response: nil,
                                                                            data: nil,
                                                                            metrics: nil,
                                                                            serializationDuration: 1,
                                                                            result: registerResultFailure)
    // MARK: register()
    func register(user: User, completionHandler: @escaping (AFDataResponse<UserRegisterResponse>) -> Void) {
        if (user.firstName == fake.user.firstName) &&
           (user.lastName == fake.user.lastName) &&
           (user.gender == fake.user.gender) &&
           (user.email == fake.user.email) &&
           (user.creditCard == fake.user.creditCard) &&
           (user.login == fake.user.login) &&
           (user.password == fake.user.password) {
            completionHandler(registerResponseSuccess)
        } else {
            completionHandler(registerResponseFailure)
        }
    }
    
    // MARK: CHANGE
    let userDataChangeResponse = UserDataChangeResponse(result: 1, message: "success", user: FakeData().user)
    lazy var changeResultSuccess: Result<UserDataChangeResponse, AFError> = .success(userDataChangeResponse)
    lazy var changeResultFailure: Result<UserDataChangeResponse, AFError> = .failure(.explicitlyCancelled)
    
    lazy var changeResponseSuccess = AFDataResponse<UserDataChangeResponse>(request: nil,
                                                                            response: nil,
                                                                            data: nil,
                                                                            metrics: nil,
                                                                            serializationDuration: 1,
                                                                            result: changeResultSuccess)
    lazy var changeResponseFailure = AFDataResponse<UserDataChangeResponse>(request: nil,
                                                                            response: nil,
                                                                            data: nil,
                                                                            metrics: nil,
                                                                            serializationDuration: 1,
                                                                            result: changeResultFailure)
    // MARK: change()
    func change(user: User, token: String, completionHandler: @escaping (AFDataResponse<UserDataChangeResponse>) -> Void) {
        if (user == fake.user) && (token == fake.token) {
            completionHandler(changeResponseSuccess)
        } else {
            completionHandler(changeResponseFailure)
        }
    }
}
