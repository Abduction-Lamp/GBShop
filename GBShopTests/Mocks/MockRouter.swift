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
        if (user == MockNetworkUserRequest.fakeUser) && (token == "") {
            messageUserPage = "success"
            self.expectation.fulfill()
        }
    }
    
    var messageRoot: String?
    func popToRootViewController() {
        messageRoot = "success"
        self.expectation.fulfill()
    }
    
    var navigation: UINavigationController?
    var builder: BuilderProtocol?
}
