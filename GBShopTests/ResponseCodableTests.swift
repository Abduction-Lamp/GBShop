//
//  ResponseCodableTests.swift
//  GBShopTests
//
//  Created by Владимир on 05.12.2021.
//

import XCTest
import Alamofire
@testable import GBShop

class ResponseCodableTests: XCTestCase {

    let userStub: Profile = Profile(id: 123,
                                    login: "Somebody",
                                    email: "some@some.ru",
                                    gender: "m",
                                    creditCard: "9872389-2424-234224-234",
                                    bio: "This is good! I think I will switch to another language")
    let expressionLoginResultStub: LoginResult = LoginResult(result: 1,
                                                             user: User(id: 123, login: "geekbrains", name: "John", lastname: "Doe"))
    let expressionLogoutResultStub: LogoutResult = LogoutResult(result: 1)
    let expressionChangeUserResultStub: ChangeUserResult = ChangeUserResult(result: 1)
    let expressionRegisterResultStub: RegisterResult = RegisterResult(result: 1, userMessage: "Регистрация прошла успешно!")
    
    
    let authRequest = RequestFactory().makeAuthRequestFatory()
    let userDataRequest = RequestFactory().makeUserRequestFactory()
    
    let expectation = XCTestExpectation(description: "Download https://raw.githubusercontent.com/GeekBrainsTutorial/online-store-api/master/responses/")
    
    
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}

    
    func testLoginResult() throws {
        authRequest.login(userName: "Somebody", password: "mypassword") { result in
            switch result.result {
            case .success(let login):
                XCTAssertEqual(login.result, self.expressionLoginResultStub.result)
                XCTAssertEqual(login.user.id, self.expressionLoginResultStub.user.id)
                XCTAssertEqual(login.user.login, self.expressionLoginResultStub.user.login)
                XCTAssertEqual(login.user.name, self.expressionLoginResultStub.user.name)
                XCTAssertEqual(login.user.lastname, self.expressionLoginResultStub.user.lastname)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
    
    func testLogoutResult() throws {
        authRequest.logout(userID: 123) { response in
            switch response.result {
            case .success(let result):
                XCTAssertEqual(result.result, self.expressionLogoutResultStub.result)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
    
    func testChangeUserDataResult() throws {
        userDataRequest.change(user: userStub, password: "mypassword") { response in
            switch response.result {
            case .success(let result):
                XCTAssertEqual(result.result, self.expressionChangeUserResultStub.result)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }

    func testRegisterResult() throws {
        userDataRequest.register(user: userStub, password: "mypassword") { response in
            switch response.result {
            case .success(let result):
                XCTAssertEqual(result.result, self.expressionRegisterResultStub.result)
                XCTAssertEqual(result.userMessage, self.expressionRegisterResultStub.userMessage)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
}
