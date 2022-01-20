//
//  ProductViewPresenterTests.swift
//  GBShopTests
//
//  Created by Владимир on 30.12.2021.
//

import XCTest
import Alamofire
@testable import GBShop

// MARK: - Mock Entity
//
class MockProductView: UIViewController, ProductViewProtocol {

    var presenret: ProductViewPresenterProtocol?

    let fake = FakeData()
    
    var expectation = XCTestExpectation(description: "[ TEST MockProductView ]")
    var expectationSetReview = XCTestExpectation(description: "[ TEST MockProductView SetReview()]")
    
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
    
    var messageSetReview: String?
    func setReviews() {
        messageSetReview = "success"
        self.expectation.fulfill()
        self.expectationSetReview.fulfill()
    }

    var countUpdateCartIndicator: Int?
    func updateCartIndicator(count: Int) {
        self.countUpdateCartIndicator = count
        self.expectation.fulfill()
    }
}

// MARK: - TESTS
//
class ProductViewPresenterTests: XCTestCase {
    
    let fake = FakeData()
    
    var router: MockRouter!
    var view: MockProductView!
    var network: RequestFactoryProtocol!
    var presenter: ProductViewPresenter!
    var cart: Cart!
    
    override func setUpWithError() throws {
        router = MockRouter()
        view = MockProductView()
        cart = Cart()
        network = MockNetworkRequest()

        presenter = ProductViewPresenter(router: router,
                                         view: view,
                                         network: network,
                                         user: fake.user,
                                         token: fake.token,
                                         product: fake.product,
                                         cart: cart)
    }

    override func tearDownWithError() throws {
        view = nil
        network = nil
        router = nil
        presenter = nil
        cart = nil
    }

    func testIsNotNill() throws {
        XCTAssertNotNil(view, "View component is not nil")
        XCTAssertNotNil(network, "Network component is not nil")
        XCTAssertNotNil(router, "Router component is not nil")
        XCTAssertNotNil(presenter, "Presenter component is not nil")
        XCTAssertNotNil(cart, "Cart component is not nil")
    }
    
    func testProductViewPresenterGetUserInfo() throws {
        let user = presenter.getUserInfo()
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetReview, nil)
        XCTAssertEqual(user, fake.user)
        XCTAssertEqual(view.countUpdateCartIndicator, nil)
        
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
    
    func testProductViewPresenterAddToCartSuccess() throws {
        presenter.addToCart()
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetReview, nil)
        XCTAssertEqual(view.countUpdateCartIndicator, 4)
        
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
    
    func testProductViewPresenterAddToCartFailure() throws {
        presenter = ProductViewPresenter(router: router, view: view, network: network, user: fake.user, token: "token", product: fake.product, cart: fake.cart)
        presenter.addToCart()
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, "error")
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetReview, nil)
        XCTAssertEqual(view.countUpdateCartIndicator, nil)
        
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
    
    func testProductViewPresenterFetchReview() throws {
        presenter.fetchReview()
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetReview, "success")
        XCTAssertEqual(view.countUpdateCartIndicator, nil)
        
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
    
    func testProductViewPresenterFetchReviewFailure() throws {
        presenter = ProductViewPresenter(router: router, view: view, network: network, user: fake.user, token: fake.token, product: fake.product2, cart: fake.cart)
        presenter.fetchReview()
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, "error")
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetReview, nil)
        XCTAssertEqual(view.countUpdateCartIndicator, nil)
        
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
    
    func testProductViewPresenterAddReview() throws {
        presenter.addReview("test")
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetReview, "success")
        
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
    
    func testProductViewPresenterAddReviewFailure() throws {
        presenter = ProductViewPresenter(router: router, view: view, network: network, user: fake.user, token: "token", product: fake.product, cart: fake.cart)
        presenter.addReview("test")
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, "error")
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetReview, nil)
        XCTAssertEqual(view.countUpdateCartIndicator, nil)
        
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
    
    func testProductViewPresenterRemoveReview() throws {
        presenter.review = fake.reviewByProductViewModel
        presenter.removeReview(id: 3)
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetReview, "success")
        XCTAssertEqual(view.countUpdateCartIndicator, nil)
        
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
    
    func testProductViewPresenterRemoveReviewMessageId() throws {
        presenter.review = fake.reviewByProductViewModel
        presenter.removeReview(id: 1)
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, "success")
        XCTAssertEqual(view.messageSetReview, nil)
        XCTAssertEqual(view.countUpdateCartIndicator, nil)
        
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
    
    func testProductViewPresenterRemoveReviewFailure() throws {
        presenter = ProductViewPresenter(router: router, view: view, network: network, user: fake.user, token: "token", product: fake.product, cart: fake.cart)
        presenter.removeReview(id: 1)
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, "error")
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetReview, nil)
        XCTAssertEqual(view.countUpdateCartIndicator, nil)
        
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
    
    func testProductViewPresenterGetCartIndicator() throws {
        presenter.getCartIndicator()
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetReview, nil)
        XCTAssertEqual(view.countUpdateCartIndicator, 0)
        
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
    
    func testProductViewPresenterUpdatatCart() throws {
        presenter.updateCart(cart: fake.cart)
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetReview, nil)
        XCTAssertEqual(view.countUpdateCartIndicator, 3)
        
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
    
    func testProductViewPresenterBackToCatalog() throws {
        presenter.backToCatalog()
        wait(for: [self.router.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetReview, nil)
        XCTAssertEqual(view.countUpdateCartIndicator, nil)
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messagePushRegistration, nil)
        XCTAssertEqual(router.messagePushUserPage, nil)
        XCTAssertEqual(router.messagePushCatalog, nil)
        XCTAssertEqual(router.messagePopToCatalogWithUser, nil)
        XCTAssertEqual(router.messagePopToCatalogWithCart, "success")
        XCTAssertEqual(router.messagePushProduct, nil)
        XCTAssertEqual(router.messagePushCart, nil)
        XCTAssertEqual(router.messagePopToBackFromCart, nil)
        XCTAssertEqual(router.messageRoot, nil)
    }
    
    func testProductViewPresenterGoToCart() throws {
        presenter.goToCartView()
        wait(for: [self.router.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetReview, nil)
        XCTAssertEqual(view.countUpdateCartIndicator, nil)
        
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
