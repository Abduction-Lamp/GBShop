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
    func setReview(id: Int)
}

protocol ProductViewPresenterProtocol: AnyObject {
    init(router: RouterProtocol,
         view: ProductViewProtocol,
         network: RequestFactoryProtocol,
         user: User,
         token: String,
         product: Product)
    
    func cart()
}

final class ProductViewPresenter: ProductViewPresenterProtocol {
    private var router: RouterProtocol?
    private weak var view: ProductViewProtocol?
    private let network: RequestFactoryProtocol
    
    private let user: User
    private let token: String
    
    private var product: Product
    private var model: ProductViewModel

    // MARK: Initialization
    init(router: RouterProtocol, view: ProductViewProtocol, network: RequestFactoryProtocol, user: User, token: String, product: Product) {
        self.router = router
        self.view = view
        self.network = network
        self.user = user
        self.token = token
        self.product = product
        
        var imageURL: URL?
        if let urlString = product.imageURL {
            imageURL = URL(string: urlString)
        }
        var priceString = String(format: "%.0f", product.price)
        priceString += " \u{20BD}"
         
        self.model = ProductViewModel(bounds: view.bounds,
                                      title: product.name,
                                      category: product.category,
                                      imageURL: imageURL,
                                      description: product.description ?? "",
                                      price: priceString)
        setProduct()
    }
    
    func cart() {
        return
    }
    
    private func setProduct() {
        view?.setProduct(model: model)
    }
}
