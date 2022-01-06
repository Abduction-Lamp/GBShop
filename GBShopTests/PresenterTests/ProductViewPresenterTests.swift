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

    let fake = FakeData()
    
    var bounds: CGRect {
        return .zero
    }
    
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

}

// MARK: - TESTS
//
class ProductViewPresenterTests: XCTestCase {
    
    let fake = FakeData()
    
    var router: MockRouter!
    var view: MockProductView!
    var network: RequestFactoryProtocol!
    var presenter: ProductViewPresenter!
    
    override func setUpWithError() throws {
        router = MockRouter()
        view = MockProductView()
        network = MockNetworkRequest()

        presenter = ProductViewPresenter(router: router, view: view, network: network, user: fake.user, token: fake.token, product: fake.product)
    }

    override func tearDownWithError() throws {
        view = nil
        network = nil
        router = nil
        presenter = nil
    }

    func testIsNotNill() throws {
        XCTAssertNotNil(view, "View component is not nil")
        XCTAssertNotNil(network, "Network component is not nil")
        XCTAssertNotNil(router, "Router component is not nil")
        XCTAssertNotNil(presenter, "Presenter component is not nil")
    }
    
    func testProductViewPresenterGetUserInfo() throws {
        let user = presenter.getUserInfo()
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetReview, nil)
        XCTAssertEqual(user, fake.user)
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messageRegistration, nil)
        XCTAssertEqual(router.messageUserPage, nil)
        XCTAssertEqual(router.messagePushCatalog, nil)
        XCTAssertEqual(router.messagePopCatalog, nil)
        XCTAssertEqual(router.messageProduct, nil)
        XCTAssertEqual(router.messageRoot, nil)
    }
    
    func testProductViewPresenterAddToCartSuccess() throws {
        presenter.addToCart()
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, "В корзину добавлено: \(self.fake.product.name)")
        XCTAssertEqual(view.messageSetReview, nil)
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messageRegistration, nil)
        XCTAssertEqual(router.messageUserPage, nil)
        XCTAssertEqual(router.messagePushCatalog, nil)
        XCTAssertEqual(router.messagePopCatalog, nil)
        XCTAssertEqual(router.messageProduct, nil)
        XCTAssertEqual(router.messageRoot, nil)
    }
    
    func testProductViewPresenterAddToCartFailure() throws {
        presenter = ProductViewPresenter(router: router, view: view, network: network, user: fake.user, token: "token", product: fake.product)
        presenter.addToCart()
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, "error")
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetReview, nil)
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messageRegistration, nil)
        XCTAssertEqual(router.messageUserPage, nil)
        XCTAssertEqual(router.messagePushCatalog, nil)
        XCTAssertEqual(router.messagePopCatalog, nil)
        XCTAssertEqual(router.messageProduct, nil)
        XCTAssertEqual(router.messageRoot, nil)
    }
    
    func testProductViewPresenterFetchReview() throws {
        presenter.fetchReview()
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetReview, "success")
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messageRegistration, nil)
        XCTAssertEqual(router.messageUserPage, nil)
        XCTAssertEqual(router.messagePushCatalog, nil)
        XCTAssertEqual(router.messagePopCatalog, nil)
        XCTAssertEqual(router.messageProduct, nil)
        XCTAssertEqual(router.messageRoot, nil)
    }
    
    func testProductViewPresenterFetchReviewFailure() throws {
        presenter = ProductViewPresenter(router: router, view: view, network: network, user: fake.user, token: fake.token, product: fake.product2)
        presenter.fetchReview()
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, "error")
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetReview, nil)
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messageRegistration, nil)
        XCTAssertEqual(router.messageUserPage, nil)
        XCTAssertEqual(router.messagePushCatalog, nil)
        XCTAssertEqual(router.messagePopCatalog, nil)
        XCTAssertEqual(router.messageProduct, nil)
        XCTAssertEqual(router.messageRoot, nil)
    }
    
    func testProductViewPresenterAddReview() throws {
        presenter.addReview("test")
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetReview, "success")
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messageRegistration, nil)
        XCTAssertEqual(router.messageUserPage, nil)
        XCTAssertEqual(router.messagePushCatalog, nil)
        XCTAssertEqual(router.messagePopCatalog, nil)
        XCTAssertEqual(router.messageProduct, nil)
        XCTAssertEqual(router.messageRoot, nil)
    }
    
    func testProductViewPresenterAddReviewFailure() throws {
        presenter = ProductViewPresenter(router: router, view: view, network: network, user: fake.user, token: "token", product: fake.product)
        presenter.addReview("test")
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, "error")
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetReview, nil)
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messageRegistration, nil)
        XCTAssertEqual(router.messageUserPage, nil)
        XCTAssertEqual(router.messagePushCatalog, nil)
        XCTAssertEqual(router.messagePopCatalog, nil)
        XCTAssertEqual(router.messageProduct, nil)
        XCTAssertEqual(router.messageRoot, nil)
    }
    
    func testProductViewPresenterRemoveReview() throws {
        presenter.review = fake.reviewByProductViewModel
        presenter.removeReview(id: 3)
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetReview, "success")
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messageRegistration, nil)
        XCTAssertEqual(router.messageUserPage, nil)
        XCTAssertEqual(router.messagePushCatalog, nil)
        XCTAssertEqual(router.messagePopCatalog, nil)
        XCTAssertEqual(router.messageProduct, nil)
        XCTAssertEqual(router.messageRoot, nil)
    }
    
    func testProductViewPresenterRemoveReviewMessageId() throws {
        presenter.review = fake.reviewByProductViewModel
        presenter.removeReview(id: 1)
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, "success")
        XCTAssertEqual(view.messageSetReview, nil)
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messageRegistration, nil)
        XCTAssertEqual(router.messageUserPage, nil)
        XCTAssertEqual(router.messagePushCatalog, nil)
        XCTAssertEqual(router.messagePopCatalog, nil)
        XCTAssertEqual(router.messageProduct, nil)
        XCTAssertEqual(router.messageRoot, nil)
    }
    
    func testProductViewPresenterRemoveReviewFailure() throws {
        presenter = ProductViewPresenter(router: router, view: view, network: network, user: fake.user, token: "token", product: fake.product)
        presenter.removeReview(id: 1)
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, "error")
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetReview, nil)
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messageRegistration, nil)
        XCTAssertEqual(router.messageUserPage, nil)
        XCTAssertEqual(router.messagePushCatalog, nil)
        XCTAssertEqual(router.messagePopCatalog, nil)
        XCTAssertEqual(router.messageProduct, nil)
        XCTAssertEqual(router.messageRoot, nil)
    }
}
