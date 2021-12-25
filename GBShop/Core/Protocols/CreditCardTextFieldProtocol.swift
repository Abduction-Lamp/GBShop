//
//  CreditCardTextFieldProtocol.swift
//  GBShop
//
//  Created by Владимир on 25.12.2021.
//

import UIKit

protocol CreditCardTextFieldProtocol { }

extension CreditCardTextFieldProtocol where Self: UITextField {
    
    func formatter(_ characters: [CChar]) -> Bool {
        guard let count = self.text?.count else {
            return false
        }
        
        let backSpace = strcmp(characters, "\\b")
        if backSpace == -92 && count > 0 {
            self.text?.removeLast()
            return false
        }
        switch count {
        case 0, 1, 2, 3, 5, 6, 7, 8, 10, 11, 12, 13, 15, 16, 17, 18: break
        case 4, 9, 14: self.text?.append("-")
        default: return false
        }
        return true
    }
}

class CreditCardTextField: (UITextField & CreditCardTextFieldProtocol) { }
