//
//  EntityViewModelTests.swift
//  GBShopTests
//
//  Created by Владимир on 04.01.2022.
//

import XCTest
@testable import GBShop

class EntityViewModelTests: XCTestCase {

    let rect = CGRect(x: 0, y: 0, width: 500, height: 100)
    lazy var product1 = ProductViewModel(bounds: rect, id: 0, title: "title", category: "category", imageURL: nil, description: "description", price: "100")
    lazy var product2 = ProductViewModel(bounds: rect, id: 0, title: "title", category: "category", imageURL: nil, description: "description", price: "200")
    
    lazy var review1 = ReviewViewModel(bounds: rect, id: 0, userLogin: "userLogin", comment: "comment", assessment: 1, date: 10000)
    lazy var review2 = ReviewViewModel(bounds: rect, id: 0, userLogin: "userLogin", comment: "comment", assessment: 2, date: 10000)
    
    override func setUpWithError() throws { }
    override func tearDownWithError() throws { }

    func testExampleProductViewModel() throws {
        XCTAssertFalse(product1 == product2)
        
        let product3 = ProductViewModel(bounds: rect, id: 0, title: "title", category: "category", imageURL: nil, description: "description", price: "100")
        XCTAssertTrue(product1 == product3)
        XCTAssertFalse(product3 == product2)
        
        let product = FakeData().product
        let product4 = ProductViewModel(bounds: rect, product: product)
        let product5 = ProductViewModel(bounds: rect,
                                        id: product.id,
                                        title: product.name,
                                        category: product.category,
                                        imageURL: URL(string: product.imageURL ?? ""),
                                        description: product.description ?? "",
                                        price: String(format: "%.0f \u{20BD}", product.price))
        XCTAssertTrue(product4 == product5)
    }
    
    func testExampleReviewViewModel() throws {
        XCTAssertFalse(review1 == review2)
        
        let review3 = ReviewViewModel(bounds: rect, id: 0, userLogin: "userLogin", comment: "comment", assessment: 1, date: 10000)
        XCTAssertTrue(review1 == review3)
        XCTAssertFalse(review3 == review2)
        
        let review = FakeData().reviewByProduct[0]
        let review4 = ReviewViewModel(bounds: rect, review: review)
        let review5 = ReviewViewModel(bounds: rect,
                                      id: review.id,
                                      userLogin: review.userLogin ?? "",
                                      comment: review.comment ?? "",
                                      assessment: review.assessment,
                                      date: review.date)
        XCTAssertTrue(review4 == review5)
    }
}
