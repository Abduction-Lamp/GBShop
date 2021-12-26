//
//  CatalogViewPresenter.swift
//  GBShop
//
//  Created by Владимир on 26.12.2021.
//

import Foundation

// MARK: - Protools
//
protocol CatalogViewProtocol: AbstractViewController {
    func setCatalog(_ catalog: [Section])
}

protocol CatalogViewPresenterProtool: AnyObject {
    init(router: RouterProtocol, view: CatalogViewProtocol, network: ProductRequestFactory, user: User, token: String)
    
    func userPage()
    func cart()
}

// MARK: - CatalogView Presenter
//
final class CatalogViewPresenter: CatalogViewPresenterProtool {
    private var router: RouterProtocol?
    private weak var view: CatalogViewProtocol?
    private let network: ProductRequestFactory
    
    private let user: User
    private let token: String
    
    private var catalog: [Section]?

    // MARK: Initialization
    required init(router: RouterProtocol, view: CatalogViewProtocol, network: ProductRequestFactory, user: User, token: String) {
        self.router = router
        self.view = view
        self.network = network
        
        self.user = user
        self.token = token
        getCatalog()
    }
    
    func userPage() {
        self.router?.pushUserPageViewController(user: user, token: token)
    }
    
    func cart() {
        return
    }
    
    private func getCatalog() {
        network.getCatalog(page: 0) { response in
            
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    if result.result == 1 {
                        if let productList = result.catalog {
                            self.catalog = productList
                            self.view?.setCatalog(productList)
                        }
                    } else {
                        self.view?.showErrorAlert(message: result.message)
                    }
                case .failure(let error):
                    self.view?.showRequestErrorAlert(error: error)
                }
            }
        }
    }
}

extension CatalogViewPresenter: CustomStringConvertible {
    
    var description: String {
        " - CatalogViewPresenter (class):"
    }
}
