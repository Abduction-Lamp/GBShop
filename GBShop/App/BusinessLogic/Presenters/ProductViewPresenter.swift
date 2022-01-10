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
    var bounds: CGRect { get }
    
    func setReviews()
    func updateCartIndicator(count: Int)
}

protocol ProductViewPresenterProtocol: AnyObject {
    init(router: RouterProtocol,
         view: ProductViewProtocol,
         network: RequestFactoryProtocol,
         user: User,
         token: String,
         product: Product)
    
    var product: ProductViewModel { get set }
    var review: [ReviewViewModel] { get set }
    
    func getUserInfo() -> User
    func getCartCountItems()
    
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
    
    var product: ProductViewModel
    var review: [ReviewViewModel] = []

    // MARK: Initialization
    init(router: RouterProtocol, view: ProductViewProtocol, network: RequestFactoryProtocol, user: User, token: String, product: Product) {
        self.router = router
        self.view = view
        self.network = network
        self.user = user
        self.token = token
        self.product = ProductViewModel(bounds: view.bounds, product: product)
    }
}

extension ProductViewPresenter {

    func getUserInfo() -> User {
        return user
    }
    
    func goToCartView() {
        router?.pushCartViewController(user: user, token: token)
    }
    
    func addToCart() {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        let request = network.makeCartRequestFactory()
        request.add(productId: product.id, owner: user.id, token: token) { response in
            
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    logging("[\(self) result message: \(result.message)]")
                    if result.result == 1 {
                        if let count = result.cart?.count {
                            self.view?.updateCartIndicator(count: count)
                        } else {
                            self.view?.updateCartIndicator(count: 0)
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
    
    private func fetchCart() {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        let request = network.makeCartRequestFactory()
        request.cart(owner: user.id, token: token) { [weak self] response in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    logging("[\(self) result message: \(result.message)]")
                    if result.result == 1 {
                        if let count = result.cart?.count {
                            self.view?.updateCartIndicator(count: count)
                        } else {
                            self.view?.updateCartIndicator(count: 0)
                        }
                    } else {
                        self.view?.updateCartIndicator(count: 0)
                    }
                case .failure(let error):
                    logging("[\(self) error: \(error.localizedDescription)]")
                    self.view?.showRequestErrorAlert(error: error)
                }
            }
        }
    }
    
    func getCartCountItems() {
        fetchCart()
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
                    if let reviews = result.review,
                       let bounds = self.view?.bounds {
                        self.review = reviews.map({ ReviewViewModel(bounds: bounds, review: $0) })
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
        request.reviewAdd(review: newReview, token: token) { response in
            
            switch response.result {
            case .success(let result):
                logging("[\(self) result message: \(result.message)]")
                if result.result == 1,
                   let newReview = result.review?.first,
                   let bounds = self.view?.bounds {
                    self.review.append(ReviewViewModel(bounds: bounds, review: newReview))
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
        request.reviewDelete(reviewId: id, userId: user.id, token: token) { response in
            
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
