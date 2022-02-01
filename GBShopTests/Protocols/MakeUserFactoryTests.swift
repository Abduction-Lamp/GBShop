//
//  MakeUserFactoryTests.swift
//  GBShopTests
//
//  Created by Владимир on 25.12.2021.
//

import XCTest
@testable import GBShop

class MockView: UIViewController, AbstractViewController {
    var expectation = XCTestExpectation(description: "[ MOCK VIEW ]")
    
    var error: String?
    func showRequestErrorAlert(error: Error) {
        self.error = "error"
        self.expectation.fulfill()
    }
    var message: String?
    func showErrorAlert(message: String) {
        self.message = message
        self.expectation.fulfill()
    }
}

class Factory: MakeUserFactory { }

//
//
class MakeUserFactoryTests: XCTestCase {

    var view: MockView!
    let factory = Factory()
    let user = User(id: 0, firstName: "firstName", lastName: "lastName", gender: "m",
                    email: "email@email.ru", creditCard: "1111-2222-3333-4444", login: "login", password: "password")
    
    override func setUpWithError() throws {
        view = MockView()
    }
    override func tearDownWithError() throws {
        view = nil
    }

    func testMakeUserFactorySuccess() throws {
        let newUser = factory.makeUser(view: view,
                                       id: 0, firstName: "firstName", lastName: "lastName", gender: 0,
                                       email: "email@email.ru", creditCard: "1111-2222-3333-4444",
                                       login: "login", password: "password")
        
        XCTAssertEqual(newUser, user)
        XCTAssertNil(view.message)
        XCTAssertNil(view.error)
    }
    
    func testMakeUserFactoryFailure() throws {
        var newUser = factory.makeUser(view: view,
                                       id: 0, firstName: "", lastName: "lastName", gender: 0,
                                       email: "email@email.ru", creditCard: "1111-2222-3333-4444",
                                       login: "login", password: "password")
        XCTAssertNil(newUser)
        var message = NSLocalizedString("UserPageView.Alert.EmptyFirstNameField", comment: "")
        XCTAssertEqual(view.message, message)
        XCTAssertNil(view.error)
        
        newUser = factory.makeUser(view: view,
                                   id: 0, firstName: "firstName", lastName: "", gender: 0,
                                   email: "email@email.ru", creditCard: "1111-2222-3333-4444",
                                   login: "login", password: "password")
        XCTAssertNil(newUser)
        message = NSLocalizedString("UserPageView.Alert.EmptyLastNameField", comment: "")
        XCTAssertEqual(view.message, message)
        XCTAssertNil(view.error)
        
        newUser = factory.makeUser(view: view,
                                   id: 0, firstName: "firstName", lastName: "lastName", gender: 0,
                                   email: "", creditCard: "1111-2222-3333-4444",
                                   login: "login", password: "password")
        XCTAssertNil(newUser)
        message = NSLocalizedString("UserPageView.Alert.EmptyEmailField", comment: "")
        XCTAssertEqual(view.message, message)
        XCTAssertNil(view.error)
        
        newUser = factory.makeUser(view: view,
                                   id: 0, firstName: "firstName", lastName: "lastName", gender: 0,
                                   email: "email@email.ru", creditCard: "",
                                   login: "login", password: "password")
        XCTAssertNil(newUser)
        message = NSLocalizedString("UserPageView.Alert.EmptyCreditCardField", comment: "")
        XCTAssertEqual(view.message, message)
        XCTAssertNil(view.error)
        
        newUser = factory.makeUser(view: view,
                                   id: 0, firstName: "firstName", lastName: "lastName", gender: 0,
                                   email: "email@email.ru", creditCard: "1111-2222-3333-4444",
                                   login: "", password: "password")
        XCTAssertNil(newUser)
        message = NSLocalizedString("UserPageView.Alert.EmptyLoginField", comment: "")
        XCTAssertEqual(view.message, message)
        XCTAssertNil(view.error)
        
        newUser = factory.makeUser(view: view,
                                   id: 0, firstName: "firstName", lastName: "lastName", gender: 0,
                                   email: "email@email.ru", creditCard: "1111-2222-3333-4444",
                                   login: "login", password: "")
        XCTAssertNil(newUser)
        message = NSLocalizedString("UserPageView.Alert.EmptyPasswordField", comment: "")
        XCTAssertEqual(view.message, message)
        XCTAssertNil(view.error)
        
        newUser = factory.makeUser(view: view,
                                   id: 0, firstName: "firstName", lastName: "lastName", gender: 0,
                                   email: "email@emailru", creditCard: "1111-2222-3333-4444",
                                   login: "login", password: "password")
        XCTAssertNil(newUser)
        message = NSLocalizedString("UserPageView.Alert.WrongEmailFormat", comment: "")
        XCTAssertEqual(view.message, message)
        XCTAssertNil(view.error)
        
        newUser = factory.makeUser(view: view,
                                   id: 0, firstName: "firstName", lastName: "lastName", gender: 0,
                                   email: "email@email.ru", creditCard: "1111222233334444",
                                   login: "login", password: "password")
        XCTAssertNil(newUser)
        message = NSLocalizedString("UserPageView.Alert.WrongCreditCardFormat", comment: "")
        XCTAssertEqual(view.message, message)
        XCTAssertNil(view.error)
    }
}
