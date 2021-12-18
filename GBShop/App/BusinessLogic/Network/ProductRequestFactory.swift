//
//  ProductRequestFactory.swift
//  GBShop
//
//  Created by Владимир on 06.12.2021.
//

import Foundation
import Alamofire

protocol ProductRequestFactory {
    func getCatalog(id: Int, page: Int, completionHandler: @escaping (AFDataResponse<[Product]>) -> Void)
    func getGoodById(id: Int, completionHandler: @escaping (AFDataResponse<GetGoodByIdResult>) -> Void)
}
