//
//  UserResponseCodableTests.swift
//  GBShopTests
//
//  Created by Владимир on 06.12.2021.
//

import XCTest
import Alamofire
@testable import GBShop

class UserResponseCodableTests: XCTestCase {

    let request = RequestFactory().makeUserRequestFactory()
    let expectation = XCTestExpectation(description: "Download https://salty-springs-77873.herokuapp.com/")

    
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}

    
    // MARK: - Change User Data
    //
    let tokenStub: String = "13AA24D9-ECF1-401A-8F32-B05EBC7E8E38"
    let userChangeDataStub: User = User(id: 2,
                                        login: "Queen",
                                        firstName: "Маша",
                                        lastName: "Петрова",
                                        email: "petrova@mail.ru",
                                        gender: "w",
                                        creditCard: "5555-6666-7777-8888")
    
    func testChangeUserDataResponseSuccess() throws {
        let expression = UserDataChangeResponse(result: 1, message: "Данные пользоватедя успешно изменены", user: userChangeDataStub)
        
        request.change(user: userChangeDataStub, token: tokenStub) { response in
            switch response.result {
            case .success(let result):
                XCTAssertEqual(result.result, expression.result)
                XCTAssertEqual(result.message, expression.message)
                XCTAssertEqual(result.user, expression.user)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }

    
    // MARK: - Register User
    //
    let passwordStub: String = "UserPassword"
    let userRegisterStub: User = User(id: 3,
                                      login: "King",
                                      firstName: "Дима",
                                      lastName: "Сидоров",
                                      email: "sidorov@mail.ru",
                                      gender: "m",
                                      creditCard: "9876-5432-1000-0000")

    func testUserRegisterResponseSuccess() throws {
        let expression = UserRegisterResponse(result: 1, message: "Вы успешно зарегистрировались")
        
        request.register(user: userRegisterStub, password: passwordStub) { response in
            switch response.result {
            case .success(let result):
                XCTAssertEqual(result.result, expression.result)
                XCTAssertEqual(result.message, expression.message)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.wait(for: [self.expectation], timeout: 10.0)
        }
    }
}
