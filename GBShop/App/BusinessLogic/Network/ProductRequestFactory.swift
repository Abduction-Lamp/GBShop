//
//  ProductRequestFactory.swift
//  GBShop
//
//  Created by Владимир on 06.12.2021.
//

import Foundation
import Alamofire

protocol ProductRequestFactory {
    func getCatalog(page: Int, completionHandler: @escaping (AFDataResponse<CatalogResponse>) -> Void)
    func getSection(id: Int, page: Int, completionHandler: @escaping (AFDataResponse<SectionResponse>) -> Void)
    func getProduct(id: Int, completionHandler: @escaping (AFDataResponse<ProductResponse>) -> Void)
}
