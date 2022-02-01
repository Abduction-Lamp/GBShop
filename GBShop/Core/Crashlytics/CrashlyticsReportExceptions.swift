//
//  CrashlyticsReportExceptions.swift
//  GBShop
//
//  Created by Владимир on 18.01.2022.
//

import Foundation
import Firebase

public enum CrashlyticsCode: Int {
    case failureResponse = 1000
    case rejectionResult = 1001
    case nilDataResult = 1002
    case undefinedBehavior = 1003
}

final class CrashlyticsReportExceptions {
    private(set) var domain: String = NSCocoaErrorDomain
    private(set) var code: CrashlyticsCode = .undefinedBehavior
    private(set) var userInfo: [String: Any] = [:]
    
    // MARK: - Custom Simple report
    //
    public func report() {
        let error = NSError.init(domain: domain, code: code.rawValue, userInfo: userInfo)
        Crashlytics.crashlytics().record(error: error)
    }
    
    public func report(code: CrashlyticsCode) {
        let error = NSError.init(domain: domain, code: code.rawValue, userInfo: userInfo)
        Crashlytics.crashlytics().record(error: error)
    }
    
    public func report(code: CrashlyticsCode, info: [String: Any]?) {
        let error = NSError.init(domain: domain, code: code.rawValue, userInfo: info)
        Crashlytics.crashlytics().record(error: error)
    }
    
    public func report(error: String) {
        let error = NSError.init(domain: domain, code: CrashlyticsCode.failureResponse.rawValue, userInfo: ["error": error])
        Crashlytics.crashlytics().record(error: error)
    }
    
    public func report(error: NSError) {
        Crashlytics.crashlytics().record(error: error)
    }
}

// MARK: - Response report
//
extension CrashlyticsReportExceptions {
    
    public func report(login: String, code: CrashlyticsCode, result: AbstructResponse) {
        userInfo.removeAll()
        userInfo = [
            "resutl": result.result,
            "message": result.message,
            "user/login": login
        ]
        let error = NSError.init(domain: domain, code: code.rawValue, userInfo: userInfo)
        Crashlytics.crashlytics().record(error: error)
    }
    
    public func report(user: User?, code: CrashlyticsCode, result: AbstructResponse) {
        userInfo.removeAll()
        userInfo = [
            "resutl": result.result,
            "message": result.message,
            "user/id": user?.id.description ?? "nil",
            "user/login": user?.login ?? "nil",
            "user/email": user?.email ?? "nil",
            "user/creditCard": user?.creditCard ?? "nil"
        ]
        let error = NSError.init(domain: domain, code: code.rawValue, userInfo: userInfo)
        Crashlytics.crashlytics().record(error: error)
    }
    
    public func report(cart: Cart?, code: CrashlyticsCode, result: AbstructResponse) {
        userInfo.removeAll()
        cart?.items.forEach({ item in
            let cartInfo: [String: Any] = [
                "cart/product/id": item.product.id,
                "cart/product/name": item.product.name,
                "cart/product/category": item.product.category,
                "cart/product/price": item.product.price,
                "cart/product/quantity": item.quantity
            ]
            userInfo = cartInfo
        })
        userInfo["resutl"] = result.result
        userInfo["message"] = result.message
        userInfo["cart/totalPrice"] = cart?.totalPrice.description ?? "nil"
        
        let error = NSError.init(domain: domain, code: code.rawValue, userInfo: userInfo)
        Crashlytics.crashlytics().record(error: error)
    }
    
    public func report(productID: Int, code: CrashlyticsCode, result: AbstructResponse) {
        userInfo.removeAll()
        userInfo["resutl"] = result.result
        userInfo["message"] = result.message
        userInfo["productID"] = productID
    
        let error = NSError.init(domain: domain, code: code.rawValue, userInfo: userInfo)
        Crashlytics.crashlytics().record(error: error)
    }
    
    public func report(productID: Int, cart: Cart, code: CrashlyticsCode, result: AbstructResponse) {
        userInfo.removeAll()
        cart.items.forEach({ item in
            let key = "cart/product/id(\(item.product.id))"
            var value: String = ""
            value += "name: \(item.product.name); "
            value += "category: \(item.product.category); "
            value += "price: \(item.product.price); "
            value += "quantity: \(item.quantity)"
            userInfo[key] = value
        })
        userInfo["resutl"] = result.result
        userInfo["message"] = result.message
        userInfo["productID"] = productID
    
        let error = NSError.init(domain: domain, code: code.rawValue, userInfo: userInfo)
        Crashlytics.crashlytics().record(error: error)
    }

    public func report(page: Int, code: CrashlyticsCode, result: AbstructResponse) {
        userInfo.removeAll()
        userInfo["resutl"] = result.result
        userInfo["message"] = result.message
        userInfo["page"] = page
    
        let error = NSError.init(domain: domain, code: code.rawValue, userInfo: userInfo)
        Crashlytics.crashlytics().record(error: error)
    }
    
    public func report(review: Review, code: CrashlyticsCode, result: AbstructResponse) {
        userInfo.removeAll()
        userInfo["resutl"] = result.result
        userInfo["message"] = result.message
        userInfo["review/id"] = review.id == 0 ? "nil" : review.id.description
        userInfo["review/productId"] = review.productId
        userInfo["review/productName"] = review.productName
        userInfo["review/assessment"] = review.assessment
        userInfo["review/date"] = review.date
        userInfo["review/comment"] = review.comment
    
        let error = NSError.init(domain: domain, code: code.rawValue, userInfo: userInfo)
        Crashlytics.crashlytics().record(error: error)
    }
}
