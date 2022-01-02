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
    func updataCart(count: Int)
    
    func updataUserDataInPresenter(user: User, token: String)
}

protocol CatalogViewPresenterProtocol: AnyObject {
    init(router: RouterProtocol, view: CatalogViewProtocol, network: RequestFactoryProtocol, user: User, token: String)
    
    func getCatalog(page: Int)
    func addCart(id: Int)
    
    func userPage()
    func updataUserData(user: User, token: String)
    
    func cart()
    func product(id: Int)
}

// MARK: - CatalogView Presenter
//
final class CatalogViewPresenter: CatalogViewPresenterProtocol {
    private var router: RouterProtocol?
    private weak var view: CatalogViewProtocol?
    private let network: RequestFactoryProtocol
    
    private var user: User
    private var token: String
    
    private var catalog: [Section]?

    // MARK: Initialization
    required init(router: RouterProtocol, view: CatalogViewProtocol, network: RequestFactoryProtocol, user: User, token: String) {
        self.router = router
        self.view = view
        self.network = network
        
        self.user = user
        self.token = token
        
        getCatalog(page: 0)
    }
    
    func userPage() {
        self.router?.pushUserPageViewController(user: user, token: token)
    }
    
    func cart() {
        return
    }
    
    func getCatalog(page: Int) {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        let request = network.makeProductRequestFactory()
        request.getCatalog(page: page) { response in
        
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    logging("[\(self) result message: \(result.message)]")
                    if result.result == 1 {
                        if let productList = result.catalog {
                            self.catalog = productList
                            self.view?.setCatalog(productList)
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
    
    func addCart(id: Int) {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        let request = network.makeCartRequestFactory()
        request.add(productId: id, owner: user.id, token: token) { response in
            
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    logging("[\(self) result message: \(result.message)]")
                    if result.result == 1 {
                        if let count = result.cart?.count {
                            self.view?.updataCart(count: count)
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
    
    func product(id: Int) {
        if let productList = catalog?.flatMap({ $0.items }),
        let product = productList.first(where: { $0.id == id }) {
            router?.pushProductViewController(user: user, token: token, product: product)
        }
    }
    
    func updataUserData(user: User, token: String) {
        self.user = user
        self.token = token
    }
}

extension CatalogViewPresenter: CustomStringConvertible {
    
    var description: String {
        " - CatalogViewPresenter (class):"
    }
}
