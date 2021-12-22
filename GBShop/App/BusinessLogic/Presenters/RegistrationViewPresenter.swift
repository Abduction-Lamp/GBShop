//
//  RegistrationViewPresenter.swift
//  GBShop
//
//  Created by Владимир on 21.12.2021.
//

import Foundation

// MARK: - Protools
//
protocol RegistrationViewProtocol: AnyObject {
    func showAlertRequestError(error: Error)
    func showAlertRegisterError(message: String)
}

protocol RegistrationViewPresenterProtool: AnyObject {
    init(router: RouterProtocol, view: RegistrationViewProtocol, network: UserRequestFactory)
    func userRegistration(firstName: String,
                          lastName: String,
                          gender: Int,
                          email: String,
                          creditCard: String,
                          login: String,
                          password: String)
}

// MARK: - RegistrationView Presenter
//
class RegistrationViewPresenter: RegistrationViewPresenterProtool {
    private var router: RouterProtocol?
    weak var view: RegistrationViewProtocol?
    private let network: UserRequestFactory
    
    private var newUser: User?
    private var token: String?
    
    required init(router: RouterProtocol, view: RegistrationViewProtocol, network: UserRequestFactory) {
        self.router = router
        self.view = view
        self.network = network
    }
    
    func userRegistration(firstName: String,
                          lastName: String,
                          gender: Int,
                          email: String,
                          creditCard: String,
                          login: String,
                          password: String) {
        
        newUser = makeUser(firstName: firstName,
                           lastName: lastName,
                           gender: gender,
                           email: email,
                           creditCard: creditCard,
                           login: login,
                           password: password)
        guard let user = newUser else { return }
        register(user: user, password: password)
    }
    
    private func makeUser(firstName: String,
                          lastName: String,
                          gender: Int,
                          email: String,
                          creditCard: String,
                          login: String,
                          password: String) -> User? {
        
        guard !firstName.isEmpty else {
            view?.showAlertRegisterError(message: "Поле Имя не заполнено")
            return nil
        }
        guard !lastName.isEmpty else {
            view?.showAlertRegisterError(message: "Поле Фамилия не заполнено")
            return nil
        }
        guard !email.isEmpty else {
            view?.showAlertRegisterError(message: "Поле E-mail не заполнено")
            return nil
        }
        guard !creditCard.isEmpty else {
            view?.showAlertRegisterError(message: "Поле Кредитная Карта не заполнено")
            return nil
        }
        guard !login.isEmpty else {
            view?.showAlertRegisterError(message: "Поле Логин не заполнено")
            return nil
        }
        guard !password.isEmpty else {
            view?.showAlertRegisterError(message: "Поле Пароль не заполнено")
            return nil
        }
        guard email.isValidEmail() else {
            view?.showAlertRegisterError(message: "Не верный формат E-mail")
            return nil
        }
        guard creditCard.isValidCreditCard() else {
            view?.showAlertRegisterError(message: "Не верный формат Кредитной Карты")
            return nil
        }
        
        return User(id: 3,
                    login: login,
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    gender: gender == 0 ? "m" : "w",
                    creditCard: creditCard)
    }
    
    private func register(user: User, password: String) {
        network.register(user: user, password: password) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    if result.result == 1 {
                        self.router?.pushUserViewController(user: user, token: "")
                    } else {
                        self.view?.showAlertRegisterError(message: result.message)
                    }
                case .failure(let error):
                    self.view?.showAlertRequestError(error: error)
                }
            }
        }
    }
}
