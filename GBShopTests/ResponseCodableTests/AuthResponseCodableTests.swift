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
    
    var auth: AuthRequestFactory!
    var initialStateEexpectation: XCTestExpectation!
    var expectation: XCTestExpectation!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        auth = RequestFactory().makeAuthRequestFactory()
        initialStateEexpectation = XCTestExpectation(description: "[ INITIAL STATE MOCK SERVER ]")
        expectation = XCTestExpectation(description: "[ Test ]")
        initialStateServer()
    }
    
    override func tearDownWithError() throws {
        auth = nil
        initialStateEexpectation = nil
        expectation = nil
        try super.tearDownWithError()
    }
    
    // MARK: - SUPPORT: Сбрасывает мок-данные на сервере в исходное состояние
    private func initialStateServer() {
        AF.request("https://salty-springs-77873.herokuapp.com/mock/server/state/initial")
            .responseJSON { response in
                switch response.result {
                case .success(let jsonObject):
                    if let json = jsonObject as? [String: Any] {
                        print(String(describing: "\n - [ INITIAL STATE MOCK SERVER ]: \(json["message"] ?? "nil")"))
                    } else {
                        XCTFail("server has not returned to its initial state")
                    }
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                self.initialStateEexpectation.fulfill()
            }
        wait(for: [self.initialStateEexpectation], timeout: 5.0)
    }
}

// MARK: - Login
//
extension AuthResponseCodableTests {
    
    func testLoginResponseSuccess() throws {
        let loginStub = String("Username")
        let passwordStu = String("UserPassword")
        let expression = LoginResponse(result: 1,
                                       message: "Иван, добро пожаловать!",
                                       user: User(id: 1,
                                                  firstName: "Иван",
                                                  lastName: "Иванов",
                                                  gender: "m",
                                                  email: "ivanov@mail.ru",
                                                  creditCard: "1000-2000-3000-4000",
                                                  login: "Username",
                                                  password: "UserPassword"),
                                       token: "ED86EE70-124E-46DD-876B-4A4441F74575")

        auth.login(login: loginStub, password: passwordStu) { response in
            switch response.result {
            case .success(let result):
                XCTAssertEqual(result.result, expression.result)
                XCTAssertEqual(result.message, expression.message)
                XCTAssertEqual(result.token, expression.token)
                XCTAssertEqual(result.user?.id, expression.user?.id)
                XCTAssertEqual(result.user?.login, expression.user?.login)
                XCTAssertEqual(result.user?.firstName, expression.user?.firstName)
                XCTAssertEqual(result.user?.lastName, expression.user?.lastName)
                XCTAssertEqual(result.user?.email, expression.user?.email)
                XCTAssertEqual(result.user?.gender, expression.user?.gender)
                XCTAssertEqual(result.user?.login, expression.user?.login)
                XCTAssertEqual(result.user?.creditCard, expression.user?.creditCard)

            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
    
    func testLoginResponseFailure() throws {
        let expression = LoginResponse(result: 0,
                                       message: "Неверный логин или пароль",
                                       user: nil,
                                       token: nil)

        auth.login(login: "login", password: "password") { response in
            switch response.result {
            case .success(let result):
                XCTAssertEqual(result.result, expression.result)
                XCTAssertEqual(result.message, expression.message)
                XCTAssertEqual(result.token, expression.token)
                XCTAssertEqual(result.user, expression.user)

            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
}

// MARK: - Logout
//
extension AuthResponseCodableTests {
    
    func testLogoutResponseSuccess() throws {
        let idStub = 2
        let tokenStub = String("13AA24D9-ECF1-401A-8F32-B05EBC7E8E38")
        let expression = LogoutResponse(result: 1, message: "Маша, вы успешно вышли из системы")

        auth.logout(id: idStub, token: tokenStub) { response in
            switch response.result {
            case .success(let result):
                XCTAssertEqual(result.result, expression.result)
                XCTAssertEqual(result.message, expression.message)

            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }

    func testLogoutResponseFailure() throws {
        let fakeID = 0
        let fakeToken = "token"
        let expression = LogoutResponse(result: 0, message: "Пользователь с ID = 0 не найден или Token устарел")

        auth.logout(id: fakeID, token: fakeToken) { response in
            switch response.result {
            case .success(let result):
                XCTAssertEqual(result.result, expression.result)
                XCTAssertEqual(result.message, expression.message)

            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
}
