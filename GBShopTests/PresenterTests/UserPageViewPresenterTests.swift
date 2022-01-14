//
//  UserPageViewPresenterTests.swift
//  GBShopTests
//
//  Created by Владимир on 23.12.2021.
//

import XCTest
import Alamofire
@testable import GBShop

class MockUserPageView: UIViewController, UserPageViewProtocol {
    var expectation = XCTestExpectation(description: "[ TEST MockUserPageView ]")
    
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
    
    var messageSetUserData: String?
    func setUserData(firstName: String, lastName: String, gender: Int, email: String, creditCard: String, login: String, password: String) {
        messageSetUserData = "success"
        self.expectation.fulfill()
    }
    
    var messageDidChangeUserData: String?
    func didChangeUserData() {
        messageDidChangeUserData = "success"
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
class UserPageViewPresenterTests: XCTestCase {

    let fake = FakeData()
    
    var router: MockRouter!
    var view: MockUserPageView!
    var network: MockNetworkRequest!
    var presenter: UserPageViewPresenter!

    var request = RequestFactory()
    
    override func setUpWithError() throws {
        router = MockRouter()
        view = MockUserPageView()
        network = MockNetworkRequest()

        presenter = UserPageViewPresenter(router: router, view: view, network: network, user: fake.user, token: fake.token)
    }

    override func tearDownWithError() throws {
        view = nil
        network = nil
        router = nil
        presenter = nil
    }
}

extension UserPageViewPresenterTests {
    
    func testIsNotNill() throws {
        XCTAssertNotNil(view, "View component is not nil")
        XCTAssertNotNil(network, "Network component is not nil")
        XCTAssertNotNil(router, "Router component is not nil")
        XCTAssertNotNil(presenter, "Presenter component is not nil")
    }
    
    func testUserPageViewPresenterLogout() throws {
        presenter.logout()
        wait(for: [self.router.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetUserData, "success") // При создании presenter вызываеться SetUserData
        XCTAssertEqual(view.messageDidChangeUserData, nil)
        
        XCTAssertTrue(view.showFlag)
        XCTAssertTrue(view.hideFlag)
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messagePushRegistration, nil)
        XCTAssertEqual(router.messagePushUserPage, nil)
        XCTAssertEqual(router.messagePushCatalog, nil)
        XCTAssertEqual(router.messagePopToCatalogWithUser, nil)
        XCTAssertEqual(router.messagePopToCatalogWithCart, nil)
        XCTAssertEqual(router.messagePushProduct, nil)
        XCTAssertEqual(router.messagePushCart, nil)
        XCTAssertEqual(router.messagePopToBackFromCart, nil)
        XCTAssertEqual(router.messageRoot, "success")
        
    }
    
    func testUserPageViewPresenterGetUserData() throws {
        presenter.getUserData()
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetUserData, "success")
        XCTAssertEqual(view.messageDidChangeUserData, nil)
        
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
    
    func testUserPageViewPresenterChangeUserData() throws {
        presenter.user = fake.user
        presenter.changeUserData(firstName: fake.user.firstName,
                                 lastName: fake.user.lastName,
                                 gender: 0, 
                                 email: fake.user.email,
                                 creditCard: fake.user.creditCard,
                                 login: fake.user.login,
                                 password: fake.user.password)
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetUserData, "success")
        XCTAssertEqual(view.messageDidChangeUserData, "success")
        
        XCTAssertTrue(view.showFlag)
        XCTAssertTrue(view.hideFlag)
        
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
    
    func testUserPageViewPresenterChangeUserDataError() throws {
        presenter.changeUserData(firstName: "firstName",
                                 lastName: "lastName",
                                 gender: 1,
                                 email: "email@email.ru",
                                 creditCard: "1111-1111-1111-1111",
                                 login: "login",
                                 password: "password")
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, "error")
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetUserData, "success")
        XCTAssertEqual(view.messageDidChangeUserData, nil)
        
        XCTAssertTrue(view.showFlag)
        XCTAssertTrue(view.hideFlag)
        
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
    
    func testUserPageViewPresenterBackToCatalog() {
        presenter.user = fake.user
        presenter.backToCatalog()
        wait(for: [self.router.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetUserData, nil)
        XCTAssertEqual(view.messageDidChangeUserData, nil)
        
        XCTAssertFalse(view.showFlag)
        XCTAssertFalse(view.hideFlag)
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messagePushRegistration, nil)
        XCTAssertEqual(router.messagePushUserPage, nil)
        XCTAssertEqual(router.messagePushCatalog, nil)
        XCTAssertEqual(router.messagePopToCatalogWithUser, "success")
        XCTAssertEqual(router.messagePopToCatalogWithCart, nil)
        XCTAssertEqual(router.messagePushProduct, nil)
        XCTAssertEqual(router.messagePushCart, nil)
        XCTAssertEqual(router.messagePopToBackFromCart, nil)
        XCTAssertEqual(router.messageRoot, nil)
    }
}
