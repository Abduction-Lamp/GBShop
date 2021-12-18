//
//  AuthResponseCodableTests.swift
//  GBShopTests
//
//  Created by Владимир on 06.12.2021.
//

import XCTest
import Alamofire
@testable import GBShop

class AuthResponseCodableTests: XCTestCase {

    let auth = RequestFactory().makeAuthRequestFatory()
    let expectation = XCTestExpectation(description: "Download https://salty-springs-77873.herokuapp.com/")
    
    
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}

    
    // MARK: - Login
    //
    let requestLoginLogin: String = "Username"
    let requestLoginPassword: String = "UserPassword"
    let expressionLoginResponseSuccess = LoginResponse(result: 1,
                                                       message: "Иван, добро пожаловать!",
                                                       user: User(id: 1,
                                                                  login: "Username",
                                                                  firstName: "Иван",
                                                                  lastName: "Иванов",
                                                                  email: "ivanov@mail.ru",
                                                                  gender: "m",
                                                                  creditCard: "1000-2000-3000-4000"),
                                                       token: "ED86EE70-124E-46DD-876B-4A4441F74575")

    func testLoginResponseSuccess() throws {
        auth.login(login: requestLoginLogin, password: requestLoginPassword) { response in
            switch response.result {
            case .success(let result):
                XCTAssertEqual(result.result,           self.expressionLoginResponseSuccess.result)
                XCTAssertEqual(result.message,          self.expressionLoginResponseSuccess.message)
                XCTAssertEqual(result.token,            self.expressionLoginResponseSuccess.token)
                XCTAssertEqual(result.user?.id,         self.expressionLoginResponseSuccess.user?.id)
                XCTAssertEqual(result.user?.login,      self.expressionLoginResponseSuccess.user?.login)
                XCTAssertEqual(result.user?.firstName,  self.expressionLoginResponseSuccess.user?.firstName)
                XCTAssertEqual(result.user?.lastName,   self.expressionLoginResponseSuccess.user?.lastName)
                XCTAssertEqual(result.user?.email,      self.expressionLoginResponseSuccess.user?.email)
                XCTAssertEqual(result.user?.gender,     self.expressionLoginResponseSuccess.user?.gender)
                XCTAssertEqual(result.user?.login,      self.expressionLoginResponseSuccess.user?.login)
                XCTAssertEqual(result.user?.creditCard, self.expressionLoginResponseSuccess.user?.creditCard)

            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }

    
    let expressionLoginResponseFailure = LoginResponse(result: 0, message: "Неверный логин или пароль", user: nil, token: nil)

    func testLoginResponseFailure() throws {
        auth.login(login: "login", password: "password") { response in
            switch response.result {
            case .success(let result):
                XCTAssertEqual(result.result,  self.expressionLoginResponseFailure.result)
                XCTAssertEqual(result.message, self.expressionLoginResponseFailure.message)
                XCTAssertEqual(result.token,   self.expressionLoginResponseFailure.token)
                XCTAssertEqual(result.user,    self.expressionLoginResponseFailure.user)
                
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }


    // MARK: - Logout
    //
    let requestLogoutID: Int = 2
    let requestLogoutToken: String = "13AA24D9-ECF1-401A-8F32-B05EBC7E8E38"
    let expressionLogoutResponseSuccess: LogoutResponse = LogoutResponse(result: 1, message: "Маша, вы успешно вышли из системы")

    func testLogoutResponseSuccess() throws {
        auth.logout(id: requestLogoutID, token: requestLogoutToken) { response in
            switch response.result {
            case .success(let result):
                XCTAssertEqual(result.result, self.expressionLogoutResponseSuccess.result)
                XCTAssertEqual(result.message, self.expressionLogoutResponseSuccess.message)
                
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
    
    
    let fakeID = 0
    let fakeToken = "token"
    let expressionLogoutResponseFailure: LogoutResponse = LogoutResponse(result: 0, message: "Пользователь с ID = 0 не найден или Token устарел")
    
    func testLogoutResponseFailure() throws {
        auth.logout(id: fakeID, token: fakeToken) { response in
            switch response.result {
            case .success(let result):
                XCTAssertEqual(result.result, self.expressionLogoutResponseFailure.result)
                XCTAssertEqual(result.message, self.expressionLogoutResponseFailure.message)
                
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
}
