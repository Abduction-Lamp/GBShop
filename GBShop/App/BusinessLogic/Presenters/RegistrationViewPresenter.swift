//
//  RegistrationViewPresenter.swift
//  GBShop
//
//  Created by Владимир on 21.12.2021.
//

import Foundation
import Firebase

// MARK: - Protools
//
protocol RegistrationViewProtocol: AbstractViewController {
    func showLoadingScreen()
    func hideLoadingScreen()
}

protocol RegistrationViewPresenterProtocol: AnyObject {
    init(router: RouterProtocol, view: RegistrationViewProtocol, network: UserRequestFactory)
    
    func registration(firstName: String, lastName: String, gender: Int, email: String, creditCard: String, login: String, password: String)
}

// MARK: - RegistrationView Presenter
//
final class RegistrationViewPresenter: RegistrationViewPresenterProtocol {
    
    private var router: RouterProtocol?
    weak var view: RegistrationViewProtocol?
    private let network: UserRequestFactory
    
    private var newUser: User?
    private var token: String?
    
    private let reportExceptions = CrashlyticsReportExceptions()
    private let analytics = AnalyticsLog()
    
    required init(router: RouterProtocol, view: RegistrationViewProtocol, network: UserRequestFactory) {
        self.router = router
        self.view = view
        self.network = network
    }
}

extension RegistrationViewPresenter: MakeUserFactory { }

extension RegistrationViewPresenter {
    
    func registration(firstName: String, lastName: String, gender: Int, email: String, creditCard: String, login: String, password: String) {
        newUser = makeUser(view: view,
                           id: 0,
                           firstName: firstName,
                           lastName: lastName,
                           gender: gender,
                           email: email,
                           creditCard: creditCard,
                           login: login,
                           password: password)
        
        guard let user = newUser else { return }
        requestRegister(user: user)
    }
    
    private func requestRegister(user: User) {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        self.view?.showLoadingScreen()
        
        network.register(user: user) { [weak self] response in
            guard let self = self else { return }
            logging("[\(self) \(user)]")
            
            switch response.result {
            case .success(let result):
                logging("[\(self) result message: \(result.message)]")
                if result.result == 1,
                   let newUser = result.user,
                   let token = result.token {
   
                    Crashlytics.crashlytics().setUserID("\(newUser.id)")
                    Analytics.setUserID("\(newUser.id)")
                    self.analytics.signup(user: newUser)
                    
                    self.newUser = newUser
                    DispatchQueue.main.async {
                        self.view?.hideLoadingScreen()
                        self.router?.pushCatalogViewController(user: newUser, token: token)
                    }
                } else {
                    self.reportExceptions.report(user: user, code: .rejectionResult, result: result)
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

extension RegistrationViewPresenter: CustomStringConvertible {
    
    var description: String {
        " - RegistrationViewPresenter (class):"
    }
}
