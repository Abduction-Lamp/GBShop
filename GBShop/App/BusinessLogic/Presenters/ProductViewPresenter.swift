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
    
    func setProduct(model: ProductViewModel)
    func setReview(model: [ReviewViewModel])
}

protocol ProductViewPresenterProtocol: AnyObject {
    init(router: RouterProtocol,
         view: ProductViewProtocol,
         network: RequestFactoryProtocol,
         user: User,
         token: String,
         product: Product)
    
    func goToCart()
    func addToCart()
    func getReview()
    func addReview(_ review: String)
    func removeReview()
}

final class ProductViewPresenter: ProductViewPresenterProtocol {
    
    private var router: RouterProtocol?
    private weak var view: ProductViewProtocol?
    private let network: RequestFactoryProtocol
    
    private let user: User
    private let token: String
    
    private var product: Product
    private var review: [Review]? {
        didSet {
            if let bounds = view?.bounds,
               let model = review?.map({ ReviewViewModel(bounds: bounds, review: $0) }) {
                DispatchQueue.main.async {
                    self.view?.setReview(model: model)
                }
            }
        }
    }

    // MARK: Initialization
    init(router: RouterProtocol, view: ProductViewProtocol, network: RequestFactoryProtocol, user: User, token: String, product: Product) {
        self.router = router
        self.view = view
        self.network = network
        self.user = user
        self.token = token
        self.product = product
        
        view.setProduct(model: ProductViewModel(bounds: view.bounds, product: product))
    }
}

extension ProductViewPresenter {

    func goToCart() {
        return
    }
    
    func getReview() {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        let request = network.makeReviewRequestFactory()
        request.reviewByProduct(id: product.id) { [weak self] response in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    logging("[\(self) result message: \(result.message)]")
                    if result.result == 1 {
                        self.review = result.review
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
                        self.view?.showErrorAlert(message: "В корзину добавлено: \(self.product.name)")
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
                               productName: product.name,
                               userId: user.id,
                               userLogin: user.login,
                               comment: review,
                               assessment: 0,
                               date: Date().timeIntervalSince1970)
        
        let request = network.makeReviewRequestFactory()
        request.reviewAdd(review: newReview, token: token) { response in
            
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    logging("[\(self) result message: \(result.message)]")
                    if result.result == 1,
                       let newReview = result.review?.first {
                        self.review?.append(newReview)
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
    
    func removeReview() {
        
    }
}

extension ProductViewPresenter: CustomStringConvertible {
    
    var description: String {
        " - ProductViewPresenter (class):"
    }
}
