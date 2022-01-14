//
//  String.swift
//  GBShop
//
//  Created by Владимир on 21.12.2021.
//

import Foundation

extension String {
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-zА-Яа-я._%+-]+@[A-Za-z0-9А-Яа-я.-]+\\.[A-Za-zА-Яа-я]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isValidCreditCard() -> Bool {
        let cardRegEx = "[0-9]{4}+-[0-9]{4}+-[0-9]{4}+-[0-9]{4}"
        let cardPred = NSPredicate(format: "SELF MATCHES %@", cardRegEx)
        return cardPred.evaluate(with: self)
    }
}
