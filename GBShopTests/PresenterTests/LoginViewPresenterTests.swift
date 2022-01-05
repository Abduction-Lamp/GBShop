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
    
    var expectation = XCTestExpectation(description: "[ TEST MockLoginView ]")
    
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
    
    var showFlag = false
    func showLoadingScreen() {
        showFlag = !showFlag
    }
    
    var hideFlag = false
    func hideLoadingScreen() {
        hideFlag = !hideFlag
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
        presenter.auth(login: FakeData().user.login, password: FakeData().user.password)
        wait(for: [self.router.expectation], timeout: 10.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        
        XCTAssertTrue(view.showFlag)
        XCTAssertTrue(view.hideFlag)
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messageRegistration, nil)
        XCTAssertEqual(router.messageUserPage, nil)
        XCTAssertEqual(router.messagePushCatalog, "success")
        XCTAssertEqual(router.messagePopCatalog, nil)
        XCTAssertEqual(router.messageProduct, nil)
        XCTAssertEqual(router.messageRoot, nil)
    }
    
    func testLoginViewPresenterAuthFailure() throws {
        presenter.auth(login: "", password: "")
        wait(for: [self.view.expectation], timeout: 10.0)
        
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.error, "error")
        
        XCTAssertTrue(view.showFlag)
        XCTAssertTrue(view.hideFlag)
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messageRegistration, nil)
        XCTAssertEqual(router.messageUserPage, nil)
        XCTAssertEqual(router.messagePushCatalog, nil)
        XCTAssertEqual(router.messagePopCatalog, nil)
        XCTAssertEqual(router.messageProduct, nil)
        XCTAssertEqual(router.messageRoot, nil)

    }
    
    func testLoginViewPresenterPushRegistration() throws {
        presenter.goToRegistrationView()
             
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.error, nil)
        
        XCTAssertFalse(view.showFlag)
        XCTAssertFalse(view.hideFlag)
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messageRegistration, "success")
        XCTAssertEqual(router.messageUserPage, nil)
        XCTAssertEqual(router.messagePushCatalog, nil)
        XCTAssertEqual(router.messagePopCatalog, nil)
        XCTAssertEqual(router.messageProduct, nil)
        XCTAssertEqual(router.messageRoot, nil)

    }
}
