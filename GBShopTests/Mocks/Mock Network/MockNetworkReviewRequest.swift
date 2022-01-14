//
//  MockNetworkReviewRequest.swift
//  GBShopTests
//
//  Created by Владимир on 14.01.2022.
//

import XCTest
import Alamofire
@testable import GBShop

// MARK: - MockNetworkReviewRequest
//
class MockNetworkReviewRequest: ReviewRequestFactory {
    
    let reviewResponse = ReviewResponse(result: 1, message: "success", review: FakeData().reviewByProduct)
    
    lazy var reviewResultSuccess: Result<ReviewResponse, AFError> = .success(reviewResponse)
    lazy var reviewResultFailure: Result<ReviewResponse, AFError> = .failure(.explicitlyCancelled)
    
    lazy var reviewResponseSuccess = AFDataResponse<ReviewResponse>(request: nil,
                                                                    response: nil,
                                                                    data: nil,
                                                                    metrics: nil,
                                                                    serializationDuration: 1,
                                                                    result: reviewResultSuccess)
    lazy var reviewResponseFailure = AFDataResponse<ReviewResponse>(request: nil,
                                                                    response: nil,
                                                                    data: nil,
                                                                    metrics: nil,
                                                                    serializationDuration: 1,
                                                                    result: reviewResultFailure)
    
    func reviewByProduct(id: Int, completionHandler: @escaping (AFDataResponse<ReviewResponse>) -> Void) {
        if id == 1 {
            completionHandler(reviewResponseSuccess)
        } else {
            completionHandler(reviewResponseFailure)
        }
    }
    
    func reviewByUser(id: Int, completionHandler: @escaping (AFDataResponse<ReviewResponse>) -> Void) {
        if id == 1 {
            completionHandler(reviewResponseSuccess)
        } else {
            completionHandler(reviewResponseFailure)
        }
    }
    
    func reviewAdd(review: Review, token: String, completionHandler: @escaping (AFDataResponse<ReviewResponse>) -> Void) {
        if token == FakeData().token {
            completionHandler(reviewResponseSuccess)
        } else {
            completionHandler(reviewResponseFailure)
        }
    }
    
    func reviewDelete(reviewId: Int, userId: Int, token: String, completionHandler: @escaping (AFDataResponse<ReviewResponse>) -> Void) {
        if (token == FakeData().token) && (userId == FakeData().user.id) {
            completionHandler(reviewResponseSuccess)
        } else {
            completionHandler(reviewResponseFailure)
        }
    }
}
