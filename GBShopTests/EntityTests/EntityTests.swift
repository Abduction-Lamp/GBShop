//
//  EntityTests.swift
//  GBShopTests
//
//  Created by Владимир on 24.12.2021.
//

import XCTest
@testable import GBShop

class EntityTests: XCTestCase {

    let user1 = User(id: 1, firstName: "test", lastName: "test", gender: "test", email: "test", creditCard: "test", login: "test", password: "test")
    let user2 = User(id: 2, firstName: "test", lastName: "test", gender: "test", email: "test", creditCard: "test", login: "test", password: "test")
    
    let product1 = Product(id: 1, name: "test", category: "test", price: 100.0, description: "test")
    let product2 = Product(id: 2, name: "test", category: "test", price: 200.0, description: "test")
    
    let review1 = Review(id: 1, productId: 1, productName: "test", userId: 1, userLogin: "test", comment: "test", assessment: 1, date: 1.0)
    let review2 = Review(id: 2, productId: 2, productName: "test", userId: 2, userLogin: "test", comment: "test", assessment: 2, date: 2.0)
    
    let cart1 = Cart(owner: 1)
    let cart2 = Cart(owner: 2)
    
    var cart = Cart(owner: 1)
    
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}

    func testEntityUser() throws {
        XCTAssertFalse(user1 == user2)
        
        let equal = user1
        XCTAssertTrue(user1 == equal)
        XCTAssertFalse(equal == user2)
    }
    
    func testEntityProduct() throws {
        XCTAssertFalse(product1 == product2)
        
        let equal = product1
        XCTAssertTrue(product1 == equal)
        XCTAssertFalse(equal == product2)
    }
    
    func testEntityReview() throws {
        XCTAssertFalse(review1 == review2)
        
        let equal = review1
        XCTAssertTrue(review1 == equal)
        XCTAssertFalse(equal == review2)
    }
    
    func testEntityCart() throws {
        XCTAssertFalse(cart1 == cart2)
        
        let equal = cart1
        XCTAssertTrue(cart1 == equal)
        XCTAssertFalse(equal == cart2)
    }
    
    func testEntityCartTotalPrice() throws {
        cart.cart.append(product1)
        cart.cart.append(product2)

        XCTAssertEqual(cart.totalPrice, 300.0)
    }
}
