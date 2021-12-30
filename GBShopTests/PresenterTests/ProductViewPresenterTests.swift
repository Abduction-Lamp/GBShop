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
    static let product = Product(id: 1, name: "name", category: "category", price: 1, description: "description", imageURL: "imageURL")
    
    var bounds: CGRect {
        return .zero
    }
    
    var expectation = XCTestExpectation(description: "[ TEST MockProductView ]")
    
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
    var messageSetProduct: String?
    func setProduct(model: ProductViewModel) {
        messageSetProduct = "success"
        self.expectation.fulfill()
    }
    var messageSetReview: String?
    func setReview(id: Int) {
        messageSetReview = "success"
        self.expectation.fulfill()
    }
}

// MARK: - TESTS
//
class ProductViewPresenterTests: XCTestCase {
    
    var router: MockRouter!
    var view: MockProductView!
    var network: RequestFactoryProtocol!
    var presenter: ProductViewPresenter!

    var request = RequestFactory()
    
    override func setUpWithError() throws {
        router = MockRouter()
        view = MockProductView()
        network = MockNetworkRequest()

        presenter = ProductViewPresenter(router: router,
                                         view: view,
                                         network: network,
                                         user: MockNetworkUserRequest.fakeUser,
                                         token: "",
                                         product: MockProductView.product)
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
    
    func testCatalogViewPresenterInit() {
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetProduct, "success")
        XCTAssertEqual(view.messageSetReview, nil)
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messageRegistration, nil)
        XCTAssertEqual(router.messageUserPage, nil)
        XCTAssertEqual(router.messageCatalog, nil)
        XCTAssertEqual(router.messageProduct, nil)
        XCTAssertEqual(router.messageRoot, nil)
    }
}
