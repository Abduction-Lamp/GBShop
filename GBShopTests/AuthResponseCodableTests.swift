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

    let authRequest = RequestFactory().makeAuthRequestFatory()
    
    let expressionLogoutResultStub: LogoutResult = LogoutResult(result: 1)
    let expressionLoginResultStub: LoginResult = LoginResult(result: 1,
                                                             user: User(id: 123,
                                                                        login: "geekbrains",
                                                                        name: "John",
                                                                        lastname: "Doe"))

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
}
