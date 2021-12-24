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

    let tokenStub: String = "13AA24D9-ECF1-401A-8F32-B05EBC7E8E38"
    
    var request: UserRequestFactory!
    var initialStateEexpectation: XCTestExpectation!
    var expectation: XCTestExpectation!
    
    //
    //
    override func setUpWithError() throws {
        try super.setUpWithError()
        request = RequestFactory().makeUserRequestFactory()
        initialStateEexpectation = XCTestExpectation(description: "[ INITIAL STATE MOCK SERVER ]")
        expectation = XCTestExpectation(description: "[ Test ]")
        initialStateServer()
    }
    
    override func tearDownWithError() throws {
        request = nil
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

// MARK: - Change User Data
//
extension UserResponseCodableTests {

    func testChangeUserDataResponseSuccess() throws {
        let userStub = User(id: 2,
                            firstName: "Маша",
                            lastName: "Петрова",
                            gender: "w",
                            email: "petrova@mail.ru",
                            creditCard: "5555-6666-7777-8888",
                            login: "Queen",
                            password: "UserPassword")
        let expression = UserDataChangeResponse(result: 1,
                                                message: "Данные пользоватедя успешно изменены",
                                                user: userStub)

        request.change(user: userStub, token: tokenStub) { response in
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

    func testChangeUserDataResponseFailureID() throws {
        let expression = UserDataChangeResponse(result: 0,
                                                message: "Пользователь с ID = 3 не найден",
                                                user: nil)
        let userStub = User(id: 3,
                            firstName: "Маша",
                            lastName: "Петрова",
                            gender: "w",
                            email: "petrova@mail.ru",
                            creditCard: "5555-6666-7777-8888",
                            login: "Queen1",
                            password: "UserPassword")

        request.change(user: userStub, token: tokenStub) { response in
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

    func testChangeUserDataResponseFailureLogin() throws {
        let expression = UserDataChangeResponse(result: 0,
                                                message: "Пользователь с Login = Username уже существует",
                                                user: nil)
        let userStub = User(id: 2,
                            firstName: "Маша",
                            lastName: "Петрова",
                            gender: "w",
                            email: "petrova@mail.ru",
                            creditCard: "5555-6666-7777-8888",
                            login: "Username",
                            password: "UserPassword")

        request.change(user: userStub, token: tokenStub) { response in
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

    func testChangeUserDataResponseFailureEmail() throws {
        let expression = UserDataChangeResponse(result: 0,
                                                message: "Пользователь с E-mail = ivanov@mail.ru уже существует",
                                                user: nil)
        let userStub = User(id: 2,
                            firstName: "Маша",
                            lastName: "Петрова",
                            gender: "w",
                            email: "ivanov@mail.ru",
                            creditCard: "5555-6666-7777-8888",
                            login: "Queen",
                            password: "UserPassword")

        request.change(user: userStub, token: tokenStub) { response in
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

    func testChangeUserDataResponseFailureEmailFake() throws {
        let expression = UserDataChangeResponse(result: 0,
                                                message: "Не верный формат e-mail",
                                                user: nil)
        let userStub = User(id: 2,
                            firstName: "Маша",
                            lastName: "Петрова",
                            gender: "w",
                            email: "petrova",
                            creditCard: "5555-6666-7777-8888",
                            login: "Queen",
                            password: "UserPassword")

        request.change(user: userStub, token: tokenStub) { response in
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

    func testChangeUserDataResponseFailureCreditCardFake() throws {
        let expression = UserDataChangeResponse(result: 0,
                                                message: "Неверный формат кредитной карты",
                                                user: nil)
        let userStub = User(id: 2,
                            firstName: "Маша",
                            lastName: "Петрова",
                            gender: "w",
                            email: "petrova@mail.ru",
                            creditCard: "5555-6666-7777-888",
                            login: "Queen",
                            password: "UserPassword")

        request.change(user: userStub, token: tokenStub) { response in
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

    func testChangeUserDataResponseFailureTokenFake() throws {
        let expression = UserDataChangeResponse(result: 0,
                                                message: "Token усторел",
                                                user: nil)
        let userStub = User(id: 2,
                            firstName: "Маша",
                            lastName: "Петрова",
                            gender: "w",
                            email: "petrova@mail.ru",
                            creditCard: "5555-6666-7777-8888",
                            login: "Queen",
                            password: "UserPassword")

        request.change(user: userStub, token: "token") { response in
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
}

// MARK: - Register User
//
extension UserResponseCodableTests {

    func testUserRegisterResponseSuccess() throws {
        let userStub = User(id: 3,
                            firstName: "Дима",
                            lastName: "Сидоров",
                            gender: "m",
                            email: "sidorov@mail.ru",
                            creditCard: "9876-5432-1000-0000",
                            login: "King",
                            password: "UserPassword")
        lazy var expression = UserRegisterResponse(result: 1, message: "Вы успешно зарегистрировались", user: userStub, token: nil)
        
        request.register(user: userStub) { response in
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

    func testUserRegisterResponseFailureLogin() throws {
        let expression = UserRegisterResponse(result: 0, message: "Пользователь с Login = Username уже существует", user: nil, token: nil)
        let userStub = User(id: 3,
                            firstName: "Дима",
                            lastName: "Сидоров",
                            gender: "m",
                            email: "sidorov@mail.ru",
                            creditCard: "1123-5813-2134-5589",
                            login: "Username",
                            password: "UserPassword")

        request.register(user: userStub) { response in
            switch response.result {
            case .success(let result):
                XCTAssertEqual(result.result, expression.result)
                XCTAssertEqual(result.message, expression.message)
                XCTAssertEqual(result.user, expression.user)
                XCTAssertEqual(result.token, expression.token)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        self.wait(for: [self.expectation], timeout: 10.0)
    }

    func testUserRegisterResponseFailureEmail() throws {
        let expression = UserRegisterResponse(result: 0,
                                              message: "Пользователь с e-mail = petrova@mail.ru уже существует",
                                              user: nil, token: nil)
        let userStub = User(id: 3,
                            firstName: "Дима",
                            lastName: "Сидоров",
                            gender: "m",
                            email: "petrova@mail.ru",
                            creditCard: "1123-5813-2134-5589",
                            login: "King",
                            password: "UserPassword")

        request.register(user: userStub) { response in
            switch response.result {
            case .success(let result):
                XCTAssertEqual(result.result, expression.result)
                XCTAssertEqual(result.message, expression.message)
                XCTAssertEqual(result.user, expression.user)
                XCTAssertEqual(result.token, expression.token)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        self.wait(for: [self.expectation], timeout: 10.0)
    }

    func testUserRegisterResponseFailureEmailFake() throws {
        let expression = UserRegisterResponse(result: 0, message: "Не верный формат e-mail", user: nil, token: nil)
        let userStub = User(id: 3,
                            firstName: "Дима",
                            lastName: "Сидоров",
                            gender: "m",
                            email: "sidorov@mail",
                            creditCard: "1123-5813-2134-5589",
                            login: "King",
                            password: "UserPassword")

        request.register(user: userStub) { response in
            switch response.result {
            case .success(let result):
                XCTAssertEqual(result.result, expression.result)
                XCTAssertEqual(result.message, expression.message)
                XCTAssertEqual(result.user, expression.user)
                XCTAssertEqual(result.token, expression.token)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        self.wait(for: [self.expectation], timeout: 10.0)
    }

    func testUserRegisterResponseFailureCreditCard() throws {
        let expression = UserRegisterResponse(result: 0, message: "Неверный формат кредитной карты", user: nil, token: nil)
        let userStub = User(id: 3,
                            firstName: "Дима",
                            lastName: "Сидоров",
                            gender: "m",
                            email: "sidorov@mail.ru",
                            creditCard: "1123-5813-2134-5589-1",
                            login: "King",
                            password: "UserPassword")

        request.register(user: userStub) { response in
            switch response.result {
            case .success(let result):
                XCTAssertEqual(result.result, expression.result)
                XCTAssertEqual(result.message, expression.message)
                XCTAssertEqual(result.user, expression.user)
                XCTAssertEqual(result.token, expression.token)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        self.wait(for: [self.expectation], timeout: 10.0)
    }

    func testUserRegisterResponseFailurePassword() throws {
        let expression = UserRegisterResponse(result: 0, message: "Слишком короткий пороль (меньше 7 сиволов)", user: nil, token: nil)
        let userStub = User(id: 3,
                            firstName: "Дима",
                            lastName: "Сидоров",
                            gender: "m",
                            email: "sidorov@mail.ru",
                            creditCard: "1123-5813-2134-5589",
                            login: "King",
                            password: "123")

        request.register(user: userStub) { response in
            switch response.result {
            case .success(let result):
                XCTAssertEqual(result.result, expression.result)
                XCTAssertEqual(result.message, expression.message)
                XCTAssertEqual(result.user, expression.user)
                XCTAssertEqual(result.token, expression.token)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        self.wait(for: [self.expectation], timeout: 10.0)
    }
}
