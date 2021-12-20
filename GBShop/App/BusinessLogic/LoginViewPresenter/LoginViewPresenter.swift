//
//  LoginViewPresenter.swift
//  GBShop
//
//  Created by Владимир on 20.12.2021.
//

import Foundation

// MARK: - Protools
//
protocol LoginViewProtocol: AnyObject {
    func showAlertRequestError(error: Error)
    func showAlertAuthError(message: String)
    func presentMainView()
    func presentRegistrationView()
}

protocol LoginViewPresenterProtool: AnyObject {
    init(view: LoginViewProtocol, network: AuthRequestFactory)
    func auth(login: String, password: String)
}

// MARK: - LoginView Presenter
//
class LoginViewPresenter: LoginViewPresenterProtool {
    weak var view: LoginViewProtocol?
    private let network: AuthRequestFactory
    
    required init(view: LoginViewProtocol, network: AuthRequestFactory) {
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
                        self.view?.presentMainView()
                    } else {
                        self.view?.showAlertAuthError(message: result.message)
                    }
                case .failure(let error):
                    self.view?.showAlertRequestError(error: error)
                }
            }
        }
    }
}
