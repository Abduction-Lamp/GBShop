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
    func setProduct(name: String, category: String, price: Double, description: String?, imageURL: URL?)
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

    // MARK: Initialization``
    
    init(router: RouterProtocol, view: ProductViewProtocol, network: RequestFactoryProtocol, user: User, token: String, product: Product) {
        self.router = router
        self.view = view
        self.network = network
        self.user = user
        self.token = token
        self.product = product
        
        setProduct()
    }
    
    func cart() {
        return
    }
    
    private func setProduct() {
        // ПОДСЧЕТ РАЗМЕРОВ
        
        var imageURL: URL?
        if let urlString = product.imageURL {
            imageURL = URL(string: urlString)
        }
        view?.setProduct(name: product.name,
                         category: product.category,
                         price: product.price,
                         description: product.description,
                         imageURL: imageURL)
    }
}
