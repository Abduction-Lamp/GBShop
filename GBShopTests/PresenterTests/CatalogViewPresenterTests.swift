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
    var catalog: [Section]?
    func setCatalog(_ catalog: [Section]) {
        self.catalog = catalog
        self.messageSetCatalog = "success"
        self.expectation.fulfill()
    }
    var messageUpdataCart: Int?
    func updataCart(count: Int) {
        messageUpdataCart = count
        self.expectation.fulfill()
    }
}

// MARK: - TESTS
//
class CatalogViewPresenterTests: XCTestCase {

    var router: MockRouter!
    var view: MockCatalogView!
    var network: RequestFactoryProtocol!
    var presenter: CatalogViewPresenter!

    var request = RequestFactory()
    
    override func setUpWithError() throws {
        router = MockRouter()
        view = MockCatalogView()
        network = MockNetworkRequest()

        presenter = CatalogViewPresenter(router: router, view: view, network: network, user: MockNetworkUserRequest.fakeUser, token: "")
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
        XCTAssertEqual(view.catalog, MockProductRequest.catalog)
        XCTAssertEqual(view.messageUpdataCart, nil)
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messageRegistration, nil)
        XCTAssertEqual(router.messageUserPage, nil)
        XCTAssertEqual(router.messageCatalog, nil)
        XCTAssertEqual(router.messageRoot, nil)
    }
    
    func testCatalogViewPresenterGetCatalogSeccess() throws {
        presenter.getCatalog(page: 0)
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetCatalog, "success")
        XCTAssertEqual(view.catalog, MockProductRequest.catalog)
        XCTAssertEqual(view.messageUpdataCart, nil)
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messageRegistration, nil)
        XCTAssertEqual(router.messageUserPage, nil)
        XCTAssertEqual(router.messageCatalog, nil)
        XCTAssertEqual(router.messageRoot, nil)
    }
    
    func testCatalogViewPresenterGetCatalogError() throws {
        presenter.getCatalog(page: -1)
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, "error")
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetCatalog, "success")
        XCTAssertEqual(view.messageUpdataCart, nil)
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messageRegistration, nil)
        XCTAssertEqual(router.messageUserPage, nil)
        XCTAssertEqual(router.messageCatalog, nil)
        XCTAssertEqual(router.messageRoot, nil)
    }
    
    func testCatalogViewPresenterAddCartSeccess() throws {
        presenter.addToCart(productId: 1)
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, nil)
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetCatalog, "success")
        XCTAssertEqual(view.messageUpdataCart, 1)
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messageRegistration, nil)
        XCTAssertEqual(router.messageUserPage, nil)
        XCTAssertEqual(router.messageCatalog, nil)
        XCTAssertEqual(router.messageRoot, nil)
    }
    
    func testCatalogViewPresenterAddCartError() throws {
        presenter.addToCart(productId: -1)
        wait(for: [self.view.expectation], timeout: 2.0)
        
        XCTAssertEqual(view.error, "error")
        XCTAssertEqual(view.message, nil)
        XCTAssertEqual(view.messageSetCatalog, "success")
        XCTAssertEqual(view.messageUpdataCart, nil)
        
        XCTAssertEqual(router.messageInitial, nil)
        XCTAssertEqual(router.messageRegistration, nil)
        XCTAssertEqual(router.messageUserPage, nil)
        XCTAssertEqual(router.messageCatalog, nil)
        XCTAssertEqual(router.messageRoot, nil)
    }
}
