//
//  ReviewRequestFactory.swift
//  GBShop
//
//  Created by Владимир on 12.12.2021.
//

import Foundation
import Alamofire

protocol ReviewRequestFactory {
    func reviewByProduct(id: Int, completionHandler: @escaping (AFDataResponse<ReviewResponse>) -> Void)
    func reviewByUser(id: Int, completionHandler: @escaping (AFDataResponse<ReviewResponse>) -> Void)
}
