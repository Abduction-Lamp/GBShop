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
    func presentMainView()
}

protocol RegistrationViewPresenterProtool: AnyObject {
    init(view: RegistrationViewProtocol, network: UserRequestFactory)
    func makeUser(firstName: String,
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
    weak var view: RegistrationViewProtocol?
    private let network: UserRequestFactory
    
    required init(view: RegistrationViewProtocol, network: UserRequestFactory) {
        self.view = view
        self.network = network
    }
    
    func makeUser(firstName: String,
                  lastName: String,
                  gender: Int,
                  email: String,
                  creditCard: String,
                  login: String,
                  password: String) {
        
        guard !firstName.isEmpty else {
            view?.showAlertRegisterError(message: "Поле Имя не заполнено")
            return
        }
        guard !lastName.isEmpty else {
            view?.showAlertRegisterError(message: "Поле Фамилия не заполнено")
            return
        }
        guard !email.isEmpty else {
            view?.showAlertRegisterError(message: "Поле E-mail не заполнено")
            return
        }
        guard !creditCard.isEmpty else {
            view?.showAlertRegisterError(message: "Поле Кредитная Карта не заполнено")
            return
        }
        guard !login.isEmpty else {
            view?.showAlertRegisterError(message: "Поле Логин не заполнено")
            return
        }
        guard !password.isEmpty else {
            view?.showAlertRegisterError(message: "Поле Пароль не заполнено")
            return
        }
        guard email.isValidEmail() else {
            view?.showAlertRegisterError(message: "Не верный формат E-mail")
            return
        }
        guard creditCard.isValidCreditCard() else {
            view?.showAlertRegisterError(message: "Не верный формат Кредитной Карты")
            return
        }
        
        let user = User(id: 3,
                        login: login,
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        gender: gender == 0 ? "m" : "w",
                        creditCard: creditCard)
        register(user: user, password: password)
    }
    
    private func register(user: User, password: String) {
        network.register(user: user, password: password) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    if result.result == 1 {
                        self.view?.presentMainView()
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
