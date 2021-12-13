//
//  ReviewRequestFactory.swift
//  GBShop
//
//  Created by Владимир on 12.12.2021.
//

import Foundation
import Alamofire

protocol ReviewRequestFactory {
    func reviewByProduct(id: Int,
                         completionHandler: @escaping (AFDataResponse<ReviewResponse>) -> Void)
    
    func reviewByUser(id: Int,
                      completionHandler: @escaping (AFDataResponse<ReviewResponse>) -> Void)
    
    func reviewAdd(review: Review,
                   token: String,
                   completionHandler: @escaping (AFDataResponse<ReviewResponse>) -> Void)
    
    func reviewDelete(reviewId: Int,
                      userId: Int,
                      token: String,
                      completionHandler: @escaping (AFDataResponse<ReviewResponse>) -> Void)
}
