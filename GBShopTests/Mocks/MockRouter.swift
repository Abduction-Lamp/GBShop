//
//  MockRouter.swift
//  GBShopTests
//
//  Created by Владимир on 23.12.2021.
//

import XCTest
import UIKit
@testable import GBShop


class MockRouter: RouterProtocol {

    private let fake = FakeData()

    var navigation: UINavigationController?
    var builder: BuilderProtocol?
    
    var expectation = XCTestExpectation(description: "[ MockRouter INIT ]")
    
    
    var messageInitial: String?
    func initialViewController() {
        messageInitial = "success"
        self.expectation.fulfill()
    }
    
    var messageRegistration: String?
    func pushRegistrationViewController() {
        messageRegistration = "success"
        self.expectation.fulfill()
    }
    
    var messageUserPage: String?
    func pushUserPageViewController(user: User, token: String) {
        messageUserPage = "success"
        self.expectation.fulfill()
    }
    
    var messagePushCatalog: String?
    func pushCatalogViewController(user: User, token: String) {
        if (token == fake.token) {
            messagePushCatalog = "success"
        }
        self.expectation.fulfill()
    }
    
    var messageProduct: String?
    func pushProductViewController(user: User, token: String, product: Product) {
        if (user == fake.user) && (token == fake.token) && (product == fake.product) {
            messageProduct = "success"
        }
        self.expectation.fulfill()
    }
    
    var messagePopCatalog: String?
    func popToCatalogViewController(user: User, token: String) {
        messagePopCatalog = "success"
        self.expectation.fulfill()
    }
    
    var messageRoot: String?
    func popToRootViewController() {
        messageRoot = "success"
        self.expectation.fulfill()
    }
}
