//
//  CartRequestFactory.swift
//  GBShop
//
//  Created by Владимир on 16.12.2021.
//

import Foundation
import Alamofire

protocol CartRequestFactory {
    func cart(owner: Int,
              token: String,
              completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void)
    
    func addProduct(productId: Int,
                    owner: Int,
                    token: String,
                    completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void)
    
    func deleteProduct(productId: Int,
                       owner: Int,
                       token: String,
                       completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void)
    
    func deleteAllByProduct(productId: Int,
                            owner: Int,
                            token: String,
                            completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void)
    
    func deleteAll(owner: Int,
                   token: String,
                   completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void)
    
    func pay(owner: Int,
             token: String,
             completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void)
}
