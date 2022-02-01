//
//  CartViewPresenterTests.swift
//  GBShopTests
//
//  Created by Владимир on 17.01.2022.
//

import XCTest
import Alamofire
@testable import GBShop

// MARK: - Mock Entity
//
class MockCartView: UIViewController, CartViewProtocol {
    
    let fake = FakeData()
    
    var expectation = XCTestExpectation(description: "[ TEST MockProductView ]")
//    var expectationSetReview = XCTestExpectation(description: "[ TEST MockProductView SetReview()]")
    
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
    
    var messageUpdataCart: String?
    func updataCart() {
        messageUpdataCart = "success"
        self.expectation.fulfill()
    }
    
    var messageUpdataCartWithIndex: Int?
    func updataCart(index: Int) {
        messageUpdataCartWithIndex = index
        self.expectation.fulfill()
    }
    
}

class CartViewPresenterTests: XCTestCase {

    let fake = FakeData()
    
    var router: MockRouter!
    var view: MockCartView!
    var network: RequestFactoryProtocol!
    var presenter: CartViewPresenter!
    
    override func setUpWithError() throws {
        router = MockRouter()
        view = MockCartView()
        network = MockNetworkRequest()
        
        presenter = CartViewPresenter(router: router,
                                      view: view,
                                      network: network,
                                      user: fake.user,
                                      token: fake.token,
                                      cart: fake.cart)
    }

    override func tearDownWithError() throws {
        router = nil
        view = nil
        network = nil
        presenter = nil
    }

    func testIsNotNill() throws {
        XCTAssertNotNil(view, "View component is not nil")
        XCTAssertNotNil(network, "Network component is not nil")
        XCTAssertNotNil(router, "Router component is not nil")
        XCTAssertNotNil(presenter, "Presenter component is not nil")
        XCTAssertNotNil(presenter.cart, "Cart at to Presenter component is not nil")
    }
    
    func testCartViewPresenter() throws {
        XCTAssertEqual(presenter.cart, fake.cart)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageUpdataCart, nil)
        XCTAssertEqual(view.messageUpdataCartWithIndex, nil)
        
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
    
    func testCartViewPresenterAdd() throws {

        presenter.addProductToCart(index: 1)
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(presenter.cart, fake.cartPlusOneProduct)

        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageUpdataCart, nil)
        XCTAssertEqual(view.messageUpdataCartWithIndex, 1)

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
    
    func testCartViewPresenterAddFailure() throws {

        presenter.addProductToCart(index: 2)
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(presenter.cart, fake.cart)

        XCTAssertEqual(view.error, nil)
        let message = NSLocalizedString("CartView.Alert.SomethingWenWrong.Text", comment: "")
        XCTAssertEqual(view.message, message)
        XCTAssertEqual(view.messageUpdataCart, nil)
        XCTAssertEqual(view.messageUpdataCartWithIndex, nil)

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
    
    func testCartViewPresenterAddFailureMore() throws {

        presenter.addProductToCart(index: 41)
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(presenter.cart, fake.cart)

        XCTAssertEqual(view.error, nil)
        let message = NSLocalizedString("CartView.Alert.SomethingWenWrong.Text", comment: "")
        XCTAssertEqual(view.message, message)
        XCTAssertEqual(view.messageUpdataCart, nil)
        XCTAssertEqual(view.messageUpdataCartWithIndex, nil)

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
    
    func testCartViewPresenterDelete() throws {

        presenter.removeProductFromCart(index: 1)
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(presenter.cart, fake.cartMinusOneProduct)

        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageUpdataCart, nil)
        XCTAssertEqual(view.messageUpdataCartWithIndex, 1)

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
    
    func testCartViewPresenterDeleteFailure() throws {

        presenter.removeProductFromCart(index: 2)
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(presenter.cart, fake.cart)

        XCTAssertEqual(view.error, nil)
        let message = NSLocalizedString("CartView.Alert.SomethingWenWrong.Text", comment: "")
        XCTAssertEqual(view.message, message)
        XCTAssertEqual(view.messageUpdataCart, nil)
        XCTAssertEqual(view.messageUpdataCartWithIndex, nil)

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
    
    func testCartViewPresenterDeleteFailureMore() throws {

        presenter.removeProductFromCart(index: 222)
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(presenter.cart, fake.cart)

        XCTAssertEqual(view.error, nil)
        let message = NSLocalizedString("CartView.Alert.SomethingWenWrong.Text", comment: "")
        XCTAssertEqual(view.message, message)
        XCTAssertEqual(view.messageUpdataCart, nil)
        XCTAssertEqual(view.messageUpdataCartWithIndex, nil)

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
    
    func testCartViewPresenterDeleteItem() throws {

        presenter.removeItemFromCart(index: 1)
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(presenter.cart, fake.cartMinusOneProduct)

        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageUpdataCart, "success")
        XCTAssertEqual(view.messageUpdataCartWithIndex, nil)

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
    
    func testCartViewPresenterDeleteItemFailure() throws {

        presenter.removeItemFromCart(index: 2)
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(presenter.cart, fake.cart)

        XCTAssertEqual(view.error, nil)
        let message = NSLocalizedString("CartView.Alert.SomethingWenWrong.Text", comment: "")
        XCTAssertEqual(view.message, message)
        XCTAssertEqual(view.messageUpdataCart, nil)
        XCTAssertEqual(view.messageUpdataCartWithIndex, nil)

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
    
    func testCartViewPresenterDeleteItemFailureMore() throws {

        presenter.removeItemFromCart(index: 222)
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(presenter.cart, fake.cart)

        XCTAssertEqual(view.error, nil)
        let message = NSLocalizedString("CartView.Alert.SomethingWenWrong.Text", comment: "")
        XCTAssertEqual(view.message, message)
        XCTAssertEqual(view.messageUpdataCart, nil)
        XCTAssertEqual(view.messageUpdataCartWithIndex, nil)

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
    
    func testCartViewPresenterDeleteAll() throws {

        presenter.removeAll()
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(presenter.cart, Cart())

        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageUpdataCart, "success")
        XCTAssertEqual(view.messageUpdataCartWithIndex, nil)

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
    
    func testCartViewPresenterBuy() throws {

        presenter.buy()
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(presenter.cart, Cart())

        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, "success")
        XCTAssertEqual(view.messageUpdataCart, "success")
        XCTAssertEqual(view.messageUpdataCartWithIndex, nil)

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
    
    func testCartViewPresenterFetchCart() throws {

        presenter.fetchCart()
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(presenter.cart, fake.cart)

        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageUpdataCart, "success")
        XCTAssertEqual(view.messageUpdataCartWithIndex, nil)

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
    
    func testCartViewPresenterBackTo() throws {

        presenter.backTo()
        wait(for: [self.router.expectation], timeout: 2.0)

        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageUpdataCart, nil)
        XCTAssertEqual(view.messageUpdataCartWithIndex, nil)

        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messagePushRegistration, nil)
        XCTAssertEqual(router.messagePushUserPage, nil)
        XCTAssertEqual(router.messagePushCatalog, nil)
        XCTAssertEqual(router.messagePopToCatalogWithUser, nil)
        XCTAssertEqual(router.messagePopToCatalogWithCart, nil)
        XCTAssertEqual(router.messagePushProduct, nil)
        XCTAssertEqual(router.messagePushCart, nil)
        XCTAssertEqual(router.messagePopToBackFromCart, "success")
        XCTAssertEqual(router.messageRoot, nil)
    }
}
