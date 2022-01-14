//
//  MakeUserFactory.swift
//  GBShop
//
//  Created by Владимир on 25.12.2021.
//

import Foundation

protocol MakeUserFactory {
    func makeUser(view: AbstractViewController?,
                  id: Int,
                  firstName: String,
                  lastName: String,
                  gender: Int,
                  email: String,
                  creditCard: String,
                  login: String,
                  password: String) -> User?
}

extension MakeUserFactory {
    
    func makeUser(view: AbstractViewController?,
                  id: Int,
                  firstName: String,
                  lastName: String,
                  gender: Int,
                  email: String,
                  creditCard: String,
                  login: String,
                  password: String) -> User? {
        
        guard !firstName.isEmpty else {
            view?.showErrorAlert(message: "Поле Имя не заполнено")
            return nil
        }
        guard !lastName.isEmpty else {
            view?.showErrorAlert(message: "Поле Фамилия не заполнено")
            return nil
        }
        guard !email.isEmpty else {
            view?.showErrorAlert(message: "Поле E-mail не заполнено")
            return nil
        }
        guard !creditCard.isEmpty else {
            view?.showErrorAlert(message: "Поле Кредитная Карта не заполнено")
            return nil
        }
        guard !login.isEmpty else {
            view?.showErrorAlert(message: "Поле Логин не заполнено")
            return nil
        }
        guard !password.isEmpty else {
            view?.showErrorAlert(message: "Поле Пароль не заполнено")
            return nil
        }
        guard password.count > 6 else {
            view?.showErrorAlert(message: "Короткий Пароль (меньше 7 символов)")
            return nil
        }
        guard email.isValidEmail() else {
            view?.showErrorAlert(message: "Не верный формат E-mail")
            return nil
        }
        guard creditCard.isValidCreditCard() else {
            view?.showErrorAlert(message: "Не верный формат Кредитной Карты")
            return nil
        }

        return User(id: id,
                    firstName: firstName,
                    lastName: lastName,
                    gender: gender == 0 ? "m" : "w",
                    email: email,
                    creditCard: creditCard,
                    login: login,
                    password: password)
    }
}
