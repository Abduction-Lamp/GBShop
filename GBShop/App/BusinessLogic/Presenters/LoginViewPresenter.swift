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
        network.login(login: login, password: password) { [weak self] response in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    if result.result == 1 {
                        guard let user = result.user,
                              let token = result.token else {
                               self.view?.showErrorAlert(message: result.message)
                                  return
                              }
                        self.router?.pushUserViewController(user: user, token: token)
                    } else {
                        self.view?.showErrorAlert(message: result.message)
                    }
                case .failure(let error):
                    self.view?.showRequestErrorAlert(error: error)
                }
            }
        }
    }
    
    func pushRegistrationViewController() {
        router?.pushRegistrationViewController()
    }
}
