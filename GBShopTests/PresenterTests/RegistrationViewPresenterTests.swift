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
    var expectation = XCTestExpectation(description: "[ TEST MockRegistrationView ]")
    
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
class RegistrationViewPresenterTests: XCTestCase {

    let fake = FakeData()
    
    var router: MockRouter!
    var view: MockRegistrationView!
    var network: UserRequestFactory!
    var presenter: RegistrationViewPresenter!

    var request = RequestFactory()
    
    //
    var initialStateEexpectation: XCTestExpectation!
    var expectation: XCTestExpectation!
    
    //
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        router = MockRouter()
        view = MockRegistrationView()
        network = MockNetworkUserRequest()

        presenter = RegistrationViewPresenter(router: router, view: view, network: network)
        
        initialStateEexpectation = XCTestExpectation(description: "[ INITIAL STATE MOCK SERVER ]")
        expectation = XCTestExpectation(description: "[ Test ]")
        
        initialStateServer()
    }

    override func tearDownWithError() throws {
        view = nil
        network = nil
        router = nil
        presenter = nil
        
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

extension RegistrationViewPresenterTests {
    
    func testIsNotNill() throws {
        XCTAssertNotNil(view, "View component is not nil")
        XCTAssertNotNil(network, "Network component is not nil")
        XCTAssertNotNil(router, "Router component is not nil")
        XCTAssertNotNil(presenter, "Presenter component is not nil")
    }
    
    func testRegistrationViewPresenterRegistrationSuccess() throws {
        
        presenter.registration(firstName: fake.user.firstName,
                               lastName: fake.user.lastName,
                               gender: 0,
                               email: fake.user.email,
                               creditCard: fake.user.creditCard,
                               login: fake.user.login,
                               password: fake.user.password)
        wait(for: [self.router.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        
        XCTAssertTrue(view.showFlag)
        XCTAssertTrue(view.hideFlag)
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messagePushRegistration, nil)
        XCTAssertEqual(router.messagePushUserPage, nil)
        XCTAssertEqual(router.messagePushCatalog, "success")
        XCTAssertEqual(router.messagePopToCatalogWithUser, nil)
        XCTAssertEqual(router.messagePopToCatalogWithCart, nil)
        XCTAssertEqual(router.messagePushProduct, nil)
        XCTAssertEqual(router.messagePushCart, nil)
        XCTAssertEqual(router.messagePopToBackFromCart, nil)
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
        let message = NSLocalizedString("UserPageView.Alert.WrongEmailFormat", comment: "")
        XCTAssertEqual(view.message, message)
        
        XCTAssertFalse(view.showFlag)
        XCTAssertFalse(view.hideFlag)
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messagePushRegistration, nil)
        XCTAssertEqual(router.messagePushUserPage, nil)
        XCTAssertEqual(router.messagePushCatalog, nil)
        XCTAssertEqual(router.messagePopToCatalogWithUser, nil)
        XCTAssertEqual(router.messagePopToCatalogWithCart, nil)
        XCTAssertEqual(router.messagePushProduct, nil)
        XCTAssertEqual(router.messagePushCart, nil)
        XCTAssertEqual(router.messagePopToBackFromCart, nil)
        XCTAssertEqual(router.messageRoot, nil)
    }
}
