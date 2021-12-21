//
//  LoginViewPresenterTest.swift
//  GBShopTests
//
//  Created by Владимир on 20.12.2021.
//

import XCTest
@testable import GBShop

// MARK: - Mock Entity
//
class MockLoginView: LoginViewProtocol {
    
    let expectation = XCTestExpectation(description: "Download https://salty-springs-77873.herokuapp.com/")
    
    var error: String?
    func showAlertRequestError(error: Error) {
        self.error = "error"
        self.expectation.fulfill()
    }
    
    var message: String?
    func showAlertAuthError(message: String) {
        self.message = message
        self.expectation.fulfill()
    }
    
    var main: String?
    func presentMainView() {
        main = "success"
        self.expectation.fulfill()
    }
    
    var registration: String?
    func presentRegistrationView() {
        registration = "success"
        self.expectation.fulfill()
    }
}

// MARK: - TESTS
//
class LoginViewPresenterTest: XCTestCase {

    var view: MockLoginView!
    var network: AuthRequestFactory!
    var presenter: LoginViewPresenter!
    
    var request = RequestFactory()
    
    override func setUpWithError() throws {
        view = MockLoginView()
        network = request.makeAuthRequestFatory()
        presenter = LoginViewPresenter(view: view, network: network)
    }

    override func tearDownWithError() throws {
        view = nil
        network = nil
        presenter = nil
    }
}

extension LoginViewPresenterTest {
    
    func testIsNotNill() throws {
        XCTAssertNotNil(view, "View component is not nil")
        XCTAssertNotNil(network, "Network component is not nil")
        XCTAssertNotNil(presenter, "Presenter component is not nil")
    }
    
    func testViewValidationPresentMainView() throws {
        self.presenter.auth(login: "Username", password: "UserPassword")
        wait(for: [self.view.expectation], timeout: 10.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.main, "success")
        XCTAssertEqual(view.registration, nil)
    }
    
    func testViewValidationshowAlertRequestError() throws {
        self.presenter.auth(login: "1", password: "1")
        wait(for: [self.view.expectation], timeout: 10.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, "Неверный логин или пароль")
        XCTAssertEqual(view.main, nil)
        XCTAssertEqual(view.registration, nil)
    }
}
