//
//  CatalogViewPresenterTests.swift
//  GBShopTests
//
//  Created by Владимир on 27.12.2021.
//

import XCTest
import Alamofire
@testable import GBShop

// MARK: - Mock Entity
//
class MockCatalogView: UIViewController, CatalogViewProtocol {
    var presenret: CatalogViewPresenterProtocol?
    
    let fake = FakeData()
    var expectation = XCTestExpectation(description: "[ TEST MockCatalogView ]")
    
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
    
    var messageSetCatalog: String?
    func setCatalog() {
        self.messageSetCatalog = "success"
        self.expectation.fulfill()
    }
    
    var messageUpdateCartIndicator: Int?
    func updateCartIndicator(count: Int) {
        messageUpdateCartIndicator = count
        self.expectation.fulfill()
    }
    
    var messageUpdateUserDataInPresenter: String?
    func updateUserDataInPresenter(user: User, token: String) {
        if (user == fake.user) && (token == fake.token) {
            messageUpdateUserDataInPresenter = "success"
        }
        self.expectation.fulfill()
    }
}

// MARK: - TESTS
//
class CatalogViewPresenterTests: XCTestCase {
    
    let fake = FakeData()

    var router: MockRouter!
    var view: MockCatalogView!
    var network: RequestFactoryProtocol!
    var presenter: CatalogViewPresenterProtocol!
    
//    var request = RequestFactory()
    
    override func setUpWithError() throws {
        router = MockRouter()
        view = MockCatalogView()
        network = MockNetworkRequest()

        presenter = CatalogViewPresenter(router: router, view: view, network: network, user: fake.user, token: fake.token)
        view.presenret = presenter
    }

    override func tearDownWithError() throws {
        view = nil
        network = nil
        router = nil
        presenter = nil
    }
}

extension CatalogViewPresenterTests {
    
    func testIsNotNill() throws {
        XCTAssertNotNil(view, "View component is not nil")
        XCTAssertNotNil(network, "Network component is not nil")
        XCTAssertNotNil(router, "Router component is not nil")
        XCTAssertNotNil(presenter, "Presenter component is not nil")
    }
    
    func testCatalogViewPresenterInit() throws {
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetCatalog, "success")
        XCTAssertEqual(view.messageUpdateCartIndicator, 3)
        XCTAssertEqual(view.messageUpdateUserDataInPresenter, nil)
        
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
    
    func testCatalogViewPresenterAddCartSeccess() throws {
        presenter.addToCart(productId: 1)
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetCatalog, "success")
        XCTAssertEqual(view.messageUpdateCartIndicator, 4)
        XCTAssertEqual(view.messageUpdateUserDataInPresenter, nil)
        
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
    
    func testCatalogViewPresenterAddCartError() throws {
        presenter.addToCart(productId: -1)
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, "error")
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetCatalog, "success")
        XCTAssertEqual(view.messageUpdateCartIndicator, 3)
        XCTAssertEqual(view.messageUpdateUserDataInPresenter, nil)
        
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
    
    func testUpdateUserDataSeccess() throws {
        presenter.updateUserData(user: fake.user, token: fake.token)
        view.updateUserDataInPresenter(user: fake.user, token: fake.token)
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetCatalog, nil)
        XCTAssertEqual(view.messageUpdateCartIndicator, nil)
        XCTAssertEqual(view.messageUpdateUserDataInPresenter, "success")
        
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
    
    func testUpdateCartSeccess() throws {
        presenter.updateCart(cart: fake.cart)
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetCatalog, nil)
        XCTAssertEqual(view.messageUpdateCartIndicator, 3)
        XCTAssertEqual(view.messageUpdateUserDataInPresenter, nil)
        
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
    
    func testGoToUserPageView() throws {
        presenter.goToUserPageView()
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetCatalog, "success")
        XCTAssertEqual(view.messageUpdateCartIndicator, 3)
        XCTAssertEqual(view.messageUpdateUserDataInPresenter, nil)
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messagePushRegistration, nil)
        XCTAssertEqual(router.messagePushUserPage, "success")
        XCTAssertEqual(router.messagePushCatalog, nil)
        XCTAssertEqual(router.messagePopToCatalogWithUser, nil)
        XCTAssertEqual(router.messagePopToCatalogWithCart, nil)
        XCTAssertEqual(router.messagePushProduct, nil)
        XCTAssertEqual(router.messagePushCart, nil)
        XCTAssertEqual(router.messagePopToBackFromCart, nil)
        XCTAssertEqual(router.messageRoot, nil)
    }
    
    func testGoToProductView() throws {
        wait(for: [self.view.expectation], timeout: 2.0)
        presenter.goToProductView(id: 1)
        wait(for: [self.router.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetCatalog, "success")
        XCTAssertEqual(view.messageUpdateCartIndicator, 3)
        XCTAssertEqual(view.messageUpdateUserDataInPresenter, nil)
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messagePushRegistration, nil)
        XCTAssertEqual(router.messagePushUserPage, nil)
        XCTAssertEqual(router.messagePushCatalog, nil)
        XCTAssertEqual(router.messagePopToCatalogWithUser, nil)
        XCTAssertEqual(router.messagePopToCatalogWithCart, nil)
        XCTAssertEqual(router.messagePushProduct, "success")
        XCTAssertEqual(router.messagePushCart, nil)
        XCTAssertEqual(router.messagePopToBackFromCart, nil)
        XCTAssertEqual(router.messageRoot, nil)
    }
    
    func testGoToCartView() throws {
        presenter.goToCartView()
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetCatalog, "success")
        XCTAssertEqual(view.messageUpdateCartIndicator, 3)
        XCTAssertEqual(view.messageUpdateUserDataInPresenter, nil)
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messagePushRegistration, nil)
        XCTAssertEqual(router.messagePushUserPage, nil)
        XCTAssertEqual(router.messagePushCatalog, nil)
        XCTAssertEqual(router.messagePopToCatalogWithUser, nil)
        XCTAssertEqual(router.messagePopToCatalogWithCart, nil)
        XCTAssertEqual(router.messagePushProduct, nil)
        XCTAssertEqual(router.messagePushCart, "success")
        XCTAssertEqual(router.messagePopToBackFromCart, nil)
        XCTAssertEqual(router.messageRoot, nil)
    }
}
