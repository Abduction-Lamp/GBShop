//
//  EntityRequestTests.swift
//  GBShopTests
//
//  Created by Владимир on 24.12.2021.
//

import XCTest
@testable import GBShop

class EntityRequestTests: XCTestCase {

    let login = LoginResponse(result: 1, message: "test", user: nil, token: nil)
    let logout = LogoutResponse(result: 1, message: "test")
    let register = UserRegisterResponse(result: 1, message: "test", user: nil, token: nil)
    let change = UserDataChangeResponse(result: 1, message: "test", user: nil)
    let product = ProductResponse(result: 1, message: "test", product: nil)
    let catalog = CatalogResponse(result: 1, message: "test", catalog: nil)
    let review = ReviewResponse(result: 1, message: "test", review: nil)
    let cart = CartResponse(result: 1, message: "test", cart: nil)

    var output = """
                 result:    1
                 message:   test\n
                 """
    
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}

    func testSucceess() throws {
        XCTAssertEqual(login.description, output)
        XCTAssertEqual(logout.description, output)
        XCTAssertEqual(register.description, output)
        XCTAssertEqual(change.description, output)
        XCTAssertEqual(product.description, output)
        XCTAssertEqual(catalog.description, output)
        XCTAssertEqual(review.description, output)
        XCTAssertEqual(cart.description, output)
    }
}
