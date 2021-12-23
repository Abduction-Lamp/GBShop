//
//  RouterTests.swift
//  GBShopTests
//
//  Created by Владимир on 23.12.2021.
//

import XCTest
@testable import GBShop

class RouterTests: XCTestCase {
    
    var router: RouterProtocol!
    var assebly: BuilderViewController!
    var navigation: MockNavigation!
    
    override func setUpWithError() throws {
        assebly = BuilderViewController()
        navigation = MockNavigation()
        router = Router(navigation: navigation, builder: assebly)
    }

    override func tearDownWithError() throws {
        navigation = nil
        assebly = nil
        router = nil
    }

    func testRouter() throws {
        router.pushRegistrationViewController()
        let registrationViewController = navigation.presentedVC
        XCTAssertTrue(registrationViewController is RegistrationViewController)
        
        router.pushUserPageViewController(user: MockNetworkUserRequest.fakeUser, token: "")
        let userPageViewController = navigation.presentedVC
        XCTAssertTrue(userPageViewController is UserPageViewController)
    }
}
