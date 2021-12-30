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

    // MARK: Initialization
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
        guard let bounds = view?.bounds else { return }
        
        var imageURL: URL?
        if let urlString = product.imageURL {
            imageURL = URL(string: urlString)
        }
        var priceString = String(format: "%.0f", product.price)
        priceString += " \u{20BD}"
        
        let model = ProductViewModel(bounds: bounds,
                                     title: product.name,
                                     category: product.category,
                                     imageURL: imageURL,
                                     description: product.description ?? "",
                                     price: priceString)
        view?.setProduct(model: model)
    }
}
