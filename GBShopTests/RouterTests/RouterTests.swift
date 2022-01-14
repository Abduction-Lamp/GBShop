//
//  RouterTests.swift
//  GBShopTests
//
//  Created by Владимир on 23.12.2021.
//

import XCTest
@testable import GBShop

class RouterTests: XCTestCase {
    
    let fake = FakeData()
    
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
        
        router.pushUserPageViewController(user: fake.user, token: fake.token)
        let userPageViewController = navigation.presentedVC
        XCTAssertTrue(userPageViewController is UserPageViewController)
        
        router.pushCatalogViewController(user: fake.user, token: fake.token)
        let catalogViewController = navigation.presentedVC
        XCTAssertTrue(catalogViewController is CatalogViewController)
        
        router.pushProductViewController(user: fake.user, token: fake.token, product: fake.product, cart: fake.cart)
        let productViewController = navigation.presentedVC
        XCTAssertTrue(productViewController is ProductViewController)
        
        router.pushCartViewController(user: fake.user, token: fake.token, cart: fake.cart)
        let cartViewController = navigation.presentedVC
        XCTAssertTrue(cartViewController is CartViewController)
    }
    
    func testRouterPop() throws {
        router.initialViewController()
        router.popToRootViewController()
        let rootViewController = navigation.presentedVC
        XCTAssertTrue(rootViewController is LoginViewController)
    }
}
