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
    
    func add(productId: Int,
             owner: Int,
             token: String,
             completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void)
    
    func delete(productId: Int,
                owner: Int,
                token: String,
                completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void)
    
    func pay(owner: Int,
             token: String,
             completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void)
}
