//
//  UserPageViewPresenter.swift
//  GBShop
//
//  Created by Владимир on 22.12.2021.
//

import Foundation

// MARK: - Protools
//
protocol UserPageViewProtocol: AbstractViewController {
    func setUserData(firstName: String,
                     lastName: String,
                     gender: Int,
                     email: String,
                     creditCard: String,
                     login: String,
                     password: String)
    func didChangeUserData()
}

protocol UserPageViewPresenterProtool: AnyObject {
    init(router: RouterProtocol, view: UserPageViewProtocol, network: RequestFactoryProtocol, user: User, token: String)
    func logout()
    func getUserData()
    func changeUserData(firstName: String,
                        lastName: String,
                        gender: Int,
                        email: String,
                        creditCard: String,
                        login: String,
                        password: String)
}

// MARK: - UserPageView Presenter
//
class UserPageViewPresenter: UserPageViewPresenterProtool {
    private var router: RouterProtocol?
    private weak var view: UserPageViewProtocol?
    private let network: RequestFactoryProtocol
    
    var user: User
    var isUserDataChange: Bool = false {
        didSet {
            if isUserDataChange {
                DispatchQueue.main.async {
                    self.view?.didChangeUserData()
                }
            }
        }
    }
    private let token: String

    required init(router: RouterProtocol, view: UserPageViewProtocol, network: RequestFactoryProtocol, user: User, token: String) {
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
                                   password: user.password)
        }
    }
    
    func getUserData() {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        logging("\(self) func getUserData()")
        DispatchQueue.main.async {
            let gender: Int = self.user.gender == "m" ? 0 : 1
            self.view?.setUserData(firstName: self.user.firstName,
                                   lastName: self.user.lastName,
                                   gender: gender,
                                   email: self.user.email,
                                   creditCard: self.user.creditCard,
                                   login: self.user.login,
                                   password: self.user.password)
        }
    }
    
    func logout() {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        let auth = network.makeAuthRequestFatory()
        auth.logout(id: user.id, token: token) { response in
            
            logging("[\(self) id: \(self.user.id) token: \(self.token)]")
            
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    logging("[\(self) result message: \(result.message)]")
                    if result.result == 1 {
                        self.router?.popToRootViewController()
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
    
    func changeUserData(firstName: String,
                        lastName: String,
                        gender: Int,
                        email: String,
                        creditCard: String,
                        login: String,
                        password: String) {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        guard let newUserData = makeUser(view: view,
                                         id: user.id,
                                         firstName: firstName,
                                         lastName: lastName,
                                         gender: gender,
                                         email: email,
                                         creditCard: creditCard,
                                         login: login,
                                         password: password) else { return }
        
        let userRequest = network.makeUserRequestFactory()
        userRequest.change(user: newUserData, token: token) { response in
            
            logging("[\(self) user: \(newUserData) token: \(self.token)]")
            
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    logging("[\(self) result message: \(result.message)]")
                    if let resulNewUserData = result.user {
                        self.user = resulNewUserData
                        self.view?.didChangeUserData()
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
}

extension UserPageViewPresenter: MakeUserFactory { }

extension UserPageViewPresenter: CustomStringConvertible {
    
    var description: String {
        " - UserPageViewPresenter (class):"
    }
}
