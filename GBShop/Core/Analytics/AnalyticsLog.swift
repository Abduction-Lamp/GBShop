////
////  AnalyticsLog.swift
////  GBShop
////
////  Created by Владимир on 19.01.2022.
////
//
//import Foundation
//import Firebase
//
//final class AnalyticsLog {
//    
//    public func login(user: User) {
//        let parameters = makeUserParameters(user)
//        Analytics.logEvent(AnalyticsEventLogin, parameters: parameters)
//    }
//    
//    public func signup(user: User) {
//        let parameters = makeUserParameters(user)
//        Analytics.logEvent(AnalyticsEventSignUp, parameters: parameters)
//    }
//    
//    public func logout(user: User) {
//        let parameters = makeUserParameters(user)
//        Analytics.logEvent("logout", parameters: parameters)
//    }
//    
//    public func changeUser(old: User, new: User) {
//        var parameters: [String: Any] = [:]
//        
//        if old.firstName != new.firstName {
//            parameters["firstName"] = new.firstName
//        }
//        if old.lastName != new.lastName {
//            parameters["lastName"] = new.lastName
//        }
//        if old.gender != new.gender {
//            parameters["gender"] = (new.gender == "m") ? "мужчина" : "женщина"
//        }
//        if old.email != new.email {
//            parameters["email"] = new.email
//        }
//        if old.creditCard != new.creditCard {
//            parameters["creditCard"] = new.creditCard
//        }
//        if old.login != new.login {
//            parameters["login"] = new.login
//        }
//        if old.password != new.password {
//            parameters["password"] = "YES"
//        }
//        
//        Analytics.logEvent("change_user_data", parameters: parameters)
//    }
//    
//    public func addProductToCart(user: User, product: Product?, cart: Cart) {
//        var parameters: [String: Any] = makeUserParameters(user)
//        if let productParam = product {
//            parameters.merge(dict: makeProductParameters(productParam))
//        }
//        parameters.merge(dict: makeCartParameters(cart))
//        
//        Analytics.logEvent(AnalyticsEventAddToCart, parameters: parameters)
//    }
//    
//    public func addProductToCart(user: User, product: ProductViewModel?, cart: Cart) {
//        var parameters: [String: Any] = makeUserParameters(user)
//        if let productParam = product {
//            parameters.merge(dict: makeProductParameters(productParam))
//        }
//        parameters.merge(dict: makeCartParameters(cart))
//        
//        Analytics.logEvent(AnalyticsEventAddToCart, parameters: parameters)
//    }
//    
//    public func removeProductFromCart(user: User, product: Product?, cart: Cart) {
//        var parameters: [String: Any] = makeUserParameters(user)
//        if let productParam = product {
//            parameters.merge(dict: makeProductParameters(productParam))
//        }
//        parameters.merge(dict: makeCartParameters(cart))
//        
//        Analytics.logEvent(AnalyticsEventRemoveFromCart, parameters: parameters)
//    }
//    
//    public func removeAllCart(user: User) {
//        let parameters: [String: Any] = makeUserParameters(user)
//        Analytics.logEvent("remove_all_cart", parameters: parameters)
//    }
//    
//    public func buy(user: User, cart: Cart) {
//        var parameters: [String: Any] = makeUserParameters(user)
//        parameters.merge(dict: makeCartParameters(cart))
//    
//        Analytics.logEvent(AnalyticsEventPurchase, parameters: parameters)
//    }
//    
//    public func addProductReview(user: User, product: Product, review: Review) {
//        var parameters: [String: Any] = makeUserParameters(user)
//        parameters.merge(dict: makeProductParameters(product))
//        parameters.merge(dict: makeReviewParameters(review))
//        
//        Analytics.logEvent("add_product_review", parameters: parameters)
//    }
//    
//    public func addProductReview(user: User, product: ProductViewModel, review: Review) {
//        var parameters: [String: Any] = makeUserParameters(user)
//        parameters.merge(dict: makeProductParameters(product))
//        parameters.merge(dict: makeReviewParameters(review))
//        
//        Analytics.logEvent("add_product_review", parameters: parameters)
//    }
//    
//    public func removeProductReview(user: User, product: ProductViewModel, review: Review) {
//        var parameters: [String: Any] = makeUserParameters(user)
//        parameters.merge(dict: makeProductParameters(product))
//        parameters.merge(dict: makeReviewParameters(review))
//        
//        Analytics.logEvent("remove_product_review", parameters: parameters)
//    }
//    
//    public func removeProductReview(user: User, product: ProductViewModel, review: ReviewViewModel) {
//        var parameters: [String: Any] = makeUserParameters(user)
//        parameters.merge(dict: makeProductParameters(product))
//        let paramReview = Review(id: 0,
//                                 productId: product.id,
//                                 productName: product.titleCell.value,
//                                 userId: user.id,
//                                 userLogin: user.login,
//                                 comment: nil,
//                                 assessment: review.assessment,
//                                 date: Date().timeIntervalSince1970)
//        parameters.merge(dict: makeReviewParameters(paramReview))
//        
//        Analytics.logEvent("remove_product_review", parameters: parameters)
//    }
//    
//    // MARK: - Private
//    //
//    private func makeUserParameters(_ user: User) -> [String: Any] {
//        let parameters: [String: Any] = [
//            "User_id": user.id,
//            "User_login": user.login,
//            "User_email": user.email,
//            "User_creditCard": user.creditCard,
//            "User_gender": user.gender == "m" ? "мужчина" : "женщина"
//        ]
//        return parameters
//    }
//    
//    private func makeProductParameters(_ product: Product) -> [String: Any] {
//        let parameters: [String: Any] = [
//            "Product_id": product.id,
//            "Product_name": product.name,
//            "Product_category": product.category,
//            "Product_price": product.price
//        ]
//        return parameters
//    }
//    
//    private func makeProductParameters(_ product: ProductViewModel) -> [String: Any] {
//        let parameters: [String: Any] = [
//            "Product_id": product.id,
//            "Product_name": product.titleCell.value,
//            "Product_category": product.category,
//            "Product_price": product.priceCell.value
//        ]
//        return parameters
//    }
//    
//    private func makeCartParameters(_ cart: Cart) -> [String: Any] {
//        var parameters: [String: Any] = [:]
//        parameters["Cart_totalCartCount"] = cart.totalCartCount
//        parameters["Cart_totalPrice"] = cart.totalPrice
//        cart.items.forEach { item in
//            var value = ""
//            value += "name: \(item.product.name); "
//            value += "category: \(item.product.category); "
//            value += "price: \(item.product.price); "
//            value += "quantity: \(item.quantity) "
//            parameters["Cart_Product_id_\(item.product.id)"] = value
//        }
//        return parameters
//    }
//    
//    private func makeReviewParameters(_ review: Review) -> [String: Any] {
//        var parameters: [String: Any] = [:]
//        parameters["Review_Prodict_id"] = review.productId
//        parameters["Review_Prodict_name"] = review.productName
//        parameters["Review_Prodict_assessment"] = review.assessment
//        return parameters
//    }
//}
