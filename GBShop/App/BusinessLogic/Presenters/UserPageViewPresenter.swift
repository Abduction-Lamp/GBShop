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
    func didChangeUserData()
    func setUserData(firstName: String,
                     lastName: String,
                     gender: Int,
                     email: String,
                     creditCard: String,
                     login: String,
                     password: String)
    func showLoadingScreen()
    func hideLoadingScreen()
}

protocol UserPageViewPresenterProtocol: AnyObject {
    init(router: RouterProtocol, view: UserPageViewProtocol, network: RequestFactoryProtocol, user: User, token: String)
    
    func backToCatalog()
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
final class UserPageViewPresenter: UserPageViewPresenterProtocol {
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

    private let reportExceptions = CrashlyticsReportExceptions()
    private let analytics = AnalyticsLog()
    
    // MARK: Initialization
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
}

extension UserPageViewPresenter: MakeUserFactory { }

extension UserPageViewPresenter {
    
    func backToCatalog() {
        router?.popToCatalogViewController(user: user, token: token)
    }
    
    func logout() {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        self.view?.showLoadingScreen()
        
        let auth = network.makeAuthRequestFactory()
        auth.logout(id: user.id, token: token) { [weak self] response in
            guard let self = self else { return }
            logging("[\(self) id: \(self.user.id) token: \(self.token)]")
            
            switch response.result {
            case .success(let result):
                logging("[\(self) result message: \(result.message)]")
                if result.result == 1 {
                    self.analytics.logout(user: self.user)
                    DispatchQueue.main.async {
                        self.view?.hideLoadingScreen()
                        self.router?.popToRootViewController()
                    }
                } else {
                    self.reportExceptions.report(login: self.user.login, code: .rejectionResult, result: result)
                    DispatchQueue.main.async {
                        self.view?.hideLoadingScreen()
                        self.view?.showErrorAlert(message: result.message)
                    }
                }
            case .failure(let error):
                logging("[\(self) error: \(error.localizedDescription)]")
                self.reportExceptions.report(error: error.localizedDescription)
                DispatchQueue.main.async {
                    self.view?.hideLoadingScreen()
                    self.view?.showRequestErrorAlert(error: error)
                }
            }
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
        
        self.view?.showLoadingScreen()
        
        let userRequest = network.makeUserRequestFactory()
        userRequest.change(user: newUserData, token: token) { [weak self] response in
            guard let self = self else { return }
            logging("[\(self) user: \(newUserData) token: \(self.token)]")
            
            switch response.result {
            case .success(let result):
                logging("[\(self) result message: \(result.message)]")
                if let resultNewUserData = result.user {
                    self.analytics.changeUser(old: self.user, new: resultNewUserData)
                    self.user = resultNewUserData
                    DispatchQueue.main.async {
                        self.view?.hideLoadingScreen()
                        self.view?.didChangeUserData()
                    }
                } else {
                    self.reportExceptions.report(user: newUserData, code: .rejectionResult, result: result)
                    DispatchQueue.main.async {
                        self.view?.hideLoadingScreen()
                        self.view?.showErrorAlert(message: result.message)
                    }
                }
            case .failure(let error):
                logging("[\(self) error: \(error.localizedDescription)]")
                self.reportExceptions.report(error: error.localizedDescription)
                DispatchQueue.main.async {
                    self.view?.hideLoadingScreen()
                    self.view?.showRequestErrorAlert(error: error)
                }
            }
        }
    }
}

extension UserPageViewPresenter: CustomStringConvertible {
    
    var description: String {
        " - UserPageViewPresenter (class):"
    }
}
