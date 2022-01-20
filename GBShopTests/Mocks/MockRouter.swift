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
    
    var messagePushRegistration: String?
    func pushRegistrationViewController() {
        messagePushRegistration = "success"
        self.expectation.fulfill()
    }
    
    var messagePushUserPage: String?
    func pushUserPageViewController(user: User, token: String) {
        if (token == fake.token) {
            messagePushUserPage = "success"
        }
        self.expectation.fulfill()
    }
    
    var messagePushCatalog: String?
    func pushCatalogViewController(user: User, token: String) {
        if (token == fake.token) {
            messagePushCatalog = "success"
        }
        self.expectation.fulfill()
    }
    
    var messagePopToCatalogWithCart: String?
    func popToCatalogViewController(cart: Cart) {
        messagePopToCatalogWithCart = "success"
        self.expectation.fulfill()
    }
    
    var messagePopToCatalogWithUser: String?
    func popToCatalogViewController(user: User, token: String) {
        if (token == fake.token) {
            messagePopToCatalogWithUser = "success"
        }
        self.expectation.fulfill()
    }
    
    var messagePushProduct: String?
    func pushProductViewController(user: User, token: String, product: Product, cart: Cart) {
        if (token == fake.token) {
            messagePushProduct = "success"
        }
        self.expectation.fulfill()
    }
    
    var messagePushCart: String?
    func pushCartViewController(user: User, token: String, cart: Cart) {
        if (token == fake.token) {
            messagePushCart = "success"
        }
        self.expectation.fulfill()
    }
    
    var messagePopToBackFromCart: String?
    func popToBackFromCartViewController(cart: Cart) {
        messagePopToBackFromCart = "success"
        self.expectation.fulfill()
    }
    
    var messageRoot: String?
    func popToRootViewController() {
        messageRoot = "success"
        self.expectation.fulfill()
    }
}
