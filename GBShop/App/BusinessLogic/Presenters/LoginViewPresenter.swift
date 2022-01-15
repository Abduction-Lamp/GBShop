//
//  LoginViewPresenter.swift
//  GBShop
//
//  Created by Владимир on 20.12.2021.
//

import Foundation

// MARK: - Protools
//
protocol LoginViewProtocol: AbstractViewController {}

protocol LoginViewPresenterProtool: AnyObject {
    init(router: RouterProtocol, view: LoginViewProtocol, network: AuthRequestFactory)
    func auth(login: String, password: String)
    func pushRegistrationViewController()
}

// MARK: - LoginView Presenter
//
class LoginViewPresenter: LoginViewPresenterProtool {
    private var router: RouterProtocol?
    private weak var view: LoginViewProtocol?
    private let network: AuthRequestFactory

    required init(router: RouterProtocol, view: LoginViewProtocol, network: AuthRequestFactory) {
        self.router = router
        self.view = view
        self.network = network
    }
    
    func auth(login: String, password: String) {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }

        network.login(login: login, password: password) { [weak self] response in
            guard let self = self else { return }
            
            logging("[\(self) login: \(login), password: \(password)]")
            
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    logging("[\(self) result message: \(result.message)]")
                    if result.result == 1 {
                        guard let user = result.user,
                              let token = result.token else {
                               self.view?.showErrorAlert(message: result.message)
                                  return
                              }
                        self.router?.pushCatalogViewController(user: user, token: token)
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
    
    func pushRegistrationViewController() {
        router?.pushRegistrationViewController()
    }
}

extension LoginViewPresenter: CustomStringConvertible {
    
    var description: String {
        " - LoginViewPresenter (class):"
    }
}
