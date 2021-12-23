//
//  LoginViewPresenterTest.swift
//  GBShopTests
//
//  Created by Владимир on 20.12.2021.
//

import XCTest
import Alamofire
@testable import GBShop

// MARK: - Mock Entity
//
class MockLoginView: UIViewController, LoginViewProtocol {
    var expectation = XCTestExpectation(description: "Download https://salty-springs-77873.herokuapp.com/")
    
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

// MARK: - TESTS
//
class LoginViewPresenterTest: XCTestCase {

    var router: MockRouter!
    var view: MockLoginView!
    var network: AuthRequestFactory!
    var presenter: LoginViewPresenter!

    var request = RequestFactory()
    
    override func setUpWithError() throws {
        router = MockRouter()
        view = MockLoginView()
        network = MockNetworkAuthRequest()

        presenter = LoginViewPresenter(router: router, view: view, network: network)
    }

    override func tearDownWithError() throws {
        view = nil
        network = nil
        router = nil
        presenter = nil
    }
}

extension LoginViewPresenterTest {
    
    func testIsNotNill() throws {
        XCTAssertNotNil(view, "View component is not nil")
        XCTAssertNotNil(network, "Network component is not nil")
        XCTAssertNotNil(router, "Router component is not nil")
        XCTAssertNotNil(presenter, "Presenter component is not nil")
    }
    
    func testLoginViewPresenterAuthSuccess() throws {
        presenter.auth(login: "login", password: "password")
        wait(for: [self.view.expectation], timeout: 10.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, "success")
    }
    
    func testLoginViewPresenterAuthFailure() throws {
        presenter.auth(login: "", password: "")
        wait(for: [self.view.expectation], timeout: 10.0)
        
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.error, "error")
    }
    
    func testLoginViewPresenterPushRegistration() throws {
        presenter.pushRegistrationViewController()
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messageRegistration, "success")
        XCTAssertEqual(router.messageUserPage, nil)
        XCTAssertEqual(router.messageRoot, nil)
    }
}
