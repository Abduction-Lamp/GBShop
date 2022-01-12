//
//  ProductViewPresenter.swift
//  GBShop
//
//  Created by Владимир on 28.12.2021.
//

import Foundation
import UIKit

// MARK: - Protools
//
protocol ProductViewProtocol: AbstractViewController {
    func setReviews()
    func updateCartIndicator(count: Int)
    
    var presenret: ProductViewPresenterProtocol? { get set }
}

protocol ProductViewPresenterProtocol: AnyObject {
    init(router: RouterProtocol,
         view: ProductViewProtocol,
         network: RequestFactoryProtocol,
         user: User,
         token: String,
         product: Product,
         cart: [Product])
    
    var product: ProductViewModel { get set }
    var review: [ReviewViewModel] { get set }
    var cartCoutn: Int { get }
    
    func getUserInfo() -> User
    func updateCart(cart: [Product])
    
    func backToCatalog()
    
    func goToCartView()
    func addToCart()
    
    func fetchReview()
    func addReview(_ review: String)
    func removeReview(id: Int)
}

// MARK: - ProductView Presenter
//
final class ProductViewPresenter: ProductViewPresenterProtocol {

    private var router: RouterProtocol?
    private weak var view: ProductViewProtocol?
    private let network: RequestFactoryProtocol
    
    private let user: User
    private let token: String
    
    private var cart: [Product]
    var cartCoutn: Int {
        return cart.count
    }
    
    var product: ProductViewModel
    var review: [ReviewViewModel] = []

    // MARK: Initialization
    init(router: RouterProtocol,
         view: ProductViewProtocol,
         network: RequestFactoryProtocol,
         user: User,
         token: String,
         product: Product,
         cart: [Product]) {
        
        self.router = router
        self.view = view
        self.network = network
        
        self.user = user
        self.token = token
        
        self.product = ProductViewModel(bounds: UIScreen.main.bounds, product: product)
        self.cart = cart
    }
}

extension ProductViewPresenter {

    func getUserInfo() -> User {
        return user
    }
    
    func updateCart(cart: [Product]) {
        self.cart = cart
        view?.updateCartIndicator(count: cart.count)
    }
    
    func backToCatalog() {
        router?.popToCatalogViewController(cart: self.cart)
    }
    
    func goToCartView() {
        router?.pushCartViewController(user: user, token: token, cart: cart)
    }
    
    func addToCart() {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        let request = network.makeCartRequestFactory()
        request.add(productId: product.id, owner: user.id, token: token) { [weak self] response in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    logging("[\(self) result message: \(result.message)]")
                    if result.result == 1 {
                        if let cart = result.cart {
                            self.cart = cart
                            self.view?.updateCartIndicator(count: self.cart.count)
                        } else {
                            self.view?.showErrorAlert(message: "Карзина пуста")
                        }
                    } else {
                        self.view?.showErrorAlert(message: result.message)
                    }
                case .failure(let error):
                    logging("[\(self) error: \(error.localizedDescription)]")
                    self.view?.showRequestErrorAlert(error: error)
                }
            }
        }
    }
  
    func fetchReview() {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        let request = network.makeReviewRequestFactory()
        request.reviewByProduct(id: product.id) { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let result):
                logging("[\(self) result message: \(result.message)]")
                
                if result.result == 1 {
                    if let reviews = result.review {
                        self.review = reviews.map({ ReviewViewModel(bounds: UIScreen.main.bounds, review: $0) })
                        DispatchQueue.main.async {
                            self.view?.setReviews()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.view?.showErrorAlert(message: result.message)
                    }
                }
            case .failure(let error):
                logging("[\(self) error: \(error.localizedDescription)]")
                DispatchQueue.main.async {
                    self.view?.showRequestErrorAlert(error: error)
                }
            }
        }
    }
    
    func addReview(_ review: String) {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        guard !review.isEmpty else {
            return
        }
        let newReview = Review(id: 0,
                               productId: product.id,
                               productName: product.titleCell.value,
                               userId: user.id,
                               userLogin: user.login,
                               comment: review,
                               assessment: 0,
                               date: Date().timeIntervalSince1970)
        
        let request = network.makeReviewRequestFactory()
        request.reviewAdd(review: newReview, token: token) { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let result):
                logging("[\(self) result message: \(result.message)]")
                if result.result == 1,
                   let newReview = result.review?.first {
                    self.review.append(ReviewViewModel(bounds: UIScreen.main.bounds, review: newReview))
                    DispatchQueue.main.async {
                        self.view?.setReviews()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.view?.showErrorAlert(message: result.message)
                    }
                }
            case .failure(let error):
                logging("[\(self) error: \(error.localizedDescription)]")
                DispatchQueue.main.async {
                    self.view?.showRequestErrorAlert(error: error)
                }
            }
        }
    }
    
    func removeReview(id: Int) {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        let request = network.makeReviewRequestFactory()
        request.reviewDelete(reviewId: id, userId: user.id, token: token) { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let result):
                logging("[\(self) result message: \(result.message)]")
                if result.result == 1,
                   let index = self.review.firstIndex(where: { $0.id == id }) {
                    self.review.remove(at: index)
                    DispatchQueue.main.async {
                        self.view?.setReviews()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.view?.showErrorAlert(message: result.message)
                    }
                }
            case .failure(let error):
                logging("[\(self) error: \(error.localizedDescription)]")
                DispatchQueue.main.async {
                    self.view?.showRequestErrorAlert(error: error)
                }
            }
        }
    }
}

extension ProductViewPresenter: CustomStringConvertible {
    
    var description: String {
        " - ProductViewPresenter (class):"
    }
}
