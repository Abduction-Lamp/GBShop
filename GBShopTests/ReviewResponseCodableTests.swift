//
//  ReviewResponseCodableTests.swift
//  GBShopTests
//
//  Created by Владимир on 12.12.2021.
//

import XCTest
import Alamofire
@testable import GBShop

class ReviewResponseCodableTests: XCTestCase {

    let request = RequestFactory().makeReviewRequestFactory()
    let expectation = XCTestExpectation(description: "Download https://salty-springs-77873.herokuapp.com/")
    
    override func setUpWithError() throws { }
    override func tearDownWithError() throws { }
}

// MARK: - Review By Product
//
extension ReviewResponseCodableTests {

    func testReviewByProductResponseSuccess() throws {
        let expression = ReviewResponse(result: 1,
                                        message: "Количество отзовов у товара PlayStation 5 = 2",
                                        review: [
                                            Review(id: 1,
                                                   productId: 3,
                                                   productName: "PlayStation 5",
                                                   userId: 1,
                                                   userLogin: "Username",
                                                   comment: "Классная приставка, на дорого",
                                                   assessment: 4,
                                                   date: 1637767328.926343),
                                            Review(id: 2,
                                                   productId: 3,
                                                   productName: "PlayStation 5",
                                                   userId: 2,
                                                   userLogin: "Queen",
                                                   comment: "Неоправданно дорого",
                                                   assessment: 2,
                                                   date: 1637853728.926343)
                                        ])

        request.reviewByProduct(id: 3) { response in
            switch response.result {
            case .success(let review):
                XCTAssertEqual(review.result, expression.result)
                XCTAssertEqual(review.message, expression.message)
                XCTAssertEqual(review.review, expression.review)
            case .failure(let error):
                print(error)
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }

    func testReviewByProductResponseSuccessEmptyReview() throws {
        let expression = ReviewResponse(result: 1,
                                        message: "Количество отзовов у товара PlayStation 4 Slim = 0",
                                        review: [])

        request.reviewByProduct(id: 4) { response in
            switch response.result {
            case .success(let review):
                XCTAssertEqual(review.result, expression.result)
                XCTAssertEqual(review.message, expression.message)
                XCTAssertEqual(review.review, expression.review)
            case .failure(let error):
                print(error)
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }

    func testReviewByProductResponseFailureID() throws {
        let expression = ReviewResponse(result: 0,
                                        message: "Товар с ID = 0 не найден",
                                        review: nil)

        request.reviewByProduct(id: 0) { response in
            switch response.result {
            case .success(let review):
                XCTAssertEqual(review.result, expression.result)
                XCTAssertEqual(review.message, expression.message)
                XCTAssertEqual(review.review, expression.review)
            case .failure(let error):
                print(error)
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
}

// MARK: - Review By User
//
extension ReviewResponseCodableTests {

    func testReviewByUserResponseSuccess() throws {
        let expression = ReviewResponse(result: 1,
                                        message: "Количество отзовов у пользователя Queen = 4",
                                        review: [
                                            Review(id: 2,
                                                   productId: 3,
                                                   productName: "PlayStation 5",
                                                   userId: 2,
                                                   userLogin: "Queen",
                                                   comment: "Неоправданно дорого",
                                                   assessment: 2,
                                                   date: 1637853728.926343),
                                            Review(id: 4,
                                                   productId: 5,
                                                   productName: "XBox Series X",
                                                   userId: 2,
                                                   userLogin: "Queen",
                                                   comment: "Холодильник какой-то, но выглядит лучше чем PS5",
                                                   assessment: 3,
                                                   date: 1638026528.926343),
                                            Review(id: 5,
                                                   productId: 1,
                                                   productName: "MacBook Pro",
                                                   userId: 2,
                                                   userLogin: "Queen",
                                                   comment: "Красивый и мощный",
                                                   assessment: 5,
                                                   date: 1638112928.926343),
                                            Review(id: 8,
                                                   productId: 2,
                                                   productName: "Microsoft Surface Laptop",
                                                   userId: 2,
                                                   userLogin: "Queen",
                                                   comment: "И у меня такой, езжу с ним в универ, очень нравиться",
                                                   assessment: 5,
                                                   date: 1638372128.926343)
                                        ])

        request.reviewByUser(id: 2) { response in
            switch response.result {
            case .success(let review):
                XCTAssertEqual(review.result, expression.result)
                XCTAssertEqual(review.message, expression.message)
                XCTAssertEqual(review.review, expression.review)
            case .failure(let error):
                print(error)
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }

    func testReviewByUserResponseFailureID() throws {
        let expression = ReviewResponse(result: 0,
                                        message: "Пользователь с ID = 3 не найден",
                                        review: nil)

        request.reviewByUser(id: 3) { response in
            switch response.result {
            case .success(let review):
                XCTAssertEqual(review.result, expression.result)
                XCTAssertEqual(review.message, expression.message)
                XCTAssertEqual(review.review, expression.review)
            case .failure(let error):
                print(error)
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
}

// MARK: - ADD NEW REVIEW
//
extension ReviewResponseCodableTests {

    func testReviewAddResponseSuccess() throws {
        let newReview = Review(id: 0,
                               productId: 1,
                               productName: nil,
                               userId: 2,
                               userLogin: nil,
                               comment: "test",
                               assessment: 5,
                               date: 12345)

        let responseReview = Review(id: 11,
                                    productId: 1,
                                    productName: "MacBook Pro",
                                    userId: 2,
                                    userLogin: "Queen",
                                    comment: "test",
                                    assessment: 5,
                                    date: newReview.date)

        let expression = ReviewResponse(result: 1,
                                        message: "Отзыв успешно добавлен",
                                        review: [responseReview])
        let tokenToId2 = "13AA24D9-ECF1-401A-8F32-B05EBC7E8E38"

        request.reviewAdd(review: newReview, token: tokenToId2) { response in
            switch response.result {
            case .success(let review):
                XCTAssertEqual(review.result, expression.result)
                XCTAssertEqual(review.message, expression.message)
                XCTAssertEqual(review.review, expression.review)
            case .failure(let error):
                print(error)
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }

    func testReviewAddResponseFailureToken() throws {
        let newReview = Review(id: 0,
                               productId: 1,
                               productName: nil,
                               userId: 2,
                               userLogin: nil,
                               comment: "test",
                               assessment: 5,
                               date: Date().timeIntervalSince1970)

        let expression = ReviewResponse(result: 0,
                                        message: "Token усторел",
                                        review: nil)
        let tokenToId2 = "token"

        request.reviewAdd(review: newReview, token: tokenToId2) { response in
            switch response.result {
            case .success(let review):
                XCTAssertEqual(review.result, expression.result)
                XCTAssertEqual(review.message, expression.message)
                XCTAssertEqual(review.review, expression.review)
            case .failure(let error):
                print(error)
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }

    func testReviewAddResponseFailureUserId() throws {
        let newReview = Review(id: 0,
                               productId: 1,
                               productName: nil,
                               userId: 12,
                               userLogin: nil,
                               comment: "test",
                               assessment: 5,
                               date: Date().timeIntervalSince1970)
        let expression = ReviewResponse(result: 0,
                                        message: "Пользователь с ID = 12 не найден",
                                        review: nil)
        let tokenToId2 = "token"

        request.reviewAdd(review: newReview, token: tokenToId2) { response in
            switch response.result {
            case .success(let review):
                XCTAssertEqual(review.result, expression.result)
                XCTAssertEqual(review.message, expression.message)
                XCTAssertEqual(review.review, expression.review)
            case .failure(let error):
                print(error)
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }

    func testReviewAddResponseFailureAssessment() throws {
        let newReview = Review(id: 0,
                               productId: 1,
                               productName: nil,
                               userId: 2,
                               userLogin: nil,
                               comment: "test",
                               assessment: 51,
                               date: Date().timeIntervalSince1970)
        let expression = ReviewResponse(result: 0,
                                        message: "Ошибка в поле с оценкой",
                                        review: nil)
        let tokenToId2 = "13AA24D9-ECF1-401A-8F32-B05EBC7E8E38"

        request.reviewAdd(review: newReview, token: tokenToId2) { response in
            switch response.result {
            case .success(let review):
                XCTAssertEqual(review.result, expression.result)
                XCTAssertEqual(review.message, expression.message)
                XCTAssertEqual(review.review, expression.review)
            case .failure(let error):
                print(error)
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
}

// MARK: - DELETE REVIEW
//
extension ReviewResponseCodableTests {

    func testReviewDeleteResponseSuccess() throws {
        let deletedReview = Review(id: 2,
                                   productId: 3,
                                   productName: "PlayStation 5",
                                   userId: 2,
                                   userLogin: "Queen",
                                   comment: "Неоправданно дорого",
                                   assessment: 2,
                                   date: 1637853728.926343)
        let expression = ReviewResponse(result: 1,
                                        message: "Отзыв был удален",
                                        review: [deletedReview])
        let tokenToId2 = "13AA24D9-ECF1-401A-8F32-B05EBC7E8E38"

        request.reviewDelete(reviewId: 2, userId: 2, token: tokenToId2) { response in
            switch response.result {
            case .success(let review):
                XCTAssertEqual(review.result, expression.result)
                XCTAssertEqual(review.message, expression.message)
                XCTAssertEqual(review.review, expression.review)
            case .failure(let error):
                print(error)
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }

    func testReviewDeleteResponseFailureToken() throws {
        let expression = ReviewResponse(result: 0,
                                        message: "Token усторел",
                                        review: nil)
        let tokenToId2 = "token"

        request.reviewDelete(reviewId: 2, userId: 2, token: tokenToId2) { response in
            switch response.result {
            case .success(let review):
                XCTAssertEqual(review.result, expression.result)
                XCTAssertEqual(review.message, expression.message)
                XCTAssertEqual(review.review, expression.review)
            case .failure(let error):
                print(error)
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }

    func testReviewDeleteResponseFailureID() throws {
        let expression = ReviewResponse(result: 0,
                                        message: "Отзыва с ID = 1 не найден или не пренадлежит пользователю с ID = 2",
                                        review: nil)
        let tokenToId2 = "13AA24D9-ECF1-401A-8F32-B05EBC7E8E38"

        request.reviewDelete(reviewId: 1, userId: 2, token: tokenToId2) { response in
            switch response.result {
            case .success(let review):
                XCTAssertEqual(review.result, expression.result)
                XCTAssertEqual(review.message, expression.message)
                XCTAssertEqual(review.review, expression.review)
            case .failure(let error):
                print(error)
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
}
