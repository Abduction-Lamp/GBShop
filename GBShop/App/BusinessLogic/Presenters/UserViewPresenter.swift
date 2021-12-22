//
//  UserViewPresenter.swift
//  GBShop
//
//  Created by Владимир on 22.12.2021.
//

import Foundation

// MARK: - Protools
//
protocol UserPageViewProtocol: AnyObject {
    func showAlertRequestError(error: Error)
    func showAlertError(message: String)
    
    func setUserData(firstName: String,
                     lastName: String,
                     gender: Int,
                     email: String,
                     creditCard: String,
                     login: String,
                     password: String)
}

protocol UserPageViewPresenterProtool: AnyObject {
    init(router: RouterProtocol, view: UserPageViewProtocol, network: RequestFactory, user: User, token: String)
    func logout()
}

// MARK: - LoginView Presenter
//
class UserPageViewPresenter: UserPageViewPresenterProtool {
    private var router: RouterProtocol?
    private weak var view: UserPageViewProtocol?
    private let network: RequestFactory
    
    private let user: User
    private let token: String

    required init(router: RouterProtocol, view: UserPageViewProtocol, network: RequestFactory, user: User, token: String) {
        self.router = router
        self.view = view
        self.network = network
        
        self.user = user
        self.token = token
        
        DispatchQueue.main.async {
            let gender: Int = user.gender == "m" ? 0 : 1
            self.view?.setUserData(firstName: user.firstName,
                                   lastName: user.lastName,
                                   gender: gender,
                                   email: user.email,
                                   creditCard: user.creditCard,
                                   login: user.login,
                                   password: "")
        }
    }
    
    func logout() {
        let auth = network.makeAuthRequestFatory()
        auth.logout(id: user.id, token: token) { response in
            
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    if result.result == 1 {
                        print("2")
                        self.router?.popToRootViewController()
                    } else {
                        self.view?.showAlertError(message: result.message)
                    }
                case .failure(let error):
                    self.view?.showAlertRequestError(error: error)
                }
            }
        }
    }
}
