//
//  RegistrationViewPresenterTests.swift
//  GBShopTests
//
//  Created by Владимир on 23.12.2021.
//

import XCTest
import Alamofire
@testable import GBShop

class MockRegistrationView: UIViewController, RegistrationViewProtocol {
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
class RegistrationViewPresenterTests: XCTestCase {

    var router: MockRouter!
    var view: MockRegistrationView!
    var network: UserRequestFactory!
    var presenter: RegistrationViewPresenter!

    var request = RequestFactory()
    
    override func setUpWithError() throws {
        router = MockRouter()
        view = MockRegistrationView()
        network = MockNetworkUserRequest()

        presenter = RegistrationViewPresenter(router: router, view: view, network: network)
    }

    override func tearDownWithError() throws {
        view = nil
        network = nil
        router = nil
        presenter = nil
    }
}

extension RegistrationViewPresenterTests {
    
    func testIsNotNill() throws {
        XCTAssertNotNil(view, "View component is not nil")
        XCTAssertNotNil(network, "Network component is not nil")
        XCTAssertNotNil(router, "Router component is not nil")
        XCTAssertNotNil(presenter, "Presenter component is not nil")
    }
    
    func testRegistrationViewPresenterRegistrationSuccess() throws {
        
        presenter.registration(firstName: "firstName",
                               lastName: "lastName",
                               gender: 0,
                               email: "email@email.ru",
                               creditCard: "1111-1111-1111-1111",
                               login: "login",
                               password: "password")
        wait(for: [self.router.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messageRegistration, nil)
        XCTAssertEqual(router.messageUserPage, "success")
        XCTAssertEqual(router.messageRoot, nil)
    }
    
    func testRegistrationViewPresenterRegistrationFailure() throws {
        
        presenter.registration(firstName: "firstName",
                               lastName: "lastName",
                               gender: 0,
                               email: "email@email",
                               creditCard: "1111-1111-1111-1111",
                               login: "login",
                               password: "password")
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, "Не верный формат E-mail")
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messageRegistration, nil)
        XCTAssertEqual(router.messageUserPage, nil)
        XCTAssertEqual(router.messageRoot, nil)
    }
}
